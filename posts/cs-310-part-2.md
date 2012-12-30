<!--
title: Computer Science 310 notes, part 2
created: 21 January 2005 - 1:36 pm
updated: 6 April 2005 - 2:05 pm
slug: cs310-part-2
tags: coding
-->

More notes from Bruce Bolden's Computer Science 310 course, "Programming Languages". [Part 1][] can be found someplace else.

[Part 1]: /2005/01/cs310-part-1 "Frank Mitchell (Can't Count Sheep): Computer Science 310 notes, part 1"

#### True crimes of lexical analysis ####

* Is it as easy at it sounds?
* Not quite.
* A little history.

#### Lexical analysis in FORTRAN ####

FORTRAN variable names:

* Whitespace doesn't matter
* E.g. VAR1 is the same as VA R1
* FORTRAN whitespace rule motivated by inaccuracy of punch card operators

Typo:

* `DO 10 I = 1,25` -> Loop 25 times up to label `10`
* `DO 10 I = 1.25` -> Assign 1.25 to `DO10I`

#### Scanner generators ####

* Best known: lex, flex
* These programs take a table as their input and return a program (i.e. a scanner) that can extract tokens from a stream of characters.

#### Extended Backus-Naur Form (EBNF) ####

Adds some conventinet symbols:

* Union `|`
* etc.

#### Regular expression (RE or RegEx) program ####

* Easy to specify logical structure of typical language using RegEx.
* Good correspondence between intuition and implementation.
* Automated tools can use the RE specifications.

#### Java language specification ####

http://java.sun.com/reference/docs/

* Comments
* Multiplicative operators
* Unary operators

### 25 February 2005 ###

