<!--
title: Deep nesting and iteration
date: 12 May 2005
-->

A quote from [Manifesto of the Programmer Liberation Front][]:

> "In Science and Math, formulas are typically one-liners. Even small programs
> are far larger than any mathematical statement. Expression-based languages
> attempt to scale up formulas to hundreds or thousands of lines. One reason
> this does not work is that people can not easily handle more than about 2
> levels of nesting. We are not stack machines! Natural languages rely on linear
> narrative flow and avoid deep nesting. This may be the real problem with LISP:
> people complain about parentheses, but they are really complaining about deep
> nesting."

Looking at the Ruby code I've written, 95% of it doesn't go more than 2 levels
deep. At the most, it goes to 4, but that's only when multiple classes are
wrapped in a method and I have to use an explicit loop. I can't say the same for
my C++ or Scheme code. There's a lot of appeal in a language that provides
common iteration techniques: `collect`, `select`, `reduce`, `find`, `find_all`,
etc.  Internal iteration removes a lot of the deep nesting that necessary in
languages like Scheme.

But the problem with internal iterators is that they typically don't allow for
algorithms where you have to walk two sequences in parallel. Fortunately, Ruby
provides [generators][] for when you need to do that sort of thing.

Some links via Dave (the resident Lisp guru):

* <http://gigamonkeys.com/book/loop-for-black-belts.html>
* <http://lispworks.com/documentation/HyperSpec/Body/f_find_.htm#find-if>
* <http://lispworks.com/documentation/HyperSpec/Body/f_reduce.htm#reduce>
* <http://lispworks.com/documentation/HyperSpec/Body/f_map.htm#map>

> "Also, I'm not sure exactly what is meant by depth of nesting. In Lisp, one
> explicitly writes out the parse tree (to facilitate programmatic
> transformations of code), while much of that is implicit in a more
> heavily-syntaxed language like Smalltalk or Ruby. This is what allows the
> creation of macros such as LOOP that I linked to. [See links above.]

> Interestingly, Lisp meets every criterion on that site except for the
> prohibition of nesting. However, well-written lisp is in lots of small
> functions that aren't too deep. My guess is that people don't like Lisp
> because they're first exposed to Scheme and because it's new and different."

The more I code, the more I realize you pick the right language for the job. I
was messing around with coding a transrational number class in Ruby the other
day, and then it clicked. Transrational numbers are all expressed as numerator
and denominator. That's just a pair in Scheme, and a point in Perspex space is
just a list of sixteen pairs.

Simple. Now all I need is a Scheme interpreter in Ruby, then I could have my
cake and eat it too.

[Manifesto of the Programmer Liberation Front]: http://alarmingdevelopment.org/index.php?p=5 "Jonathan Edwards (Alarming Development): Manifest of the Programmer Liberation Front"
[generators]: http://onestepback.org/articles/same_fringe/ "Jim Weirich (one, step, back): The Same Fringe Problem"
