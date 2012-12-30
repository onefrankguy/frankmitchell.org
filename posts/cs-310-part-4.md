<!--
title: Computer Science 310 notes, part 4
created: 2 May 2005 - 1:30 pm
updated: 6 May 2005 - 1:31 pm
slug: cs310-part-4
tags: coding
-->

Still more notes from Bruce Bolden's Computer Science 310 course, "Programming Languages". [Part 3][] can be found someplace else.

[Part 3]: /2005/01/cs310-part-3 "Frank Mitchell (Can't Count Sheep): Computer Science 310 notes, part 3"

### 2 May 2005 ###

Presentations today! Yay for learning new languages!

#### Mumps ####

* Designed by Dr. Octo Barnett of Massachusets General Hospital
* Popular for medical databases
* ANSI standard in 1997
* Open sourced
* "M" is an alternative name
* Strongly imperative (even `if` and `else` are viewed as changing state)
* Simlar syntax to COBOL
* Typically interpreted
* Declaration free
* Whitespace is significant
* Variable names are case sensitive, commands are not
* Commands can be abbreviated to the first character: `S[et]`
* One universal data type: String
* String converst to int, flaot, etc. as needed
* All varialbes are automagically multi-dimensional

Example of slots:

	SET A = "abc"
	SET A(1,2) = "def"

* Globals are stored in an underlying hierarchical database

Here's a global:

	SET ^A("first_name") = "Bob"

* No tables in database
* Records can be whatever you want
* Simple multi-machine support
* Lots of system functions like, `$FIND`, `$ORDER`
* Also lots of system variables

The VA also uses this.

#### Cg ####

* High level language for GPUs (graphics cards)
* Used for shaders
* Similar syntax to C
* Can refer to specific registers in the GPU via "binding units"
* There's a matrix variable type
* Cross platform and cross API
* Cross hardware support for NVidia and ATI too
* You can use OpenGL or DirectX
* Can promote or denote constants as needed
* No real header files or initialization; start with a vertex, end with a fragment
* Used a lot for real time graphics

<http://developer.nvidia.com>

<http://cgshaders.org/>

#### More Mumps ####

* It's more than a language. It's an entire DB platform.
* Some implimentations provide a mechanism for a GUI.
* Two kinds of division

Division:

	/ returns decimal answer
	\ returns truncated integer

* Equals is both and assign and comparison
* Double asterisk raise to a power
* Lots of logical comparison operators, including XOR (`!!`)
* Statments must all be on one line
* Console IO (`WRITE` and `READ`)
* Globals are what it's all about; they're the database
* Pattern matching; not quite regular expressions but close
* "Cache" is the standard implimentation
* No true or false; returns 1 or 0
* Horrible syntax; not easy to read

#### Ada ####

* Compiler optimization flags
* Exception handling
* Thread support
* Interfacing to C, COBOL, and FORTRAN
* Designed for DOD
* Commercial banking
* Military
* Aircraft traffic control
* Internation Space Station
* Object Oriented
* Imperative
* Held a programing contest to design Ada
* 1979 - 1983 it was illegal to use Ada if you weren't working for the DOD
* Bounds checking automagically on arrays

#### Python ####

* Guido van Rossin in the 1990's
* Systems level language for the Ameoba OS
* Flexible, fits a number of different paradigms
* Imperative, but features from OO and functional languages
* No real protection in terms of `public` or `private`
* Can do `lambda` but it's only one statement
* Supports higher order functions where a function can call a function
* Weakly typed so you don't have to specify data types
* You an dynamically modify objects with mixins
* Whitespace is syntactically significant: used to denote blocks of code

### Icon ###

* Derivative of SNOBOL
* SNOBOL was a String Oriented Symbolic Language
* Strong point is Strings and Structures
* Very high level
* General purpose
* ICON -> Iconoclasm
* Syntax similar to C and C++

Example of output:

	write("This is output number ", var)

* Functions begin with `procedure` and end with `end`
* Assignment employs `:=`
* The `=` is used for comparison
* Expression end with `;` or EOL
* Goal driven (expressions can succeed or fail)

Example of goal driven:

	if < (x | 5) then write("y = ", y)

* Expressions that fail can still produce results
* Icon will backtrack to find a success

<http://www.cs.arizona.edu/icon/>

### Sather ###

* Developed at UC Berkley
* Goals: simple, safe, efficient
* Paradigms: strongly typed, imperative, OO, compiled
* Features: garbage collection, exception handling, free

