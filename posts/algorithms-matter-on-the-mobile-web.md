<!--
title: Algorithms matter on the mobile web
created: 1 June 2019 - 8:56 am
updated: 2 June 2019 - 10:05 am
publish: 2 June 2019
slug: fast-code
tags: coding, mobile
-->

Leo Fabrikant's [article on optimizing the performance of a React autocomplete
form][optimize] is worth reading. It covers performance profiling, async
rendering, and multi-threading with Web Workers. I loved that he outlined the
conditions that pushed him toward focusing on optimizing the rendering pipeline.
What we know creates the set of spaces where we look for solutions.

> The search algorithm library had painfully long search times as the length of
> the search term got longer...I don't know if the library I chose for the
> search algorithm was bad or if this was an inevitability of any "fuzzy" search
> algorithm. But thankfully, I didn't bother trying to find alternatives.

When I built my [word search game][prolix], I spent a fair bit of time learning
how to store and search strings efficiently. So when I read Leo's article, I
thought about data structures like [BK-trees][] and algorithms for finding the
[Levenshtein distance][Levenshtein]. My experience says long search terms
shouldn't mean long search times. So let's see if we can build a better search
engine.

## Sometimes you need to DIY ##

We'll need some strings to work with that satisfy the original requirements.

> Here is a data set retrieved from a backend. It contains 13,000 items with
> very long, wordy names (Scientific Organizations). Make a search bar with an
> auto-suggest using this data.

I don't have a list of very long, wordy scientific organizations handy. However,
the [Free Music Archive][FMA] has 19,212 tracks in it with names of five or more
words. I figure that's a pretty equivalent data set.

We'll also want some JavaScript to benchamrk different fuzzy search algorithms.
Let's assumes a worst case scenario, where the user's typed out the entire song
name, and the song they're looking for isn't in the database.

    const query = 'Where the Streets Have No Name';

    const data = [...new Set(require('./tracks.json'))];
    const tracks = data.filter(track => {
      return track.split(/\s+/).length >= 5;
    });

    const start = Date.now();

    const matches = tracks.map(track => {
      const score = compare(query, track);

      return {score, track};
    }).sort((a, b) => {
      return a.score - b.score;
    }).slice(0, 10)
    .map(info => info.track);

    const elapsed = Date.now() - start;

    console.log(`
    ${matches.join('\n')}

    Searched ${tracks.length} tracks in ${elapsed} milliseconds
    `);

We need a comparison function that scores two strings based on how similar they
are. To make it easy to sort results, we'll say that a smaller score means the
strings are more similar. The Levenshtein distance metric is the reference
measurement for string similarity. It counts the number of edits it would take
to make two strings identical.

Here's a memoized recursive implementation.

    function compare(s, t, memo = {}) {
      const args = [s, t];

      if (args in memo) {
        return memo[args];
      }

      if (!s) {
        memo[args] = t.length;
        return t.length;
      }

      if (!t) {
        memo[args] = s.length;
        return s.length;
      }

      const snext = s.slice(1);
      const tnext = t.slice(1);

      const cost = s[0] !== t[0];
      const delCost = compare(snext, t, memo) + 1;
      const insCost = compare(s, tnext, memo) + 1;
      const subCost = compare(snext, tnext, memo) + cost;
      const minCost = Math.min(delCost, insCost, subCost);

      memo[args] = minCost;
      return minCost;
    }

I ended up needing to memoize it, because the non-memoized version took too
long. As it is, even the memoized version takes about two minutes to find
matches.

    Where Childrens Have a Place
    Where the Walls Have a Soul
    When the Guests Have Left
    The Extra Party Has No Name
    So, What If I Have No Name?
    The One With No Name
    Where The Land Meets The Sea
    When the Lights Came On
    This Game Has No Name
    Down the Streets (Life Beyond)

    Searched 19212 tracks in 122963 milliseconds

That's not something I'd want to use in an autocomplete form. My general rule
of thumb for UI responsiveness is that anything more than a third of a second
(about 300 milliseconds) is too long. Fortunately, the Levenshtein distance
metric has an iterative implementation that avoids the recursion and
memoization.

    function compare(s, t) {
      let v0 = [];
      let v1 = [];

      for (let i = 0; i <= t.length; i += 1) {
        v0[i] = i;
      }

      for (let i = 0; i < s.length; i += 1) {
        v1[0] = i + 1;

        for (let j = 0; j < t.length; j += 1) {
          const delCost = v0[j + 1] + 1;
          const insCost = v1[j] + 1;
          const subCost = v0[j] + (s[i] !== t[j]);
          v1[j + 1] = Math.min(delCost, insCost, subCost);
        }

        [v0, v1] = [v1, v0];
      }

      return v0[t.length];
    }