[Discussion on reusing written material, and the waiting game that's played in an engineering environment. Next assignment is a summary of of a language that's interesting to you, something we won't study in class.]

Book recommendation: _Who Moved My Cheese?_

[More discussion on the assignment: formatting, language choice, etc.]

> "Given enough time, you can do anything with string and Tinker Toys."

> Bruce Bolden

One of our next topics is `lex`. Read the paper about it (on the website) sometime in the near future.

### 28 February 2005 ###

Check your numbers, and check the numbers they give you too.

> "Some people, when confronted with a problem, think 'I know, I'll use regular expressions.' Now they have two problems."

> Jamie Zawinski, in `comp.lang.emacs`

#### Regular expressions ####

A regular expression is a pattern that describes a set of strings. Regular expressions are constructed analogously to arithmetic expressions, by using various operators to combine smaller expressions.

Widely used in many programing languages and editors:

* Perl, Python, Java, and Ruby
* ed, ex, emacs, and vi
* lex, yacc, ANTLR, and JavaCC

`grep` - The Unix tool, `grep`, uses regular expressions extensively to search file(s) for the specified expressions.

* `grep` - Get Regular Expression and Print
* `grep`, `egrep`, `fgrep` - print lines matching a pattern

Usage:

	grep <regex> file(s)
	egrep  grep -E extended
	fgrep  grep -F fixed strings (aka fast grep)

Details:

	man (grep|egrep|fgrep)

#### Metacharacters ####

The caret `^` and dollar sign `$` are metacharacters that respectivly match the empty string at the begining and end of a line.

* `.` (dot) is any character
* `.*` (dot-star) is any sequence of characters

A bracket expression is a list of characters enclosed by `[` and `]`. It matches any single character in that list; if the first character of the list is the caret `^`, then it matches any character not in the list.

#### Operators ####

Regular expressions make use of three operators: concatenation, alternation, and closure.

* Concatenation (join) operator
* Alternation operator - `|`
* Closure operator - `{}` denotes repetition of the expression zero or more times

Repetition takes precedence over concatenation, which in turn takes precedence over alternation. A whole subexpression may be enclosed in parenthesis to override these precedence rules.

#### Repetition operators ####

A regular expression may be followed by one or serveral repetition operators:

* `?` - Preceding item is optional and matched at most once.
* `*` - Preceding item will be matched zero or more times.
* '+' - Preceding item will be matched one or more times.
* `{n}` - Preceding item will be matched exactly `n` times.
* `{n,}` - Preceding item will be matched `n` or more times.
* `{n,m}` - Preceding item will be matched at least `n` times, but not more than `m` times.

#### Using metacharacters ####

In basic regular expressions, the metacharacters lose their special meaning: instead use the backslashed (escaped) versions `\?`, `\+`, `\{`, `\}`, `\|`, `\(`, `\)`, `\^`, `\$`, `\*`, `\.`, `\[`, `\]`, `\\` etc.

#### Examples ####

File (test.txt):

	Sylvester is a cat.
	Fido is a dog.
	Dexter is a boy.
	I like dogs, but am not particularly fond of cats.
	Cats are fun to tease.

	% grep cat test.txt
	Sylvester is a cat.
	I like dogs, but am not particularly fond of cats.

Single quotes prevent evaluation.

	% grep cat.*dog test.txt
	grep: No match.

	% grep 'cat.*dog' text.txt
	nothing

	% grep dog.*cat test.txt
	grep: No match.

	% grep 'dog.*cat' test.txt
	I like dogs, but am not particularly fond of cats.

`grep [cC]` [Notes incomplete here. Bruce moved on to the next slide before I could get it all down.]

#### Searching through your mailbox ####

May have to use `grep` instead of `egrep` here.

	egrep '^Subject:.*CS.*310' mbox

What does `egrap '^Subject:.*CS.*310' mbox | wc -l` do?

#### Searching for variable names ####

* `[a-zA-Z_][_a-zA-Z0-9]*` infinite characters
* `[a-zA-Z_][_a-zA-Z0-9]{0,31}` 32 characters max

How long can a variable name be in C? How long can a variable name be in Java?

#### Searching for money ####

Dollar amount with optional cents:

	\$[0-9]+(\.[0-9][0-9])?

Won't match `$.49`. Why?

#### What time is it? ####

Matches time of day:

	[0-9]?[0-9]:[0-9][0-9] (am|pm)

Works for both `9:17 am` and `12:30 pm`, but also allows `99:99 pm`. First digit must be a `1`.

`/1?[0-9]/` allows an hour of 19 and an hour of 0. So, break the hour part into two possibilities:

	(1[012]|[1-9]):[0-5][0-9] (am|pm)

AM or PM? Military time?

#### Strings with double quotes ####

`"[^"]*"` the quotes at either end are to match the open and close quotes of the string.

Check out the O'Reilly book on regular expressions. Also see `awk`, Perl, Tcl, and Ruby.

### 2 March 2005 ###

Discussion on Area 51, whether it does or doesn't exist, the mutated animals that might or might not live there. All this was started by a background check done on some students.

Short little quiz on Friday. Probably a test next week.

> "How to get bad student ratings. Give a test before spring break."

> Bruce Bolden

#### Lexical analysis ####

What is lexical analysis?

Process of breaking input into tokens. Sometimes called "scanning" or "tokenizing". The lexical analyzer scans the input stream and converts sequences of characters into tokens. Identifies tokens in input string (stream).

#### lex ####

* Lex was developed in the early to mid-70's
* `lex` reads a specification file containing regular expressions (rules and actions) to generate a C routine that performs lexical analysis.
* `lex` is a rule-based language (like Prolog)

#### lex file format ####

%% is used to separate the sections.

	definitions

	%%

	rules (regular expressions and associated actions)

	%%

	user routines (C functions)

#### Definitions section ####

You can put C code in your lex files.

	%{
	C code
	%}

	%definition(s)

Notes for this lecture are all online. You can [grab the PDF file][] and take a look for yourself. Any annotations here will reference that file.

[grab the PDF file]: http://www.cs.uidaho.edu/~bruceb/cs310/notes/09_Lex.pdf "Bruce Bolden (University of Idaho Computer Science department): Notes on Lex"


The `lex` library is named `l`, so you link it in with `-ll`. Kind of like the math library being named `m` and linking in with `-lm`.

#### Special lex variables ####

Once upon a time with the early C compilers, the max variable length name was eight characters.

#### Example 2: Name matching ####

> "We could use Shakespeare, but most of you probably wouldn't recognize the characters....How much Tom Clancy have you read?...Spongebob made the cut back before he was evil...._South Park_, now there we have truly evil."

> Bruce Bolden

#### Example 3: Word count (wc) ###

Notice the comments in the source file. You need to have comments in yours as well.

In this example, period (`.`) functions as a catch all.

> "There's not a lot of glory in text processing. It's a lot cooler if you have a GUI and graphics so people go 'Oooh' and 'Aaah'."

> Bruce Bolden

#### Example 4: Yet another world count ####

<http://www-128.ibm.com/developerworks/linux/library/ l-lex.html?dwzone=linux>

If you're going to do nothing, put a comment in there.

Test next Wednesday! Maybe.

#### 4 March 2005 ####

For the assignment, tabs become four spaces, and a single space becomes `&nbsp;`.

Side note: _Star Wars: Episode III_ comes out on May 19th.

> "It's not necessary that you always know (except maybe on a test), but that you know where to find it, and how to find it fast."

> Bruce Bolden [not an exact quote, but you get the idea]

More thoughts on the assignment: How do you want to store your keywords? Hash table, alphabetized binary trees, there are lots of options. Pick a solution that's fast and extendable. Let keywords be keywords too. You don't want `if` to be bolded in the middle of a comment.

HTML keywords: <http://w3schools.com/html/html_reference.asp>

C keywords: <http://www.phim.unibe.ch/comp_doc/c_manual/C/SYNTAX/keywords.html>

You're encouraged to abstract away the header and footer. All the code you submit should be in a single `lex` file.

### 7 March 2005 ###

1. No class on Friday!
2. `lex` program still due Friday.
3. Remember written / oral reports.
4. Test Friday after spring break.

#### Yacc ####

More with the online note goodness. Go [download the Yacc PDF][] and follow along.

[download the Yacc PDF]: http://www.cs.uidaho.edu/~bruceb/cs310/notes/10_Yacc.pdf "Bruce Bolden (University of Idaho Computer Science Department): Notes on Yacc"

Example: `A -> Bc` is written in yacc as `A: B 'c';`

#### Rules ####

Code snippet update:

	 rule1: action1
	 rule2: action2
	 ...
	 ruleN: actionN

Right recursive vs. left recursive rules:

	A :: A B // Left recursive
	A :: B A // Right recursive

Side note: If you take Dr. Heckendorm's compilers class, start your assignemnts early and send him email if you've got questions.

#### Simple calculator ####

The `yywrap` function is invoked when the program wraps up. You can put memory cleanup stuff in here. Try including it if you can't get your program to compile.

	int yywrap( void )
	{
		return 1;
	}

`main()` invokes `yyparse()` that's the function built up by our `yacc` code.

<http://dinosaur.compilertools.net/>

### 9 March 2005 ###

Side notes: The next generation XBox will use three 3 Ghz PowerPC chips. This means we might see a 3 GHz Mac out in a little bit. Of course the real question is can I install OS X on it?

<http://wired.com/news/games/0,2101,61065,00.html?tw=wn_tophead_1>

According to said Wired article, Microsoft's going to use Virtual PC technology to provide backwards compatibility with old XBox games. No wonder they're going to need three processors. Virtual PC runs like molasses on anything less.

#### The ten worst engineering pitfalls ####

1. The solution is more problematic than the problem it was created to solve.
2. Basing the design on your own motives rather than on users' needs.
3. Neglecting to handle all possible failure cases gracefully.
4. Failing to protect users' privacy.
5. Expecting that users will (or should have to) read anything.
6. Expecting that users will (or should have to) possess technical knowledge or jargon.
7. Expecting that users will (or should have to) configure something before using it.
8. Challenging or attempting to guess the user's intent.
9. Not knowing when to re-architect (either doing it pointlessly, or avoiding it when needed).
10. Failing to make the implementation as maintainable and understandable as possible.

<http://osnews.com/story.php?news_id=9915>

### 21 March 2005 ###

<http://www.fincher.org/Misc/Pennies/>

Got to go find some pennies now. Lots of pennies.

We got our assignments back. Yay! I got 23 out of 25 on the first assignment and 19 out of 20 on the second. Points docked for not handling the edge case of no solution on the maze solver and lines that were too long.

We've got a test this Friday. We'll talk more about that on Wednesday. Make sure you know how to do linked lists and trees in C. Four programing related questions. Something on a short `lex` program; overall, no gory details. Language concepts will be back with a vengeance.

<http://slashdot.org/article.pl?sid=03/03/07/173242>

<http://perso.wanadoo.fr/pascal.brisset/kernel3d/kernel3d.html>

ML (Objective) generates the graphics.

#### Scheme ####

* Lisp (1975, AI, Games)
* Language concepts
	* Interpreted
	* List based
	* Prefix notation `(+ 2 3)`
	* Symbols, numbers, and booleans (BigNums are support natively)
	* Typing (data) not required
	* Comments (`;`)
* Functional (not pure)

Lisp is the language of choice in the computational linguistics area.

Side note about life in the real world: lots of Visual Basic out there. Learn it, even if you don't love it.

<http://drscheme.org/>

You want version 2.09 or whatever the current version is. This is the program that Bolden will use to test, so it's probably what you should be writing in. It's an integrated environment with a very nice help system. They've been using this for teaching at RICE University for a number of years.

<http://drpython.sourceforge.net/>

> "No one respects size anymore. 100 megs? Oh, I've got time to go get a drink."

> Bruce Bolden

#### Examples of scheme ####

Statements have the form:

	(function arg1 arg2...argN)

	> (+ 2 3)
	5

Define a symbol or function:

	> (define PI 3.14159)
	PI
	> PI
	3.14159
	> (PI)
	procedure application: expected procedure, given: 3.14159 (no arguments)
	> pi
	#i3.141592653589793 ;The #i tells you the type; in this case indeterminate.

Interesting aside:

	> (+ 2 1 3)
	6

Symbols don't have a value unless they're assigned. Names are global!

More errors and oddities.

	> E
	reference to undefined identifier: E

	> (/ 33 99)
	;Returns 0.3 with a bar over the 3.

### 23 March 2005 ###

#### What's on the test ####

* Overview of language
* Language concepts
	* Language in general
	* Details of various programing languages
	* Syntax / semantics
* C
	* Parameter passing
	* Files
	* Dynamic memory
	* Data structures
	* Recursion (best friend and worst nightmare for data structures)
* Compilation process (reference the text too)
* Grammar (reference the text too)
	* BNF
	* EBNF
	* Derivations
* Regular expressions
* Lexical analysis (reference the text too)
* `lex`
* `yacc` (high points at most)

Focus on terminology and concepts.

	Test format:

	Basic concepts:            20
		True / False
		Fill in blank

	Concepts:                  20
		Short answer

	C coding (4 functions):    20
		Arrays
		Strings
		Lists, Stacks, Queues
		Trees
		Files (guaranteed)

	Grammar derivations:       15

	Regular expressions:       10
		3 or 4 fairly simple
		No specific regex

	lex file problem:          15

The test is going to be long, and it's going to test your knowledge. Comment the code you write.

Onwards to [part 3][]...

[part 3]: /2005/01/cs310-part-3 "Frank Mitchell (Can't Count Sheep): Computer Science 310 notes, part 3"
