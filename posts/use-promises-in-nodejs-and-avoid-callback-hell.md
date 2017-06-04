<!--
title: Use promises in Node.js and avoid callback hell
created: 17 May 2017 - 10:15 pm
updated: 4 June 2017 - 7:44 am
publish: 4 JUne 2017
slug: promise-objects
tags: nodejs, promises, callbacks
cta: node-notes
-->

Callback hell is an easy JavaScript anti-pattern to recognize. There will be
a trail of closing braces, parenthesis, and semicolons at the end of your code.
For example, here's a `rsync` like program written with callbacks.

    #!/usr/bin/env node

    const fs = require('fs');

    const file1 = process.argv[2];
    const file2 = process.argv[3];

    fs.stat(file1, (err, stats1) => {
      if (err) {
        stats1 = {size: 0, mtime: Date.now()};
      }

      fs.stat(file2, (err, stats2) => {
        if (err) {
          stats2 = {size: 0, mtime: Date.now()};
        }

        if (stats1.size === stats2.size) {
          const time1 = stats1.mtime.getTime();
          const time2 = stats2.mtime.getTime();

          if (time1 <= time2) {
            console.log('sent 0 bytes');
            process.exit(0);
          }
        }

        fs.readFile(file1, (err, data) => {
          if (err) {
            console.error(err);
            process.exit(1);
          }

          fs.writeFile(file2, data, (err) => {
            if (err) {
              console.error(err);
              process.exit(1);
            }

            console.log(`sent ${data.size} bytes`);
          });
        });
      });
    });

Notice all the `});` characters at the end? That's callback hell. This code has
four logging statements, three early returns, and a cascade of nested functions.
Lucky for us, Node supports [`Promise` objects][promise], so there's a way to
refactor this.

The first thing we can tackle is the `fs.writeFile` call. We log the number of
bytes written if the write is successful. We log an error and exit the program
if the write fails. This maps nicely onto promises.

    function writeFile(path, data) {
      return new Promise((resolve, reject) => {
        fs.writeFile(path, data, (err) => {
          if (err) {
            return reject(err);
          }
          resolve(data.length);
        });
      });
    }

Here's what the business logic of our program looks like when we rewrite it to
use our new `writeFile` function.

    fs.stat(file1, (err, stats1) => {
      if (err) {
        stats1 = {size: 0, mtime: Date.now()};
      }

      fs.stat(file2, (err, stats2) => {
        if (err) {
          stats2 = {size: 0, mtime: Date.now()};
        }

        if (stats1.size === stats2.size) {
          const time1 = stats1.mtime.getTime();
          const time2 = stats2.mtime.getTime();

          if (time1 <= time2) {
            console.log('sent 0 bytes');
            process.exit(0);
          }
        }

        fs.readFile(file1, (err, data) => {
          if (err) {
            console.error(err);
            process.exit(1);
          }

          writeFile(file2, data).then(size => {
            console.log(`sent ${size} bytes`);
          }).catch(err => {
            console.log(err);
            process.exit(1);
          });
        });
      });
    });

Notice that we didn't remove any levels of function nesting. That's because
promises take `then` and `catch` callbacks. So we'll always have at
least one level of nesting.

To remove those `});` bits at the end, we need to take the next step and rewrite
the `fs.readFile` call. Since we return the data if the read's successful, and
log an error if the read fails, converting file reading to use promises is also
simple.

    function readFile(path) {
      return new Promise((resolve, reject) => {
        fs.readFile(path, (err, data) => {
          if (err) {
            return reject(err);
          }
          resolve(data);
        });
      });
    }