That takes about a third of a second and finds the same matches.

    Where Childrens Have a Place
    Where the Walls Have a Soul
    When the Guests Have Left
    The Extra Party Has No Name
    So, What If I Have No Name?
    The One With No Name
    Where The Land Meets The Sea
    When the Lights Came On
    This Game Has No Name
    Down the Streets (Life Beyond)

    Searched 19212 tracks in 322 milliseconds

Can we do any better? Sure! I turns out the [Sorensen-Dice coefficient][dice] of
the sets of bigrams in two strings makes a pretty good fuzzy match. We have to
negate the score though, because a larger value means the strings are more
similar.

    function bigrams(string) {
      const result = [];

      for (let i = 0; i < string.length - 1; i += 1) {
        result.push(string.slice(i, i + 2));
      }

      return result;
    }

    function compare(s, t) {
      const sGrams = bigrams(s);
      const tGrams = bigrams(t);

      const hits = sGrams.filter(n => {
        return tGrams.includes(n);
      }).length;

      const total = sGrams.length + tGrams.length;
      const score = (hits * 2) / total;

      return -score;
    }

We get a different set of songs, which makes sense, because we changed the
algorithm. I'm not sure if the 64 millisecond speed improvement is noise or not.
I'd need to plug it into a more robust benchmarking tool (like [Benchmark.js][])
to measure that.

    No Secrets In the H4C
    The Streets of New York
    Where the Walls Have a Soul
    Liberty Is In the Street
    The Waves Call Her Name
    The Extra Party Has No Name
    Nameless: the Hackers Title Screen
    There is Nothing to Fear
    Down the Streets (Life Beyond)
    So, What If I Have No Name?

    Searched 19212 tracks in 258 milliseconds

What about the quality of the results? The Sorensen-Dice coefficient feels like
it does a better job of finding relevant songs when the words in the query are
out of oder. The Levenshtein distance feels like it does a better job when you
know the name of the song you want.

## Where do we go from here? ##

The more experiences we have, the better a chance we give ourselves of finding
solutions to problems and answers to questions. Leo's article helped me learn
how to profile and fix UI blocking issues. Writing this helped me learn that
fuzzy search algorithms aren't just about speed. Normalization and measuring
similarity vs. edit distance changes the quality of the results. You need to
understand the your use cases first, and pick an algorithm that supports them.

I'll probably just use Kiro Risk's excellent [Fuse.js][] library if I need a
fuzzy search engine in the future. It uses the [bitap algorithm][bitap], so
it'll probably be fast enough. Plus, that's the same algorithm used in `agrep`,
so it's probably a good fit for most text.

Probably.

## Addendum ##

For completeness, here's the Ruby code I used to turn the raw\_tracks.csv file
from the fma\_metadata.zip archive into a JSON list of track names.

    require 'csv'
    require 'json'

    $stdout.sync = true

    csv = CSV.read(ARGV[0], headers: true)
    tracks = csv.map { |row| row['track_title'].strip }
    puts tracks.to_json


[optimize]: https://levelup.gitconnected.com/secrets-of-javascript-a-tale-of-react-performance-optimization-and-multi-threading-9409332d349f "Leo Fabrikant (gitconnected): Secrets of JavaScript: A tail of React, performance optimization and multi-threading"
[prolix]: /2010/09/small-code/ "Frank Mitchell: Bytes matter on the mobile web"
[Levenshtein]: https://en.wikipedia.org/wiki/Levenshtein_distance "Various (Wikipedia): Levenshtein distance"
[BK-trees]: http://blog.notdot.net/2007/4/Damn-Cool-Algorithms-Part-1-BK-Trees "Nick Johnson (Nick's Blog): Damn Cool Algorithms, Part 1: BK-Trees"
[FMA]: https://github.com/mdeff/fma "Various (GitHub): FMA - A Dataset for Music Analysis"
[dice]: https://en.wikipedia.org/wiki/S%C3%B8rensen%E2%80%93Dice_coefficient "Various (Wikipedia): Sorensen-Dice coefficient"
[Benchmark.js]: https://benchmarkjs.com/ "Mathias Bynens & John-David Dalton: Benchmark.js"
[Fuse.js]: https://fusejs.io/ "Kiro Risk: Fuse.js - Lightweight fuzzy-search library. Zero dependencies."
[bitap]: https://en.wikipedia.org/wiki/Bitap_algorithm "Various (Wikipedia): Bitap algorithm"
