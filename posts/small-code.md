<!--
title:  Bytes matter on the mobile web
date: 20 September 2010
slug: small-code
-->
When I started writing [Prolix][], I knew it was going to be big. My original
dictionary had 81,536 words, and the first version I wrote crashed [Jacob's][]
iPhone. At the time I knew nothing about JavaScript, so my code was slow and
ugly to boot. But I [learned a few things][book], and now Prolix contains 40,871
words and runs just fine.

This is the story about how I got there.

## Giving trees a try ##

When it comes to writing software, picking a good data structure is half the
battle. The obvious choice for word storage is a [prefix tree][]. Putting words
in and checking if words exist is fast, and it takes up a minimal amount of
space. Because I knew nothing about JavaScript at the time, I decided to see if
someone had already built one. Both to save myself time, and because it would
give me some code to study. [Dennis Byrne][] had a nice implementation, so I
started there.

    var Prolix = {};

    Prolix.Trie = function () {
      this.wordCount = 0;
      this.prefixCount = 0;
      this.children = [];
    };

    Prolix.Trie.prototype.add = function (word) {
      if (word) {
        this.prefixCount += 1;
        var i = word.charAt(0);
        if (!this.children[i]) {
          this.children[i] = new Prolix.Trie();
        }
        this.children[i].add(word.substring(1));
      } else {
        this.wordCount += 1;
      }
    };

    Prolix.Trie.prototype.getPrefixCount = function (word) {
      if (word) {
        return this.getCount(word, arguments.callee);
      }
      return this.prefixCount;
    };

    Prolix.Trie.prototype.getWordCount = function (word) {
      if (word) {
        return this.getCount(word, arguments.callee);
      }
      return this.wordCount;
    };

    Prolix.Trie.prototype.getCount = function (word, method) {
      var i = word.charAt(0);
      if (this.children[i]) {
        method.call(this.children[i], word.substring(1));
      }
      return 0;
    };

    Prolix.Trie.prototype.hasWord = function (word) {
      return this.getWordCount(word) !== 0;
    };

    Prolix.Trie.prototype.hasPrefix = function (word) {
      return this.getPrefixCount(word) !== 0;
    };

When it comes to writing code for the mobile web, bytes matter. Not as much as
readability and maintainability, but they still matter. The code above is 1,045
bytes and it takes 0.285 seconds to load 81,536 words. That was my first version
the one that crashed the iPhone.

## More functional but less classy ##

After reading [Crockford's book][] I learned that pseudo classical inheritance
wasn't the only option JavaScript offered. Better armed with knowledge, I
refactored my code to a more functional pattern.

    var trie = function () {
      var that = {},
        kids = [],
        wordCount = 0,
        prefixCount = 0;

      that.add = function (word) {
        if (word) {
          prefixCount += 1;
          var i = word.charAt(0);
          if (!kids[i]) {
            kids[i] = trie();
          }
          kids[i].add(word.slice(1));
        } else {
          wordCount += 1;
        }
      };

      that.getPrefixCount = function (word) {
        if (!word) {
          return prefixCount;
        }
        var i = word.charAt(0);
        if (kids[i]) {
          return kids[i].getPrefixCount(word.slice(1));
        }
        return 0;
      };

      that.getWordCount = function (word) {
        if (!word) {
          return wordCount;
        }
        var i = word.charAt(0);
        if (kids[i]) {
          return kids[i].getWordCount(word.slice(1));
        }
        return 0;
      };

      that.hasWord = function (word) {
        return this.getWordCount(word) !== 0;
      };

      that.hasPrefix = function (word) {
        return this.getPrefixCount(word) !== 0;
      };

      return that;
    };

The reasoning for my refactoring, was that the `trie` function that holds the
dictionary eventually gets extended with a `load` function that handles reading
in words. I felt the functional pattern captured that concept better.

In order to make [JSLint][] happy, I eliminated the `getCount` function so I
wasn't using `arguments.callee`. And I changed `children` to `kids` and
`substring` to `slice` in order to save a few bytes.

The code above is 863 bytes and it takes 0.627 seconds to load 81,536 words. So
it's less bytes than the first version, but at the expense of running 2.2 times
slower.

## We're not going to need that ##

Reading through my code, I realized that I wasn't doing anything special with
`that`. Plus, I saw that `getPrefixCount` and `getWordCount` were only being
used by `hasWord` and `hasPrefix`. So I refactored again to eliminate those
redundancies and return a created object directly.

    var trie = function () {
      var kids = [], words = 0, prefixes = 0;

      return {
        add: function (word) {
          if (word) {
            prefixes += 1;
            var i = word.charAt(0);
            if (!kids[i]) {
              kids[i] = trie();
            }
            kids[i].add(word.slice(1));
          } else {
            words += 1;
          }
        },

        hasPrefix: function (word) {
          if (!word) {
            return prefixes !== 0;
          }
          var i = word.charAt(0);
          if (!kids[i]) {
            return false;
          }
          return kids[i].hasPrefix(word.slice(1));
        },

        hasWord: function (word) {
          if (!word) {
            return words !== 0;
          }
          var i = word.charAt(0);
          if (!kids[i]) {
            return false;
          }
          return kids[i].hasWord(word.slice(1));
        }
      };
    };

Weighing in at 677 bytes, the version above takes 0.448 seconds to load all
81,536 words. That makes it 1.54 times smaller and 1.57 times slower than the
first version. Personally, I'm willing to take the speed hit in exchange for
simpler code that only does what's needed.

## Putting leaves on a tree ##

Initially the code that loaded words into my trie was simple.

    prolix.load = function (words) {
      var i;
      for (i = 0; i &amp;lt; words.length; i += 1) {
        dictionary.load(words[i]);
      }
    };

    prolix.load(['AARDVARK','ABACI'...'AZURES']);
    // 24 lines later...
    prolix.load(['ZANIER','ZANIES'...'ZYMURGY']);

I wrote a little bit of Ruby to read words from a file and generate the code
above. After it read 81,536 words, the resulting JavaScript was 953,209 bytes.
I'm pretty sure the stress of loading that much code was what caused Jacob's
iPhone to crash.

So I did some thinking and played around with different compression ideas. I
tried storing the words as a <abbr title="JavaScript Object Notation">JSON</abbr>
object, but with all the added markup, it wasn't any smaller.

Then I realized I didn't need to store each individual word in an array, I just
needed one big string with a delimiter for the words.

    prolix.load = function (list) {
      var i, words = list.split(',');
      for (i = 0; i &amp;lt; words.length; i += 1) {
        dictionary.load(words[i]);
      }
    };

    prolix.load('AARDVARK,ABACI...AZURES');
    // 24 lines later...
    prolix.load('ZANIER,ZANIES...ZYMURGY');

The resulting code was 790,085 bytes. It was still too big, so I whittled the
dictionary down to words that were between 4 and 8 characters. That got the
dictionary code down to 311,334 bytes. Load times were finally reasonable.

## Prefixes, they aren't just for trees any more ##

Once people started playing, I noticed the first thing everyone did was try to
spell a three letter word. When it didn't work (because I'd limited the
dictionary size) they got confused. I needed a way to include three letter
words, but they were an extra 4 kilobytes of data. Something had to go.

I spent some time taking out unneeded white space and removing duplicated
<abbr title="Cascading Style Sheets">CSS</abbr> entries. That got me about 500
more bytes, which wasn't enough. Then I had an epiphany. I could use prefixes
for my words before they were loaded.

    prolix.load = function (prefix, suffixes) {
      var i, parts = suffixes.split(',');
      for (i = 0; i &amp;lt; parts.length; i += 1) {
        dictionary.load(prefix + parts[i]);
      }
    };

    prolix.load('AA', 'RDVARK');
    // 271 lines later...
    prolix.load('ZY', 'DECO,DECOS,GOTE,GOTES,GOTIC,MURGY');

That one change shaved 77,793 bytes off the dictionary code, giving me enough
room to add three letter words.

## Don't start with the obvious ##

When it comes to writing JavaScript, there are two "standard" approaches to
making your code smaller, minification and compression. Through out the
development of Prolix, I deliberately avoided doing either of those things.

Minification was out because I hate visiting a web site, viewing its source, and
seeing a bunch of obfuscated curly brace soup. Nobody learns when you do that.

Compression was out because my hosting provider charges for bandwidth.
Consequently, they don't support mod_gzip or mod_deflate. If I want compression,
I have to roll my own with mod_rewrite.

But mostly, I stayed away from obvious solutions because they prevent you from
seeing the not so obvious ones. Once you've zipped an application down to a
third of its size, you're not motivated to push it any further. It's easy to
say, "Oh, we'll just compress it." It's hard to think up new ideas for how
that's going to happen.

[Prolix]: http://prolix-app.com/ "A tweetable iPhone word search game"
[Jacob's]: http://bogomip.net/blog/ "Scurvy Jake's Pirate Blog"
[book]: http://oreilly.com/catalog/9780596517748 "JavaScript: The Good Parts - O'Reilly Media"
[prefix tree]: http://en.wikipedia.org/wiki/Trie "Wikipedia: Trie"
[Dennis Byrne]: http://notdennisbyrne.blogspot.com/2008/12/javascript-trie-implementation.html "Dennis Byrne: JavaScript Trie Implementation"
[JSLint]: http://jslint.com/ "JSLint: The JavaScript Code Quality Tool"
