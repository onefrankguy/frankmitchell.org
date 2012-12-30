<!--
title: Computer Science 310 notes, part 1
created: 21 January 2005 - 1:36 pm
updated: 23 February 2005 - 2:04 pm
slug: cs310-part-1
tags: coding
-->

Notes from Bruce Bolden's Computer Science 310 course, "Programming Languages".

### 21 January 2005 ###

Smalltalk 80 - bits of history: <http://www.iam.unibe.ch/~dvcasse/FreeBooks.html>, Glenn Krasner

#### Declarative Programming ####

Evaluation of functions over partial data structures. Sometimes called stateless programming, as opposed to statefull (imperative) programming.

Two main declarative paradigms, namely functional and logic programming. It encompasses programming over complete values (Scheme and Lisp). Also encompasses logic programing (Prolog) when search is not used.

* Oz
* Escher

#### Functional Programming ####

A style that emphasizes the evolution of expressions rather than commands. The expressions in these languages are formed by using functions to combine basic values. A functional language supports and encourages programming in a functional style.

* Lisp / Scheme
* ML
* Haskell
* Erlang (cell phones)

Correction via [Mickael Remond][],

> "Erlang is not a cell phone language. It's a general purpose language invented by Ericsson, initially for huge complex telco machine. It is now used for web development, banking application, 3D modeler (Wings3D), etc. It is really ahead of the competition for developping robust, scalable distributed applications."

[Mickael Remond]: http://www.erlang-projects.org/ "The Erlang Projects non-profit association"

#### Logic Programming ####

Find solutions to problems given a set of rules.

* Prolog
* Oz
* Godel
* Mercury

#### Scripting Languages ####

Typically small and powerful, sometimes cryptic.

* awk
* Perl
* Python
* Ruby
* Parrot (merge Perl and Python)

#### Markup Languages ####

Typically used in document preparation.

* nroff / troff
* TeX (LaTeX) (tools MetaFont and MetaPost)
* PostScript
* SGML
* HTML
* XML

#### Special Purpose Languages ####

* lex / yacc
* Maple / Mathmatica
* Matlab
* SQL
* VHDL / Verilog

Languages we'll look at:

* C
* lex and yacc
* Scheme (Common Lisp)
* Java or Objective-C
* Prolog
* Probably one of Perl, Python, or Ruby

Assignment for next week: Read Chapter 1, spend some time looking at languages, review linked lists / recursion

### 24 January 2005 ###

#### C ####

* Developed in the 70's by Dennis Ritchie
* Unix written in C (a little assembly)
* C is a subset of C++, or C++ is a superset of C (C with classes)
* Still very popular

#### What is the same (between C and C++)? ####

