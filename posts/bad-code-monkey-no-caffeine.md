<!--
title: Bad code monkey, no caffeine!
date: 6 June 2005
slug: code-comments
tags: writing
-->

Version control is not a substitute for documentation.

> "Oh, you don't need to put comments in. We have version control, and that lets
> us see exactly what gets changed and when. Besides, good code should be self
> documenting."

Pardon me while I get the blunt stick of beating.

The above comment came from a fellow who was working on project with twelve
other engineers. That project was somewhere in the neighborhood of 3,000,000
lines of code long. You know what the biggest complaint from the engineers was?

> "The code is a nightmare. It's so hard to understand what's going on."

Good documentation eliminates that kind of frustration. Here's my personal
definition of good documentation. I should be able to take a piece of code,
remove everything but the comments, and still know exactly what it does, how to
use it, and what kinds of errors it might generate. At the very least, every
function should have the following:

* Name - What is it called?
* Purpose - What does it do? What kinds of arguments does it take? What kind of
  errors can it generate? What will it return?
* Example - How can I use it in my own code?
* Created - When was was it created, and by whom?
* Modified - When was modified, by whom, how, and what were they thinking at the
  time?
* Data dictionary - What's the name, type, and usage of every variable in the
  function, including the inputs and outputs?
* Bugs / Features - What still needs to happen with it?

Documentation means that I don't have to read a hundred lines of code for a
member function to know that it modifies the data in the array I pass into it.
Version control won't tell me that. Documentation means that I can jump right in
where I left off three months ago, and know exactly what the intern was thinking
when he broke my code. Version control doesn't let you see people's ideas. While
documentation may take a little more time in the beginning, it saves months of
desing, debugging, and testing in the end.

For the curious, the title is a reference to Ernest Adams'
[*Bad Game Designer, No Twinkie!*][twinkie] article.

[twinkie]: http://www.gamasutra.com/features/designers_notebook/19980313.htm "Ernest Adams (Gamasutra): Bad Game Designer, No Twinkie!"
