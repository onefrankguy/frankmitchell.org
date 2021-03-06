<!--
title: Validate SSL certificates in Node.js without getting uncaught exceptions
created: 8 April 2017 - 10:25 am
updated: 29 April 2017 - 11:29 am
publish: 29 April 2017
slug: bad-passphrase
tags: nodejs, tls
cta: node-notes
-->

Node's [https module][https] makes it easy to spin up a server with TLS. Use
OpenSSL to generate a certificate and you're good to go.

    $ openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 1
    $ openssl pkcs12 -export -in cert.pem -inkey key.pem -out server.pfx

Here's JavaScript for starting a HTTPS server with a SSL certificate.

    #!/usr/bin/env node

    const fs = require('fs');
    const https = require('https');

    const options = {
      pfx: fs.readFileSync('./server.pfx'),
      passphrase: process.argv[2]
    };

    const server = https.createServer(options, (_, res) => {
      res.writeHead(200);
      res.end('hello world\n');
    });

    server.listen(8080, '127.0.0.1');
    console.log('Server listening on 127.0.0.1:8080');

But what if the passphrase is wrong? Running the code above with a passphrase
that doesn't match the one in the certificate generates an error.

    $ node server.js Passw0rd
    _tls_common.js:137
      c.context.loadPKCS12(pfx, passphrase);
                ^

    Error: mac verify failure
      at Error (native)
      at Object.createSecureContext (_tls_common.js:137:17)
      at Server (_tls_wrap.js:776:25)
      at new Server (https.js:26:14)
      at Object.exports.createServer (https.js:47:10)
      at Object.<anonymous> (./server.js:11:22)
      at Module._compile (module.js:570:32)
      at Object.Module._extensions..js (module.js:579:10)
      at Module.load (module.js:487:32)
      at tryModuleLoad (module.js:446:12)

We can try to gracefully handle that error, by listening for `error` events on
the server.

    server.on('error', (err) => {
      console.error('There was a server error!', err);
    });

Adding the code above before the `server.listen()` call and rerunning the
program doesn't help. We get the same error message. Looking at the stack trace,
we can see the failure is happening in the `https.createServer()` call, before
our server error handler is registered.

We could use `process.on('uncaughtException')` and register a high level error
handler.

    process.on('uncaughtException', (err) => {
      console.error('Uncaught exception!', err);
      process.exit(1);
    });

That would catch the bad passphrase, but it wouldn't give us the oportunity to
recover from it. Once an uncaught exception is thrown, the only safe option is
to exit the program. Ideally, we want is to catch the bad passphrase before we
create the server.

Looking at the stack trace gives us a clue. The error is being thrown from
`tls.createSecureContext()` in the [tls module][tls]. What if we called that
ourselves before creating the server?

    try {
      const tls = require('tls');
      tls.createSecureContext(options);
    } catch (err) {
      console.error('There was a TLS error!', err.message);
      console.error('Did you enter the right passphrase?');
      process.exit(1);
    }

Adding the code above before the `https.createServer()` call and rerunning the
program fixes it. Now the user's prompted with a helpful error message.

    $ node server.js Passw0rd
    There was a TLS error! mac verify failure
    Did you enter the right passphrase?

And if we enter the right passphrase, the server starts succesfully.

    $ node server.js rosebud
    HTTPS server listening on 127.0.0.1:8080


[https]: https://nodejs.org/dist/latest-v6.x/docs/api/https.html "Various (Node): Node v6.x Documentation - HTTPS"
[tls]: https://nodejs.org/dist/latest-v6.x/docs/api/tls.html "Various (Node): Node v6.x Documentation - TLS"
