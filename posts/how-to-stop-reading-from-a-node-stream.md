<!--
title: I found a clean way to stop reading from a Node.js stream
created: 2 April 2017 - 4:12 pm
updated: 6 May 2017 - 11:41 am
publish: 6 May 2017
slug: stop-streaming
tags: nodejs, stream, csv
cta: node-notes
-->

The [fast-csv][] Node module makes it easy to parse .list files from the [DARPA
Intrusion Detection Data Sets][darpa]. Set the `delimiter` option to a space
character and you're good to go.

    #!/usr/bin/env node

    const fs = require('fs');
    const csv = require('fast-csv');

    const csvFile = process.argv[2];
    const fileStream = fs.createReadStream(csvFile);
    const csvParser = csv({'delimiter': ' '});

    let lines = 0;

    csvParser.on('data', function (line) {
      lines += 1;
      console.log(line.join(' '));
    });

    csvParser.on('end', function () {
      console.log(`read ${lines} lines`);
    });

    fileStream.pipe(csvParser);

Here's output from that code running on example data.

    $ node darpa-parser.js bsm.list
    1 01/23/1998 16:56:48 00:01:26 telnet 1754 23 192.168.1.30 192.168.0.20 0 -
    2 01/23/1998 16:56:51 00:00:14 ftp 1755 21 192.168.1.30 192.168.0.20 0 -
    10 01/23/1998 16:57:02 00:01:00 telnet 1769 23 192.168.1.30 192.168.0.20 0 -
    12 01/23/1998 16:57:12 00:00:03 finger 1772 79 192.168.1.30 192.168.0.20 0 -
    13 01/23/1998 16:57:22 00:00:03 smtp 1778 25 192.168.1.30 192.168.0.20 0 -
    14 01/23/1998 16:57:23 00:00:03 smtp 1783 25 192.168.1.30 192.168.0.20 0 -
    20 01/23/1998 16:57:00 00:01:11 telnet 43496 23 192.168.0.40 192.168.0.20 0 -

    ... many lines later ...

    270 01/23/1998 17:04:29 00:00:05 exec 2032 512 192.168.1.30 192.168.0.20 1 port-scan
    308 01/23/1998 17:05:08 00:00:37 telnet 1042 23 192.168.1.30 192.168.0.20 0 -
    310 01/23/1998 17:05:31 00:00:01 smtp 1048 25 192.168.1.30 192.168.0.20 0 -
    311 01/23/1998 17:06:00 00:00:01 finger 1050 79 192.168.1.30 192.168.0.20 0 -
    read 64 lines


But those .list files can get pretty big, and you might not want to parse the
entire thing. If you want to stop the first time you see the `smtp` program, you
can try emitting an `end` event.

    if (line[4] === 'smtp') {
      csvParser.emit('end');
    }

Let's put those three lines after the first `console.log` statement and run the
program again.

    $ node darpa-parser.js bsm.list
    1 01/23/1998 16:56:48 00:01:26 telnet 1754 23 192.168.1.30 192.168.0.20 0 -
    2 01/23/1998 16:56:51 00:00:14 ftp 1755 21 192.168.1.30 192.168.0.20 0 -
    10 01/23/1998 16:57:02 00:01:00 telnet 1769 23 192.168.1.30 192.168.0.20 0 -
    12 01/23/1998 16:57:12 00:00:03 finger 1772 79 192.168.1.30 192.168.0.20 0 -
    13 01/23/1998 16:57:22 00:00:03 smtp 1778 25 192.168.1.30 192.168.0.20 0 -
    read 5 lines
    14 01/23/1998 16:57:23 00:00:03 smtp 1783 25 192.168.1.30 192.168.0.20 0 -
    20 01/23/1998 16:57:00 00:01:11 telnet 43496 23 192.168.0.40 192.168.0.20 0 -

    ... many lines later ...

    270 01/23/1998 17:04:29 00:00:05 exec 2032 512 192.168.1.30 192.168.0.20 1 port-scan
    308 01/23/1998 17:05:08 00:00:37 telnet 1042 23 192.168.1.30 192.168.0.20 0 -
    310 01/23/1998 17:05:31 00:00:01 smtp 1048 25 192.168.1.30 192.168.0.20 0 -
    311 01/23/1998 17:06:00 00:00:01 finger 1050 79 192.168.1.30 192.168.0.20 0 -

Oops. That didn't stop the processing, it just moved the output. Fortunately,
[streams in Node][streams] can be paused and resumed. Calling `csvParser.pause()`
instead might get us what we want.


    if (line[4] === 'smtp') {
      csvParser.pause();
    }

Let's replace the if statement we added with this one and run our code again.

    $ node darpa-parser.js bsm.list
    1 01/23/1998 16:56:48 00:01:26 telnet 1754 23 192.168.1.30 192.168.0.20 0 -
    2 01/23/1998 16:56:51 00:00:14 ftp 1755 21 192.168.1.30 192.168.0.20 0 -
    10 01/23/1998 16:57:02 00:01:00 telnet 1769 23 192.168.1.30 192.168.0.20 0 -
    12 01/23/1998 16:57:12 00:00:03 finger 1772 79 192.168.1.30 192.168.0.20 0 -
    13 01/23/1998 16:57:22 00:00:03 smtp 1778 25 192.168.1.30 192.168.0.20 0 -

That's closer. The processing stopped, but it didn't print out how many lines
where read. If we combine the two, we might get what we want. We'll call
`pause()` first to stop the stream, and then `emit()` to trigger the printing.

    if (line[4] === 'smtp') {
      csvParser.pause();
      csvParser.emit('end');
    }

Let's replace the if statement with this one and run the program one more time.

    $ node darpa-parser.js bsm.list
    1 01/23/1998 16:56:48 00:01:26 telnet 1754 23 192.168.1.30 192.168.0.20 0 -
    2 01/23/1998 16:56:51 00:00:14 ftp 1755 21 192.168.1.30 192.168.0.20 0 -
    10 01/23/1998 16:57:02 00:01:00 telnet 1769 23 192.168.1.30 192.168.0.20 0 -
    12 01/23/1998 16:57:12 00:00:03 finger 1772 79 192.168.1.30 192.168.0.20 0 -
    13 01/23/1998 16:57:22 00:00:03 smtp 1778 25 192.168.1.30 192.168.0.20 0 -
    read 5 lines

That did it! Stream processing stopped early and the `end` event handler was
called. This sort of thing can be useful if you encounter erorrs when parsing
files and want to halt processing early. And it's not just for reading files.
This pause and emit trick works for writable streams too.


[streams]: https://nodejs.org/dist/latest-v6.x/docs/api/stream.html "Various (Node): Node.js v6.10.1 Documentation - Stream"
[darpa]: https://www.ll.mit.edu/ideval/data/ "Various (MIT Lincoln Laboratory): DARPA Intrusion Detection Data Sets"
[fast-csv]: http://c2fo.github.io/fast-csv "C2FO (GitHub): CSV parser for Node"