<http://www.icsi.berkeley.edu/~sather/>

### Mumps ###

* Designed to run on small computers
* Very portable
* `IF` statements keep state in `$TEST`
* `FOR` loops can mimic `WHILE` loops
* Use of `GOTO` instead of functions
* Dynamic code execution with `@` and `XECUTE`

<http://google.com/search?q=mumps+language>

### Mumps ###

* Paradigms: procedural, interpreted, general purpose
* Gives and impression of medical use only
* Early implementations were a complete OS
* Can now share databases between architectures
* Built in multiuser/multitasking support
* Persistent variables after the program quits
* Very good string handling and indirection
* Case-sensitive commands
* Case-insensitive variable names

> "Mumps is a lousy language with one great data type."

> - Steve Morris

### Ada ###

* Widely used in DOD, banking systems, aircraft and subways
* Has packages that hold objects, data types, and procedures
* Very good exception handling
* Compiler for Ada: `gnat` and 'onyx`
* Supports encapsulation, abstraction, and other OO concepts

<http://gnat.com/>

<http://sw-eng.falls-church.va.us/ajpo_databases/ada95_validated_compilers.html>

### Lucid ###

* Lucid - The Dataflow Language
* Created by Ashcroft and Wadge around 1976 - 1977
* Non-imperative, interpreted
* Based on the concepts of pipes and filters
* Would fit better on a different architecture (non-Von Neumann)
* Current implementation is GLU (Granular Lucid)
* Multidimensional programming and intentional programming
* Syntax was intentionally obscured to force the programmer to think in Lucid
* This works on parallel processors really well

### Mercury ###

* Similar to Prolog
* Declarative logical programming language
* Compiled
* Strongly typed
* Deterministic
* High level: lambda, currying, closures
* Efficient (5x faster than Prolog)
* All declarations start with a `:-` and end with a `.`
* `_` is an anonymous variable

If-then-else:

	(if Goal then
		do this
	;
	else
		do that
	).

Goal:

	(Goal -> expression1 ; expression2).

Switches:

	(
		Comparison 1
		Clause 1
	;
		Comparison 2
		Clause 2
	).

* Switches catch more errors than if-then-else.
* Types: int, string, etc. Can declare own type.
* Predicates and functions (but functions return stuff)
* Modes declare input type for a function
* Modules are similar to classes in C++

### Tcl ###

* Scripting language developed in the 80s
* Tk is the graphics library for Tcl
* Tcl - Tool command language
* John OusterHout in 1980s at UC Berkeley
* Runs on just about any platform
* Rapid dev.
* Flexible and extendable
* Thread safe
* Easy GUIs
* Embeddable
* Internet and web enabled
* Commands are nested with square brackets
* `set` initializes a variable; `$` reads from a variable
* Scheme like lists `{ a b c }`
* Arrays are like an assoc. list in Scheme: `array(key) value`
* String matching
* `exec` is used to call an external command
* `foreach loopVar valueList commandBody`

### More Tcl ###

* Simple syntax
* Used in GUI work a lot
* Initial goal was a simple and extendable base language
* Became popular because it was an easy way to make graphics in Unix
* Suitable for large server applications
* Can act as a functional language
* Easy and quick development cycle
* Grammar is _commands_ made up of _words_ separated by spaces
* If you quote an expression it will evaluate it

<http://www.tcl.tk/>

<http://www.activestate.com/>

### StarLogo ###

* The next generation of Logo
* Use hundreds of thousands of "turtles" simultaneously
* Designed for distributed research
* Dialect of Lisp
* "Easy to learn, easy to use, easy to read."
* Turtles, Patches, and Observer
* Patches can induce behavior on turtles
* Turtles can interact with patches
* Syntax that's similar to natural language
* There is still scope
* Some procedures are meant for specific characters
* Used by researchers and students
* Logo is a mandatory part of the education system in England
* Can model bee colonies, traffic jams, etc.

<http://education.mit.edu/starlogo/>

### Haskell ###

* First version in 1990
* Supposed to be "the" functional language
* Haskell '98 standard
* Purely functionl
	* Nested expressions
	* No state
	* Evaluates in any order
* Shorter cleaner code
* Fewer errors
* Automagic memory managment
* Can be compiled or interpreted
* GHC is the compiler
* HUGS is the interpreter
* Lists: `(first:rest)`
* Cat: `list1 ++ list2`
* Multiple function definitions (overloading)
