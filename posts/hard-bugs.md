<!--
title: Hard bugs and unknown assumptions
date: 18 October 2010
slug: hard-bugs
tags: writing
-->

Assumptions color everything we do, and I'm pretty sure you can't function
without them. Given how complex the world is, at some point you just have to go,
"Yeah, I assume it's going to work" and move on. But the worst assumptions, the
ones that cause you to tear your hair out or cry yourself to sleep in
frustration, are the ones you don't even know you're making.

## Hard bugs ##

When it comes to programming, the hardest bugs to fix are the ones where a base
assumption gets violated. You assume something to be true, only to find out it's
false. Here's an example with a bit of Ruby I was working on the other day.

    results = []
    mgram = []
    characters.each do |letter|
      mgram << letter
      mgram = mgram[1, size] if mgram.size > size
      results << mgram if mgram.size == size
    end

Every time the loop terminated, the `results` array would be filled with strings
of letters (m-grams) that were longer than the `size` variable.  That wasn't at
all what I intended, and it drove me bonkers. I stepped through the code
checking my assumptions.

- Letters were being appended to the `mgrams` variable.
- The `mgrams` variable was being trimmed to the right size.
- M-grams were being added to the `results` array.
- We went back to the top of the loop and continued.

Which of those assumptions is wrong?

As it turns out, none of them. The place I'd gone wrong was in assuming that
appending to an array created a copy. But it didn't; it created a reference. So
when the loop came around again and added another letter to `mgram` it also put
one onto the end of the m-gram I'd just put in `results`. I fixed it by changing
`results << mgram` to `results << mgram.clone`.

This kind of thing happens all the time. I'm pretty sure it's the reason so many
programmers distrust documentation and suffer from [NIH][].  There are so many
layers between our ideas and what's really going on, that we have to assume
things are working correctly if we want to get anything done.

And when our assumptions go wrong, we're left with really hard bugs.

## Growing persistent assumptions ##

It's easy to ditch assumptions you can shine a critical light on. Assumptions
you can reason about and test are easy to verify. "Hmm... I turned on the
dishwasher and all the lights went out. I'll assume the fuse is blown." Easy to
think about. Easy to check. Easy to solve.

The assumptions that are hard to let go of are the ones you don't even know
you're holding. Such base assumptions are typically formed by your first
exposure to a new idea.

Here's an example.

When I first learned to program, it was with the use of [XSLT][] to transform
XML files into web pages. Though I didn't know [I was programming][], that first
act permanently colored my view. Even after getting a Computer Science degree
and spending years in industry, I still view programming as the art of writing
down information and the functions that transform it into a usable form.

This idea of programming is totally different (and often alien) to someone who
grew up programing with punch cards. For them, programing is the art of
[optimizing for size and speed][]. Those were the things that were most
important when they were exposed to the idea. Those are the things that are most
important now.

These base assumptions form without conscious thought because our brains are
wonderful pattern recognition engines. They take in new information and form a
pattern about it. Any similar information we encounter in the future is
automatically filtered through that pattern, which just reinforces it.

While subsequent exposures might modify the pattern, it's the first exposure
that imprints strongest. That exposure doesn't have to be for any significant
duration. An offhand comment by a friend works as well as a college lecture. The
only thing that matters is that the information is new.

## Continuous learning is an antidote ##

As soon as you identify a base assumption, you have the opportunity to change
it. But how do you recognize it's there in the first place?

The process that works for me is to keep learning as much as I can about as many
different things as possible. I can only keep a finite amount of information in
my head. The more I learn, the more assumptions I have to challenge and let go
of in order to make room for new ideas.

Then I flop down on the floor, stare at the ceiling, and turn those ideas over
in my head. I go through the usual round of questions.  "Is this true?", "Do I
believe it?", and "How does it fit with what I already know?" are all good
starting points.

Usually somewhere in that process something will click, and I'll recognize that
I'm holding onto an assumption. When that happens, I can call it out, look it
over, and decide wether to keep it or not.

[NIH]: http://en.wikipedia.org/wiki/Not_Invented_Here "Wikipedia: Not Invented Here"
[XSLT]: http://en.wikipedia.org/wiki/XSL_Transformations "Wikipedia: XSL Transformations"
[I was programming]: http://en.wikipedia.org/wiki/Turing_completeness" "Wikipedia: Turing completeness"
[optimizing for size and speed]: /2010/09/small-code "Frank Mitchell: Bytes matter on the mobile web"