Here's what the core of our program looks like when we rewrite it to use our new
`readFile` function. There's now only three levels of function nesting instead
of four.

    fs.stat(file1, (err, stats1) => {
      if (err) {
        stats1 = {size: 0, mtime: Date.now()};
      }

      fs.stat(file2, (err, stats2) => {
        if (err) {
          stats2 = {size: 0, mtime: Date.now()};
        }

        if (stats1.size === stats2.size) {
          const time1 = stats1.mtime.getTime();
          const time2 = stats2.mtime.getTime();

          if (time1 <= time2) {
            console.log('sent 0 bytes');
            process.exit(0);
          }
        }

        readFile(file1).then(data => {
          return writeFile(file2, data);
        }).then(size => {
          console.log(`sent ${size} bytes`);
        }).catch(err => {
          console.log(err);
          process.exit(1);
        });
      });
    });

Plus, we have one error handler instead of two. The `catch` callback handles the
error cases for both reading and writing files. We still have an early return,
but we can use [`Promise.resolve`][resolve] to eliminate that.

`Promise.resolve` turns a value into a promise. We can use `null` as a marker
for the early return case, where file size is the same and file modification
time hasn't changed. Then we can do an extra check to make sure we have data
before trying to write it.

    fs.stat(file1, (err, stats1) => {
      if (err) {
        stats1 = {size: 0, mtime: Date.now()};
      }

      fs.stat(file2, (err, stats2) => {
        if (err) {
          stats2 = {size: 0, mtime: Date.now()};
        }

        let promise = readFile(file1);

        if (stats1.size === stats2.size) {
          const time1 = stats1.mtime.getTime();
          const time2 = stats2.mtime.getTime();

          if (time1 <= time2) {
            promise = Promise.resolve(null);
          }
        }

        promise.then(data => {
          if (!data) {
            return 0;
          }

          return writeFile(file2, data);
        }).then(size => {
          console.log(`sent ${size} bytes`);
        }).catch(err => {
          console.log(err);
          process.exit(1);
        });
      });
    });

Promises are smart. They'll ensure anything returned from a `then` callback is a
promise. Even though we sometimes return zero and sometimes return a `Promise`
object, it's always safe to call `then` on the result and log the number of
bytes written.

The last thing to rewrite is the `fs.stat` calls . If there's an error, we
pretend that the file is empty and brand new. That covers edge cases where the
files we're working with can't be accessed or don't exist.

    function stat(path) {
      return new Promise((resolve) => {
        fs.stat(path, (err, result) => {
          if (err) {
            result = {size: 0, mtime: Date.now()};
          }
          resolve(result);
        });
      });
    }

Because we're handling errors, we don't need a `reject` callback. If the
`fs.stat` call throws, our promise will bubble the exception up to any `catch`
callback chained onto it. This means we can keep all the error handling code in
one place.

We need to call our `stat` function twice, once for each file. And we need to
wait until both calls resolve before doing anything else. [`Promise.all`][all]
takes care of that. It waits until both `stat` calls resolve and returns their
results as an array.

    Promise.all([stat(file1), stat(file2)]).then(stats => {
      if (stats[0].size === stats[1].size) {
        const time1 = stats[0].mtime.getTime();
        const time2 = stats[1].mtime.getTime();

        if (time1 <= time2) {
          return null;
        }
      }

      return readFile(file1);
    }).then(data => {
      if (!data) {
        return 0;
      }

      return writeFile(file2, data);
    }).then(size => {
      console.log(`sent ${size} bytes`);
    }).catch(err => {
      console.log(err);
      process.exit(1);
    });

This refactored code has a single level of function nesting. It keeps logging to
a minimum and avoids early returns. We could take it a step further and move
stuff like the time comparison logic into its own function. But this is a good
stopping point for now.

I tend to work from the inside out when doing this kind of refactoring. That's
because it's often easy to change an existing callback to return a promise.
Going the other way, having a promise call a callback, can get messy. Try both
ways and see which you prefer. There's no wrong way to excape callback hell.


[promise]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise "Various (Mozilla Developer Network): Promise - JavaScript"
[resolve]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/resolve "Various (Mozilla Developer Network): Promise.resolve() - JavaScript"
[all]:https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/all "Various (Mozilla Developer Network): Promise.all() - JavaScript"

