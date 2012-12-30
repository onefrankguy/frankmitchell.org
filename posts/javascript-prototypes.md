<!--
title: I bring you prototypes and deeper understanding
date: 11 October 2010
slug: javascript-prototypes
-->

Around Chapter 3 of [*JavaScript: The Good Parts*][jsbook], Douglas Crockford
says,

> JavaScript includes a prototype linkage feature that allows one object to
> inherit the properties of another. When used well, this can reduce object
> initialization time and memory consumption.

Unfortunately, he doesn't give a concrete example of that reduction. Prototype
inkage is explained fairly well in Chapter 5, but the concept of a prototype
linkage that's "used well" didn't click for me until I spent some time [looking
at how Prolix evolved][small].

## Telling a story with numbers ##

Here's a numerical recap. The prototypical trie code I started with was 1,045
bytes and it took 0.285 seconds to execute. The functional code I ended with was
677 bytes and took 0.448 seconds to execute. So the prototypical version wins on
speed and the functional version wins on size.

The best of both worlds is code that's small and fast. We can get there if we
take advantage of JavaScript's prototype linkage.

    var trie = function () {
      var Trie = function () {
        this.kids = [];
        this.words = 0;
        this.prefixes = 0;
      };

      Trie.prototype = {
        add: function (word) {
          if (word) {
            this.prefixes += 1;
            var i = word.charAt(0);
            if (!this.kids[i]) {
              this.kids[i] = new Trie();
            }
            this.kids[i].add(word.slice(1));
          } else {
            this.words += 1;
          }
        },

        hasPrefix: function (word) {
          if (!word) {
            return this.prefixes !== 0;
          }
          var i = word.charAt(0);
          if (!this.kids[i]) {
            return false;
          }
          return this.kids[i].hasPrefix(word.slice(1));
        },

        hasWord: function (word) {
          if (!word) {
            return this.words !== 0;
          }
          var i = word.charAt(0);
          if (!this.kids[i]) {
            return false;
          }
          return this.kids[i].hasWord(word.slice(1));
        }
      };

      return new Trie();
    };

The code above is 813 bytes, and it executes in 0.289 seconds. That makes it
1.29 times smaller than the original and only 1.01 times slower. The almost
1.55x speed improvement over the functional version makes the extra 136 bytes
worth it, since that translates into visible seconds when you run [Prolix][]
on a phone.

## I bring you deeper understanding ##

The nugget of insight here is that a functional construction pattern in
JavaScript has to create new functions for an object every time it's called.
Prototypical inheritance lets functions be reused, which can really speed things
up if you're creating a lot of objects.

However, I'm still not a big fan of the excessive `this` verbiage that
prototypical inheritance brings. For now, I'll stick with a functional style
unless (as is the case here) other methods offer measurable advantages.

[jsbook]: http://oreilly.com/catalog/9780596517748 "JavaScript: The Good Parts - O'Reilly Media"
[small]: /2010/09/small-code '"Bytes matter on the mobile web" by Frank Mitchell'
[Prolix]: http://prolix-app.com/ "A tweetable iPhone word search game"
