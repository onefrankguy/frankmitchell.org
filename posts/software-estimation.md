<!--
title: Squishy things are hard to estimate, not impossible
date: 1 November 2010
slug: software-estimation
-->

"Think we can get this done pretty quick?" my client asked.

"Depends on your definition of 'pretty quick'," I said.

Lots of software engineers hold the opinion that software projects can't be
estimated. They say they're squishy, amorphous, changeable things, like art or
music or sculpture. "Every project is different," they say.

Walk into an engineer's office, drop a project proposal on his desk, and ask for
an estimate of how long it will take. You'll get one of two answers.

## I don't know ##

Such a statement is often accompanied by a look of annoyance and a shake of the
head. Don't be fooled by this, as it doesn't mean your engineer can't estimate
things. What they're really trying to say is, "Arrrgh! I was deep in some code,
and you totally interrupted me, and now I have to context switch, and it's going
to take me hours to recover, and you want an estimate for *what*?"

If you persist past the "I don't know", and actually get your engineer to look
at the proposal, their estimate will be short, crisp, and to the point.

## About N days ##

Here "N" doesn't have to be measured in days.  You're engineer may also say
"weeks", "months", "man years", or "cans of Mountain Dew" depending on what's in
the proposal. What's important is not the quantity of the thing, but the fact
that they gave you a single number.

Ask your engineer how they got that number, and you'll likely hear a story about
a previous project they worked on that was similar. Or they might throw out a
few other numbers that when multiplied or added together result in the number
they gave you. Either way, you know one thing.

They don't have a clue.

## Software estimation isn't hard ##

The reason that most software engineers can't estimate, is not because software
is any more complex than any other creative endeavor.  It's simply because no
one taught them how.

Most other engineers (electrical, mechanical, chemical, etc.) learn how to
estimate right about the same time they learn how to test a hypothesis, look
things up in a reference manual, and keep a lab book.  But software engineers
don't do the kinds of hands on lab work where estimation is required, so it's
something they tend to flounder with. Floundering just makes them feel
uncomfortable, which leads to claims of software being "different" or
"unpredictable".

But estimating software isn't any different than estimating how long a trip's
going to take or how much food you'll eat for dinner. Both of which most people
can do pretty accurately. The steps are the same, no matter what you're
estimating.

## How to estimating anything ##

1. Break it down.
2. Look it up.
3. Take a guess.
4. Do some math.

Every time you estimate something, you go through those for same steps.  For the
estimates we make all the time, "Do I have enough gas in the car to get to Rhode
Island?", "How far away is the tiger that's running towards me?", "Will two
woolly mammoth steaks be enough for dinner?", it's an automatic process.  For
other estimates, we have to go through the steps one at a time.

The first step is to break down whatever you're estimating into smaller chunks.
Big things with lots of inputs and information are hard to estimate. If you can
break a project down into stages, steps, teams, functions, concepts, or any
collection of smaller units, you're on the road to a better estimate.

Now you need to gather information about each of those chunks. Maybe there are
things you've done in the past that are similar. Or maybe there are open source
projects you can reference, or people you can talk to who have built something
similar. Write down as many ideas about each chunk as you can. If any one chunk
starts to feel too big, go back and break it into smaller parts.

Wrapping your head around the bits that make up a chunk automatically gives you
a feel for the number of people, kinds of equipment, amount of research, or
whatever it is that the chunk needs in order to get done.  Start plugging in
numbers for those pieces. Guessing is fine, especially since these are
*educated* guesses based on the information gathered in the previous step.
Eventually you'll come up with a number for each chunk.

Finally, you adjust those numbers a bit. Multiplying by 4 seems to work pretty
well, or 2 if your guess is more educated. Add up all the numbers, and you'll
have an estimate.

## A real live example ##

I once had to put together a time estimate for moving a DVD based software
distribution system to download on demand. I started my estimate by breaking the
specification down into three parts.

* Publishing a list of items
* Subscribing to a list of items
* User interface for both

From there I did a bunch of research to figure out what kinds of formats,
libraries, tools, and designs would work. I did UI mockups and evaluated XML
parsers. Researching and breaking things down into small chunks took a couple of
weeks. Eventually, I was left with a list of tasks, most of which looked like
they would talk a day or two.

Then I tweaked those numbers. I considered what I knew how to do (write a
wrapper for a third party library) and what I didn't know how to do (build a
dynamic user interface). Stuff I knew how to do go multiplied by 2. Stuff I
didn't know how to do got multiplied by 4. I allocated extra time for customer
changes after I had a working model that people could play with. I added in a
couple of months for tracking down and fixing bugs.

Finally, I summed up all the numbers and wrote up an estimate. I described what
would happen if parts of the project ran too long, which things could be cut,
and the order stuff had to be built in. I got the customer to sign off on it.
Then I went away and built the thing. It took nine months.

My estimate was off by four hours.

## Why it works ##

Remember how I said the process works for anything? Think about what happens
when you judge how far something is. You don't just throw out a number. Your
brain computes the distances from you to several intermediate objects, adjusts
for what you know from previous experiences, throws in some fuzzy logic, sums
the result, and gives you an estimate. It's the same four step process, just
sped up a lot.

Your brain is great at measuring squishy things and doing estimates, because
that's something it's had to do every day of your life to keep you alive. The
part where most software engineers fail is at step two. You have to spend some
time mulling over the parts of project in order to get a feel for how long it's
going to take. The larger the project, the more mull time you need.

Most customers don't want to give you a week to think things over.  They have
business concerns to meet. Apple's gaining market share every day, and they want
to know how long it's going to take to build their iPad application. Resist the
urge to just throw them a number.

Taking the time to think is what makes the process work. Your brain is great at
judging distances because it does it every time you look across the room. But
you don't do software estimates every day, so estimating things like that
requires a bit more brain time.