* Basic data types
* Comments (C++ added the inline comment //)
* General syntax
* Naming conventions

#### Basic (primitive) data types ####

* `char`
* `int` (`short`, `long`)
* `double` (`float`)

<http://google.com/search?q=%22binary+coded+decimal%22>

#### Syntax ####

* Function definitions (parameter passing is different)
* Conditionals (`if`, `switch`)
* Loops (`for`, `while`, `do{ }while`)
* Arrays
* Abstract Data Types (`struct`, `union`)

#### Union Example ####

	union {
		uint32_t my_int;
		unint8_t my_byte[4];
	}endian_tester;

	endian_tester et;
	et.my_int = 0x0a0b0c0d;

	if(et.my_byte[0] == 0x0a) {
		printf("On a bing-endian system.");
	} else {
		printf("On a little-endian system.");
	}

<http://linuxjournal.com/articles.php?sid=6788>

#### What's different (between C and C++)? ####

* Compiler invocation (`cc` instead of `CC`, `gcc` instead of `g++`)
* I/O
* Variables must be declared at the top of a function (before a statement)
* Parameter passing (must use pointers)
* Strings are character arrays
* Memory manipulation
* No generics (templates)
* Macros (C preprocessor)

#### I/O ####

* ...is function based in C
* input - `scanf`, `read`
* output - `printf`, `write`

#### Reading in a character ####

	scanf("%c", &c);

#### Reading in integers ####

	scanf("%d%d", &i, &j);

Notice the ampersand for "address of".

#### Printing an integer ####

	printf("%3d\n", i);

Notice the format descriptor: `%3d`

#### Format characters ####

* `%c` - character
* `%d` - integer
* `%e` - single precision (exponential)
* `%f` - single precision
* `%g` - floating point (exponential if needed)
* `%o` - octal
* `%u` - unsigned
* `%x` - hexadecimal
* `%hd` - short
* `%ld` - long
* `%lf` - double
* `%s` - string
* `%%` - literal %

	%10.3lf

Double with a field width of 10 and a decimal precision of 3.

	%20s

String with a filed width of 20.

#### Macros ####

	#define max(a,b) a<b ? b:a

This makes sense for numbers but not letters. There's no type checking with macros, so don't do this.

### 26 January 2005 ###

#### File I/O ####

* All files are represented by one type `FILE*`, is defined in `<stdio.h>`
* header - `stdio.h`
* input - `stdin`
* output - `stdout`
* error - `stderr`

#### Function definitions ####

Prototypes were an addition to the ANSI-standard.

	/* Old C style */
	void PrintInt(a, a)
	int a;
	char *s;
	{
		printf("%s: %d", s, a);
	}

	/* ANSI C sytle */
	vaoid PrintInt(int a, char *s)
	{
		printf("%s: %d", s, a);
	}

Use the ANSI style!

#### Parameter Passing ####

Variables are passed by name or value. Use pointers to change actual values of a variable.

	void Swap(int *a, int *b)
	{
		int iTmp = *a;
		*a = *b;
		*b = iTmp;
	}

Usage: `Swap(&i, &j);` Swaps `i` and `j`.

#### File operation code ####

Opening a file for input:

	/* C++ */
	ifstream fIn;
	fIn.open(fName, ios::in);
	if(!fIn)
	{
		cerr << "Unable to open: " << fName << endl;
		exit(-1);
	}

	/* C */
	FILE *fpIn;
	fpIn = fopen(fName, "r");
	if(fpIn == NULL)
	{
		printf("Unable to open: %s\n", fName);
		exit(-1);
	}

Opening a file for output:

	/* C++ */
	ofstream fOut;
	fOut.open(fName, ios::out);
	if(!fOut)
	{
		cerr << "Unable to open: " << fName << endl;
		exit(-1);
	}

	/* C */
	FILE *fpOut;
	fpOut = fopen(fName, "w");
	if(fpOut == NULL)
	{
		printf("Unable to open: %s\n", fName);
		exit(-1);
	}

Appending to a file:

	/* C++ */
	ofstream fOut;
	fOut.open(fName, ios::out|ios::app);
	if(!fOut)
	{
		cerr << "Unable to open: " << fName << endl;
		exit(-1);
	}

	/* C */
	FILE *fpOut;
	fpOut = fopen(fName, "w+");
	if(fpOut == NULL)
	{
		printf("Unable to open: %s\n", fName);
		exit(-1);
	}

Closing files:

	/* C++ */
	fIn.close();
	fOut.close();

	/* C */
	fclose(fIn);
	fclose(fOut);

#### Copy a file to standard output ####

We're going to do this one character at a time.

	#include <stdio.h>

	int main(int argc, char **argv)
	{
		FILE *fp;
		int c;
		if((fp = fopen(*++argv, "r")) != NULL)
		{
			while((c = getc(fp)) != EOF)
			{
				putc(c, stdout);
			}
		}
		fclose(fp);
	}

#### String manipulation ####

Strings are character arrays in C. The standard string function prototypes are defined in `<string.h>`. Typical string manipulation functions: `strlen`, `strcat`, `strcmp`, etc.

Read from / write to strings.

* Read an integer: `sscanf(s, "%d", &i);`
* Write an integer: `sprintf(s, "%d", i);`

### 28 January 2005 ###

#### Dynamic memory ####

* allocate - `malloc`, `alloc`, `calloc`
* deallocate - `free`

Example: One dimensional array manipulation

	/* C++ */
	int *pA;
	pA = new int[N];
	delete []pA;

	/* C */
	int *pA;
	pA = (int*)malloc(N * sizeof(int));
	free((void*)pA);

Note: Use of casting. Treat dynamically allocated array just as if declared statically.

Example: Two dimensional array manipulation

	/* C++ */
	int **arr2D;
	arr2D = new int *[rsize];
	for(int i = 0; i < rsize; i++)
	{
		arr2D[i] = new int[csize];
		if(arr2D[i] == NULL)
		{
			/* ERROR */
		}
	}
	for(int i = 0; i < rsize; i++)
	{
		delete arr2D[i];
	}
	delete arr2D[i];

	/* C */
	int i;
	int **arr2D;
	arr2D = (int**)malloc(rsize * sizeof(int*));
	for(i = 0; i < rsize; i++)
	{
		arr2D[i] = (int*)malloc(csize * sizeof(int*));
		if(arr2D[i] == NULL)
		{
			/* ERROR */
		}
	}
	for(i = 0; i < rsize; i++)
	{
		free((void*)(arr2D[i]));
	}
	free((void*)arr2D);

This is dependent upon memory being a contiguous chunk. Allocate it all at once otherwise you can't use `arr2D[i][j]` to do accesses.

### 31 January 2005 ###

Passing around a pointer:

	struct Node
	{
		int x;
		struct Node *next;
	};
	typedef struct Node *NodePtr;

Adding nodes recursively to a linked list:

	void AddNodeRecursive(NodePtr *h, int x)
	{
		if(*h != NULL)
		{
			AddNodeRecursive(&(*h)->next, x);
		}
		else
		{
			NodePtr n;
			n = (NodePtr)malloc(sizeof(struct Node));
			n->info = x;
			n->next - NULL;
			*h = n;
		}
	}

Usage:

	NodePtr head = NULL;

	AddNodeRecursive(&head, 2);

#### Programming log ####

Keep a programming log for all your assignments. Just kind of a day by day journal about what you do and how much time you spend doing it.

#### Back to the language stuff ####

What is language? A notation for the transfer of information.

* Natural Language - English, Chinese, etc.
* Artificial - Symbols represent things / ideas
* Representations - Made vs. real world

Humans are language oriented.

Programing languages must be readable: communicate with others / yourself - _not_ just the machine!

Language provides a shorthand for more complex ideas (abstraction).

[insert picture of villagers fighting a bear]

Language is a tool!

* Morse code
* SMS
* Klingon battle language - shorter
* Status - thumbs up, thumbs down

A good notation sets us free to work at a higher level. We don't want to work at the 1s and 0's level on a computer.

#### Saphir-Wharf hypothesis ####

> "The language you know controls what you can think."

Restriction:

* Newspeak - Orwell's _1984_, control language -> control the way people speak

Expansion:

* Loglan - logical language, promotes logical thinking

#### Programing language mechanisms ####

A language should provide a means for combining simple ideas to form more complex ideas. Every programming language has three mechanisms for accomplishing this:

1. Primitive expression - represent the simple entities the language is concerned with
2. Means of combination - compound elements built from simpler ones
3. Means of abstraction - manipulate compound elements as units.

### 2 February 2005 ###

#### Program / Machine model ####

Program is tied to a specific machine. You can't compile code on Windows and run it on my Mac.

#### Program / Virtual Machine model ####

Program runs on a virtual machine and on our actual hardware we have some program that handles the instructions from the virtual machine.

#### Language categories ####

* Imperative
* Object-Oriented
* Functional
* Logic
* Scripting
* Markup
* Special purpose

#### Ten reasons to study programming languages ####

> "The language you know limits your abilities."

It'd probably be more accurate to say, "The language you _think in_ limits your abilities."

1. Express algorithmic concepts to computers
2. Express algorithmic concepts to yourself
3. Express algorithmic concepts to others
4. Understand how languages work
5. Select the right language (for the task)
6. Improve algorithmic vocabulary
7. Understand domain specific languages
8. Easier to learn new languages
9. Easier to design new languages
10. Communicate effectively (intelligently) with others in the industry (dynamic allocation, garbage collection, etc.)

Book recommendation: _Prime Obsession_ by John Derbyshire

<http://itconversations.com/>

#### Language classification ####

* Machine - direct one-to-one correspondence with hardware
* Assembly - symbolic representation of the machine language
* High level - symbols in language map to more than one machine instruction
* General purpose
* Domain specific

#### Benefits of high level languages ####

* Less work
* Abstraction
* Portable
* Readable
* Maintainable
* Libraries of code (e.g. OpenGL)

#### Commonly used languages ####

* Business
	* COBOL
	* RPG (Report Generation Language)
	* Excel
* Science
	* FORTRAN
* Gaming
	* C (Quake)
	* Lisp
	* Python
* Mathematics
	* Maple
	* Mathematica
	* MATLAB
* Statistics
	* SPSS
	* Statistica
* Simulation
	* Simula
	* GPSS
	* ACSL (Advanced Continuous System Language)
* Publishing
	* HTML
	* XML
	* LaTeX
	* TeX
	* PostScript
* Expert systems
	* OPS5
	* Mycin
* Scripting
	* Perl
	* Tcl
	* Python
	* Ruby (Rails)
	* shells

### 4 February 2005 ###

Side note: You can use `mail bruceb < source.c` from a sun-sol.cs.uidaho.edu box to send source to Bolden.

#### Paradigms ####

* Imperative
* Functional
* Object Oriented
* Logic
* Multi-paradigm

#### Imperative languages ####

Have / focus on machine state. Focus on linear sequence of actions that transform the state of the machine.

Languages:

* Algol
* Fortran
* C
* Pascal

#### Functional languages ####

Function (or applicative) language focus on transforming data by applying functions--not as static oriented.

	(Print(Sort(lookup(db, "John"), age), 2, 6))

Languages:

* Lisp (Scheme)
* ML
* Haskell
* Mathematica

#### Object Oriented languages ####

OO PLs focus on associating the transformation of data with objects (data types). Actions associated with objects.

Languages:

* Smalltalk (Squeak)
* Java
* C++
* Ruby

#### Logic languages ####

Logic (or rule-based) languages

	if dog is hungry, feed dog
	if dog is thirsty, "water" dog

Languages:

* Prolog
* OPS5
* lex, yacc (language tools)

#### Multi-paradigm languages ####

Allow a programmer to use / mix paradigms.

* C++: Imperative, OO
* Leda: Imperative, Functional, Logic (Timothy Budd, Oregon State)
* Oz: Declarative, OO, Logic, Constraint

#### Side notes ####

Octal dump:

	od a.out

Generate assembly:

	gcc -S file.c

Expand only macros:

	gcc -E file.c

C preprocessor:

	cpp

### 7 February 2005 ###

[overhead slide of the history of programming languages]

There's lots of languages, and there's a heritage there.

#### Important language concepts ####

* Humans are language oriented
* Languages must be readable
* Communicate with others / yourself--_not_ just the machine

Program with intent. There's some intention behind the code. What is it? Make that clear in both the comments and the code itself.

#### Programing language standards ####

* Proprietary standards: license usage, etc. Corporate driven.
	* Java
	* PostScript
* Consensus standards: driven by public organizations, e.g., ANSI, ISO, GNU.
	* ANSI C
	* Ada
	* GNU CC (compiler collection)

#### Compiler as a standard ####

* What the compiler says!
* Some use some compiler as the standard for the language.
* Compliance: Given a program which uses just features of the languages -> (yield) correct results

#### Good language features ####

1. Right level of abstraction
2. Natural notation
3. Complete enough to do the job
4. Self consistent--avoid special cases
5. Support extensible abstractions
6. Supports coding (useful throughout program life)
7. Miscellaneous (standards, portability)

Book recommendation: "Who Moved the Cheese?"

If you want to see how not to write code, visit <http://thedailywtf.com/>

#### Principle of least astonishment ####

You don't want to be surprised by what the code does.

#### Translator ####

Source -> Translator -> Target

* Translator: translates one language to another (source to target)
* Source: code (expressions) in source language
* Target: object code (often not human readable)

#### Interpreter ####

Source -> Interpreter (on Machine) -> Object -> Run-time System (on Machine)

* Interpreter: translates source language to intermediate object language then executes it

#### Java interpreter ####

Java Source -> Compiler (on Machine) -> Byte code -> JVM (on Machine2)

Compile Java source on one machine run on another with JVM. Version matters!

C# - Intermediate Language

#### Compiler details ####

Source -> Compiler -> Target -> Linker -> Libraries -> Loader -> Executable

* Compiler: translates the source language to object language
* Cross compiling: often used for embedded systems

#### Execution details ####

	# File A:
	main()
		call A1()
		call B2()
	A1()

	# File B:
	B1()
	B2()

* Linker / Loader: resolves addresses
* Object code is relocatable
* Independently compilable units desirable

#### REPL ####

Typical operation of an interpreter:

> Read - Eval - Print - Loop

Interprets code as entered.

Scheme (Lisp), ML work in this manner. Jython (Python with Java) also works in this manner. Fast turn around!

#### Recursive GCD source ####

	/* Recursive GCD (Greatest Common Divisor) */
	int GCD( int m, int n )
	{
		if( m < n )
			return GCD( n, m );
		else if
		...
	}

#### Iterative GCD code ####

	/* m >= 0, n > 0 */
	q = 0;
	r = m;
	while( r >= n )
	{
		r = r - n;
		q = q + 1;
	}

#### Typical compiler tasks ####

* Preprocessor (language dependent)
* Tokenize
* Analyze
* Semantic analysis
* Optimization (high level)
* Low level optimization
* Generate assembly / object code

### 9 February 2005 ###

[insert PDF about the evolution of language]

#### Typical compiler tasks ####

* Preprocessor (language independent)
* Tokenize
* Analyze
* Semantic analysis
* Optimization (high level)
* Low level optimization
* Generate Assembly / Object code

#### Compiler task details ####

* Structuring
	* Lexical analysis
		* Scanning
		* Conversion
	* Syntactic analysis
		* Parsing
		* Tree construction
* Translation
	* Semantic analysis
		* Name analysis
		* Type analysis
	* Transformation
		* Data mapping
		* Action mapping
* Encoding
	* Code generation
		* Execution order determination
		* Register allocation
		* Instruction selection
	* Assembly
		* Internal address resolution
		* External address resolution
		* Instruction encoding

#### Preprocessor ####

Preprocessor converts HLL -> HLL

* C: `cpp` e.g., `#define`, `#include`
* Early C++ compilers -> C
* Early Ada compilers -> C

#### Structuring ####

Structuring accepts the sequence of characters that constitute the source program and builds a tree that represents it internally.

#### Lexical analysis ####

The first step in structuring a source program is lexical analysis, which accepts a sequence of characters and yields a sequence of basic symbols.

Lexical analysis can be broken into tow subtasks:

* Scanning (breaking source into tokens)
* Classification (classify tokens (keyword / variable))

Easy to write (relatively speaking). A number of tools and well known techniques make this possible.

#### Syntactic analysis ####

The syntactic analyzer accepts the sequence of basic symbols delivered by the lexical analyzer and builds the source program tree.

* Structure of program
* Symbol table
* Operation precedence

#### Translation ####

The translator converts the source program, which is an algorithm stated in terms of source language concepts, into an equivalent algorithm stated in terms of the target language concepts.

#### Semantic analysis ####

The purpose of the semantic analyzer is to obtain information that is available at certain places in the program (identifier (variable) declarations) and move that information to other places in the program (identifier uses).

The name analyzer establishes an entry in the definition table data base for each definition and attaches the key to the appropriate definition to teach identifier.

* Name analysis
* Type analysis

#### Transformation ####

The transformation process builds the target program tree on the basis of the information contained in the source program tree (as decorated during semantic analysis) and the definition table.

#### Encoding ####

Encoding determines the order in which constructs will be executed (subject to constraints in the tree) allocates resources to hold intermediate resources and selects the instructions to carry out instruction encoding in the specified resources.

#### High level optimization ####

Eliminate common subexpressions.

	x[i] = x[i] + f(3);
	x[i] += f(3);

#### Low level optimization ####

	store r1, M
	load M, r1

#### Summary ####

A compiler translates a source program into an equivalent target program. The compiler maintains three major data structures:

1. A source program tree
2. A definition table
3. A target program tree

#### Syntax / Semantics ####

* Syntax
	* The symbols used to write a program
	* The language form - what is allowed
* Semantics
	* The actions that occur when a program is executed
	* The meaning of what is said (difficult)
* Programming language implementation
	* Syntax -> Semantics
	* Transform program syntax into machine instructions that can be executed to cause the _correct_ sequence of actions to occur

#### Terminology ####

* Grammar: formal description of the syntax for a language
* Alphabet: collection of symbols in the language, plus symbols in the grammar
* Production: a rule for replacement of non-terminals with other symbols from the alphabet
* Non-terminals: a subset of the alphabet each having a production
* Terminals: symbols in the alphabet that are non-terminals
* Start Symbol: the place to start
* Parse Tree: internal representation
* Derivation: the creation of a specific parse tree

#### BNF ####

Backus Naur Form (Backus Normal Form)

* John Backus - Fortran
* Peter Naur - Algol
* Describes a language formally
* EBNF: An extended form is often used!

More details: <http://www.garshol.priv.no/download/text/bnf.html>

### 11 February 2005 ###

* Grammars are often defined using BNF (or EBNF) rules.
* Rules are defined using terminals and non-terminals and special meta-symbols.
* BNF meta-symbols:
	* `::=` means "is defined as" (some people use an arrow)
	* `|` like "or", used to separate alternatives
	* `< >` (angle brackets) often used to denote non-terminals

* Extended BNF (EBNF) makes writing grammars easier.
* Any EBNF production (rule) can be translated into an equivalent set of BNF productions. EBNF is not more powerful than BNF, just more convenient.

BNF example:

	digit ::= 0|1|2|3|4|5|6|7|8|9

EBNF example:

	digit ::= 0-9

#### What is syntax? ####

* Expresses the form (or grammar) of a program in a portable language.
* It does not express what a program _means_.
* In other words, syntax expresses what a program looks like, but not what it does.

The elements of syntax for a language (including programming languages) are:

* An alphabet of symbols that comprise the basic elements of the grammar.
* The symbols are comprised of two sets--terminals and non-terminal symbols.
* Terminals cannot be broken down.
* Non-terminals can be broken down.
* A set of grammar rules that express how symbols can be combined to make legal sentences of the language.

The grammar rules are of the form: non-terminal symbols ::= a list of zero or more terminals or non-terminals.

We use the rules to recognize (parse) and / or generate legal sentences of the language.

Equivalent forms in which to express syntax:

* BNF
* Syntax graphs
* Other slight variations of notation

All notations commonly used for programming language syntax have the same power (i.e., all produce context-free syntax).

#### A grammar for a small subset of English ####

Consider the sentence, "Mary hits John."

A simple grammar that could be used to parse or generate this sentence is:

	<sentence> ::= <subject> <predicate> .
	<subject> ::= Mary
	<predicated> ::= <verb> <object>
	<verb> ::= hits
	<object> ::= John

How do we use rules to parse or generate a sentence like "Mark hits John."?

1. Consider each rule to be a production that defines how some part of a sentence is recognized or formed.
2. A trace of the application of the production of rules can be shown in tree form as follows:

[Visualize this as a tree. Think Study of Languages class, the syntax and grammar stuff from there.]

	<sentence> -> <subject> & <predicate>
	<subject> -> Mary
	<predicate> -> <verb> & <object>
	<verb> -> hits
	<object> -> John

A number of concepts that enhance the expressibility of a grammar:

* Alternation
* Express languages that have an infinite number of sentences or sentences that are infinitely long.
* The use of recursion in Context Free Grammars (CFGs)

Alternation - add `| Steve` to the `<object>`

Extend by adding additional non-terminal symbols

	<subject> ::= Mary | John
	<object> ::= Mary | John

We can now write "Mary hits Mary." or "John hits John."

A more convenient way is to change rules

	<subject> ::= <noun>
	...
	<object> ::= <noun>
	<noun> ::= John | Mary | Steve

Use recursion to form an infinite number:

	<object> ::= John | John again | John again and again | ...

Notice the pattern for these infinite length sentences:

	<object> ::= John | John <repeat>
	<repeat> ::= again | again and <repeat>

### 14 February 2005 ###

[Bolden's solution to our programing assignment]

* Do a breakdown - How many lines of code per function / total?
* Variable stuff - How many globals, structs, consts, etc.?

C doesn't know about true or false:

	#define TRUE 1;
	#define FALSE 0;

#### Prototypes ####

* Group prototypes together via their functions
	* I/O stuff
	* Stack routines
	* Memory stuff
* All variables in the prototypes have names!

### 16 February 2005 ###

Nerd Quiz

<http://www.wxplotter.com/ft_nq.php?im>

[graph about optimization] Basically, don't bother.

#### Notational Expression Grammar ####

	<expr> ::= <term> | <expr> <add op> <term>
	<term> ::= <factor> | <term> <op> <term>
	<factor> ::= (<expr>) | <id> | literal
	<op> ::= <add op> | <mul op>
	<add op> ::= + | -
	<mul op> ::= * | /
	<id> ::= identifier

#### C Identifier Grammar (EBNF) ####

	<identifier> ::= <nondigit> (nondigit | digit)
	<nondigit> ::= _ | a-z | A-Z
	<digit> ::= 0-9

#### Parse trees ####

Show how a sentence is derived in a language.

Production: P ::= x<sub>1</sub> x<sub>2</sub> x<sub>3</sub>

[picture of tree with P as root node and x<sub>1</sub>, x<sub>2</sub>, x<sub>3</sub> as leaves]

#### Definitions of grammar ####

Formally define a grammar by a 4-tuple.

	G = (V<sub>N</sub>, V<sub>T</sub>, S, P)

Where V<sub>N</sub> and V<sub>T</sub> are disjointed sets of non-terminal and terminal symbols respectively. S is the distinguished symbol of V<sub>N</sub>, and is commonly called the start (or goal) symbol. The set of V = V<sub>T</sub> U V<sub>N</sub> is called the vocabulary of the grammar. P is a finite set of productions.

Naming: The from of the grammar is important.

* Different grammars can generate the same language.
* Tools are sensitive to the form of the grammar.
* Restriction on the types of rules can make automatic parser generation easier.

#### Derivation examples ####

Grammar

	E ::= E+E | E*E | (E) | id
	id ::= number

Sentential form (input to parser)

	E: id * id + id

Leftmost derivation

1. In the current "string", choose leftmost non-terminal.
2. Choose any production for the chosen non-terminal.
3. In the string, replace the non-terminal by the right hand side of the rule.
4. Repeat until no more non-terminals exist.

Example: id * id + id

	E
	E ::= E + E
	E ::= E * E + E
	E ::= id * E + E
	E ::= id * id + E
	E ::= id * id + id

It matches our expression!

Rightmost derivation

1. In the current "string", choose rightmost non-terminal.
2. Choose any production for the chosen non-terminal.
3. In the string, replace the non-terminal by the right hand side of the rule.
4. Repeat until no more non-terminals exist.

Example: id * id + id

	E
	E ::= E + E
	E ::= E + id
	E ::= E * E + id
	E ::= E * id + id
	E ::= id * id + id

It matches our expression!

What if we had chosen to do E * E?

	E
	E ::= E * E
	E ::= id * E
	E ::= id * E + E
	E ::= id * id + E
	E ::= id * id + id

Our grammar is ambiguous. We can get to the same place through several different trees. You don't want to have an ambiguous grammar!

### 18 February 2005 ###

#### Peanuts Grammar ####

	<sentence> ::= <subject> <predicate>
	<subject> ::= <article> <noun> | <noun>
	<predicate> ::= <ver> <object>
	<article> ::= a | the
	<noun> ::= Linus | Charlie | Snoopy | blanket | dog | song
	<verb> ::= holds | pets | sings
	<object> ::= <article> <noun> | <noun>

Top down parsing vs. bottom up parsing

Noam Chomsky - linguist / anarchist

CNF (Chomsky Normal Form)

#### Top down parsing ####

Attempt to construct a syntax tree by staring at the root of the tree (start symbol) and proceeding downward toward the leaves (the symbols forming the strings).

	<sentence> ==> <subject> <predicate>
		==> <noun> <predicate>
		==> Linus <predicate>
		==> Linus <verb> <object>
		==> Linus holds <object>
		==> Linus holds <article> <noun>
		==> Linus holds the <noun>
		==> Linus holds the blanket

You can associate a rule (production) with each of the steps.

[Insert graphic of the parse tree for the sentence above]

Top down, left to right seems common. Do they do things differently in foreign countries?

#### Bottom up parsing ####

We try to construct starting from the leaves and moving up to the root.

	Linus holds the blanket
	<noun> holds the blanket
	<subject> holds the blanket
	<subject> <verb> the blanket
	<subject> <verb> <article> blanket
	<subject> <verb> <article> <noun>
	<subject> <verb> <object>
	<subject> <predicate>
	<sentence>

#### Derivation notes ####

* A parse tree has
	* Terminals at the leaves
	* Non-terminals at the interior nodes
* An in-order traversal of the leaves is the original input
* The parse tree shows the association of operations, even if the input string does not

#### Parsing ####

Given an expression find tree

* Ambiguity
	* Expression 27 - 4 + 3 can be parsed two ways
	* Problem: 27 - (4 + 3) != (27 - 4) + 3
* Ways to resolve ambiguity
	* Precedence
		* Group * before +
		* Parse 3 * 4 + 2 as (3 * 4) + 2
	* Associativity
		* Parenthesize operators of equal precedence to left (or right)
		* Parse 3 - 4 + 5 as (3 - 4) + 5

#### Ambiguous grammars ####

Language to generate strings of the form a<sup>n</sup>b<sup>n</sup>

	S -> aS<sub>2</sub> | S<sub>1</sub>b
	S<sub>1</sub> -> a | aS<sub>1</sub>b
	S<sub>2</sub> -> b | aS<sub>2</sub>b

#### An unambiguous grammar ####

Language to generate strings of the form a<sup>n</sup>b<sup>n</sup>

	S -> aSb
	S -> epsilon

Or more simply,

	S -> aSb | ab

### 23 February 2005 ###

Some discussion of interviewing and what happened at the ACM meeting yesterday.

#### Lexical analysis ####

> "Programs must be written for people to read, and only incidentally for machines to execute."

> Abelson & Susman, _SICP_, preface to the first edition

What is lexical analysis?

* Process of breaking input into tokens
* Sometimes called "scanning" or "tokenizing"
* Identifies tokens in input string (stream)

Issues in lexical analysis:

* Lookahead
* Ambiguities

Specifying lexers:

* Regular expressions (next time)
* Examples of regex

#### Tokens ####

What's a token? - A syntactic category

Examples:

* English
	* noun
	* verb
	* adjective
* A programming language
	* Identifiers
	* Comment
	* Keyword
	* Whitespace
	* Operator
	* Numbers (integer, real)

#### Recall ####

The goal of lexical analysis is to:

* Partition the input string into lexemes
* Identify the token type, and perhaps value of each lexeme
* Left-to-right scan -> lookahead sometimes required

<http://dictionary.reference.com/search?q=lexeme>

We still need:

* A way to describe the lexemes of each token
* A way to resolve ambiguities

Example:

* Is `if` two variables `i` and `f`?
* Is `==` two equal signs `= =`?

#### Examples of lexical analysis ####

Goal: Partition input string into substrings. The substrings are tokens (or lexemes)

What happens?

	if( i <= 9 )
		dx = 1;
	else
		dx = 5;

Output is a string of characters.

	i f ( i < = 9 ) \newline
	\tab d x = 1 ; \newline
	e l s e \newline
	\tab d x = 5 ; \newline

#### Defining tokens more precisely ####

Token categories correspond to sets of strings, some of them finite, like keywords, but some unbounded (variable / function name).

* Identifier: strings of letters or digits, starting with a letter
* Integer: a non-empty string of digits
* Keyword: `if`, `else`, or `for`, etc.
* Whitespace: a non-empty sequence of spaces (blanks), tabs, or newlines

#### How are tokens created? ####

* Created in a first pass over the source code. The lexer classifies program substrings by role.
* Complex frequently add or additional information (line and column), so errors can be reported by location. This can complicate the construction of a compiler.
* Tokens are read until the end of file is reached Or some error threshold is reached.

#### Designing a lexical analyzer ####

* Define a finite set of tokens
* Tokens describe our items of interest
* Depends on language and parser design

#### Token creation ####

An implementation reads characters until tin finds the end of a token (longest possible single token). It then returns a package of up to 3 items.

* What kind of token is it? Identifier? Number? Keyword?
* If it is an identifier, which one exactly? `Foo`? `Bar`?
* Where did this token appear in the source code? (line / column)
* Whitespace and comments are skipped.

Onwards to [part 2][]...

[part 2]: #!/ccs/compsci310notes2 "Frank Mitchell (Can't Count Sheep): Computer Science 310 notes, part 2"
