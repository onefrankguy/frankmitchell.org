<!--
title: Theory is useless, unless it's applied
slug: implement-it
date: 10 May 2006
tags: writing
-->

I'm tired of academics in Computer Science telling me that algorithms matter,
implementation doesn't, and that they can implement any algorithm in any
language. If you really believe that, go ahead and attempt the following
exercise.

Take a look at the definition of the [XTEA][] cipher. Now implement it in
[ANSI C][]. Now implement it in [R5RS Scheme][]. By implement, I mean come up
with a working program that encrypts and decrypts ASCII text files. Which was
easier?

Algorithms are always constrained by implementation, and a fast algorithm is no
good if you can't make it work in the real world. At some point, the academics
need to get their hands dirty and write code. And in order to write code, you
have to know what's going on in the guts of a computer. You have to understand
how the hardware works, and how a compiler translates the code you write into
something the hardware understands.

But the academics don't get that. They stay stuck in their worlds full of
transcendental numbers, playing with things that never appear in real life.

[XTEA]: http://en.wikipedia.org/wiki/XTEA "Various (Wikipedia): eXtended TEA"
[ANSI C]: http://en.wikipedia.org/wiki/C_programming_language "Various (Wikipedia): C programming language"
[R5RS Scheme]: http://en.wikipedia.org/wiki/Scheme_programming_language "Various (Wikipedia): Scheme programming language"
