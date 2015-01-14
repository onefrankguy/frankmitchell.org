<!--
title: The only way to shuffle an array in JavaScript
created: 14 January 2015 - 4:12 am
updated: 14 January 2015 - 5:24 am
publish: 14 January 2015
slug: fisher-yates
tags: coding, game
-->

There's an old programming interview question where you're asked to come up with
an algorithm for shuffling a deck of cards.

"So, how would you shuffle a deck of cards?"

"Umm... Pick two random numbers. Swap the cards at those positions. Repeat until
the deck's shuffled."

"Okay. Let's pretend I'm a random number generator. Walk me through your
solution."

"Give me a random number."

"Three."

"Okay. Give me another random number."

"Three."

"Umm... Well... Yeah, having a card not change places is okay. So I take the
card at position three and swap it with itself. Which is a no op."

"What happens next?"

"We do it again. Give me another random number."

"Three."

"How about another random number?"

"Three."

The lovely thing about randomness is that it's random. It's totally possible
that you could roll a six sided dice four times and get a three each time, but
it's not very probable. Something like a 77 in 100,000 chance.

<p class="math">0.00077 &asymp;
<span class="fraction">
<span class="fup">1<sup>4</sup></span>
<span class="bar">/</span>
<span class="fdn">6<sup>4</sup></span>
</span>
</p>

Computers aren't great an generating really random numbers. The best they can do
is pseudo random numbers. Depending on the language and library you're using,
you might get nicely distributed numbers, or you might get threes every time.
The trick is knowing what to do with that.

All the JavaScript games I've made share this common piece of code. It's a
function for shuffling an array in place.

    function shuffle (array) {
      var i = 0
        , j = 0
        , temp = null

      for (i = array.length - 1; i > 0; i -= 1) {
        j = Math.floor(Math.random() * (i + 1))
        temp = array[i]
        array[i] = array[j]
        array[j] = temp
      }
    }

That's a [Fisher-Yates shuffle][shuffle]. It was invented by Ronald Fisher and
Frank Yates in 1938, originally as a method for researchers to mix stuff up with
pencil and paper. In 1964, Richard Durstenfeld came up with the modern method
as a computer algorithm. It has a run time complexity of O(_n_).

I first encountered the Fisher-Yates shuffle in 2005 when I was asked the "How
would you shuffle a deck of cards?" question during an interview. Since then,
it's been one of those algorithms that I keep around in my video game
development hand bag.

## Would you like to know more? ##

Mike Bostock's post "[Fisher-Yates Shuffle][bostock]" (2012) has lovely examples
that animate shuffled decks of cards. Watching cards animate and seeing when
collisions happen gives you a very real feel for how long it takes a bad
shuffling algorithm to finish.

Jeff Atwood's post "[The Danger of Naïveté][atwood]" (2007) illustrates
why the Fisher-Yates shuffle is unbiased. He compares all possible outcomes for
a naïve shuffle vs. a Fisher-Yates shuffle and works through the statistics
to explain why the naïve shuffle is broken.


[shuffle]: http://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle "Various (Wikipedia): Fisher-Yates shuffle"
[bostock]: http://bost.ocks.org/mike/shuffle/ "Mike Bostock: Fisher-Yates Shuffle"
[atwood]: http://blog.codinghorror.com/the-danger-of-naivete/ "Jeff Atwood (Coding Horror): The Danger of Naïveté"
