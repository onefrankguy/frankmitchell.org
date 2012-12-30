<!--
Title: Computer Science 310 notes, part 2
Created: 21 January 2005 - 1:36 pm
Modified: 25 April 2005 - 1:30 pm
Tags: coding
-->

Still more notes from Bruce Bolden's Computer Science 310 course, "Programming Languages". [Part 2][] can be found someplace else.

[Part 2]: /ccs/compsci310notes2 "Frank Mitchell (Can't Count Sheep): Computer Science 310 notes, part 2"

### 23 March 2005 ###

#### Scheme ####

	> E
	reference to undefined identifier: E

	> (define E 2.7128)	> E	2.7128

Which is larger: e<sup>pi</sup> or pi<sup>e</sup>?

	> (expt e pi)	#i23.140692632779263
	> (expt pi e)	#i22.45915771836104

`#i` - approximate (indeterminate) number

Predicates end with `?`

	> (number? 5)	true
	> (number? a)	reference to undefined identifier: a

	> (define PI 3.14159)
	> (number? PI)	true

	> (boolean? #t)	true

	> (boolean? #f)	true

	> (boolean? t)	reference to undefined identifier: t

	> (define PI 3.14159)
	> (boolean? PI)	false

#### List and evaluation ####

Lists are the primary data structure in Scheme (Lisp). Dr. Scheme has added a structure definition `define-struct_method`. We won't be using it. Unless quoted, a list of the form

	(S1 S2 S3 ... SN)

is assumed to represent a call to the function `S1` with the arguments `S2`, `S3`,...,`SN` (where `S` represents a symbol / symbolic expression).

1. evaluates `S1` by looking up the function definition
2. evaluates the arguments `S2`, `S3`,...,`SN`
3. applies the function definition to the evaluated arguments

	> (+ 2 3)	5	> (* 2 3 4)	24	> (+ (* 2 3) 4)	10

### 28 March 2005 ###

#### Lists ####

`car` and `cdr` are used extensively in Lisp. May dialects have introduced `first` and `rest`.

On `car` and `cdr`: These names are accidents of history. They stand for "Contents of the Address part of Register" and "Contents of the Decrement part of Register" of the IBM 704 computer, which was used for the first implementation of Lisp in the late 1950s.

Scheme is a dialect of Lisp.

#### Simple list manipulation ####

	> (car '(1 2 3))
	1

	> (cdr '(1 2 3))
	(list 2 3)

	> (cadr '(1 2 3))
	2

	> (cddr '(1 2 3))
	(list 3)

	> (caddr '(1 2 3))
	3

#### Building a list ####

Lists can be built using `cons`, `list`, or `append`. You can only use `cons` in your assignments. `cons` constructs a new (temporary) list by appending the first argument onto the second argument.

	> (cons 'a '(b c))
	(list 'a 'b 'c)

	> (cons 'a (cons 'b '(c)))
	(list 'a 'b 'c)

	> (cons 'a (cons 'b '()))
	(list 'a 'b)

	> (cons '(a b) '(x y))
	(list (list 'a 'b) 'x 'y)

	> (cons '() '())
	(list empty)

Note: `cons` is non-destructive.

	> (define x '(a b c))

	> (cons 'd x)
	(list 'x 'a 'b 'c)

	> x
	(list 'a 'b 'c)

#### Conditional operations ####

Scheme has two mechanisms for performing conditional operations: `if` and `cond`.

	(if <predicate>
		<consequent>
		<alternative>)

	(define (peanoAdd x y)
		(if (= x 0)
		y
		(peanoAdd (- x 1) (+ y 1))))

	> (peanoAdd 0 3)
	3

	> (peanoAdd 2 3)
	5

	> (peanoAdd 5 3)
	8

How fast would the same code run in C or C++?

	(cond
		(<logical test> <arg1>)
		(<logical test> <arg1> <arg2>)
		(else <more stuff to do>))

The `else` always evaluates to `true`.

In Scheme and Lisp, functions should only be about 10 lines long and should only do one thing.

#### Defining Scheme procedures ####

A Schemem procedure is defined using `define`. Let's define a function which calculates the square of a number given to it. Note the lack of type declarations among arguments to functions.

	> (define (square x)
		(* x x))

	> (square 3)
	9

	> (square 1.2)
	1.44

Lambda is used in declaring temporary names (variables).

	> (define square (lambda x)
		(* x x))

#### Increment function ####

Let's define a function that takes an argument and adds 1 to it.

	(define (increment n)
		(+ n 1))

	> (increment 2)
	3

#### Absolute value function ####

	(define (abs-val x)
		(cond ((< x 0) (- x))
		      ((= x 0) x)
		      ((> x 0) x)))

	(define (abs-val x)
		(if (< x 0)
			(- x)
			x))

	(define (safe-abs n)
		(cond
			((number? n) (if (< n 0)
				(* n -1)
				n))
		(else
			(display "Argument must be a number."))))

### 30 March 2005 ###

There is no loop structure in the default flavor of Scheme. Recursion is the way to go.

#### Recursive functions ####

	(define (factorial n)
		(cond
			((zero? n) 1)
			(else (* n (factorial (- n 1))))))

	> (factorial 3)	6
	> (factorial 40)	815915283247897734345611269596115894272000000000

Using a helper (auxiliary) function inside a function

	(define (factorial n)
		(define (tr-fact result n) ;; helper function
			(if
				((zero? n) result)
				(tr-fact (* result n) (- n 1))))
				(tr-fact 1 n)) ;; invoke helper

#### Square root ####

Declarative knowledge ("What is true?"):

`sqr(x)` is the `y` such that `y<sup>2</sup> = x` and `y >= 0`

But this doesn't tell us how.

Imperative knowledge ("How to")

To find and approximation:

1. Make a guess, G
2. Improve the guess by averaging G and x/G
3. ?

Here it is in Scheme:

	(define (try guess x)
		(if (good-enough? guess x)
			guess
			(try (improve guess x) x)))

	(define (sqrt x)
		(try 1 x))

	(define (improve guess x)
		(average guess (/ x guess)))

	(define (good-enough? guess x)
		(< (abs (- (square guess) x))
		.001))

	(define (square x) (* x x))

	(define (average x y)
		(/ (+ x y) 2))

	> (sqrt 2) -> (try 1 2) -> (try 1.5 2)

Not that our solution is built of a lot of little tiny procedures.

Block structure form:

	(define (sqrt x)
		(define (square x) (* x x))

		(define (average x y)
			(/ (+ x y) 2))

		(define (improve guess x)
			(average guess (/ x guess)))

	;; More code here...

	)

#### Review of predicates ####

The world predicate is used to procedures that return true or false, as well as for expressions that evaluate to true or false.

* `atom?`
* `boolean?`
* `symbol?` consumes an arbitrary value and produces true if the value is a symbol and false otherwise
* `number?`
* `null?` empty list / value

Atoms are either

1. a number
2. [Bruce went too fast here for me to catch everything] 
3. [?]

#### Abstractions ####

Look at some abstractions.

Sum integers between `a` and `b`.

	(define (sum-list a b)
		(if (> a b)
			0
			(+ a
				(sum-list (+ a 1) b))))

Sum of squares between `a` and `b`

	(define (sum-sq a b)
		(if (> a b)
		0
		(+ (square a)
			(sum-sq (+ a 1) b))))

Notice the similarities between our solutions.

Sum to calculate `pi/8`

	(define (pi-sum a b)
		(if (> a b)
			0
			(+ (/ 1 (* a (+ a 2)))
				(pi-sum (+ a 4) b))))

#### Basic software engineering principle ####

If you write something more than once, you're doing something wrong.

Want an abstraction, since all of these procedures are identical for the most part.

General pattern for sums

	(define (sum term a next b)
		(if (> a b)
		0
		(+ (term a)
			(sum term    ;; invoke sum again
				(next a) ;; change a
				next     ;; procedure
				b))))

General `sum` has four arguments. `term` and `next` will be procedures. `term` and `next` are also arguments.

Sum square a and b:

	(define (inc n)(+ n 1))

	(define (sum-sq a b)
		(sum square a inc b))

	;; We defined square elsewhere. See previous code samples.

Pi-sum:

	(define (pi-sum a b)
		(sum (lambda(i) (/ 1 (* i (+ i 2))))
		a
		(lambda(i) (+ i 4))
		b))

Faster?

	(define (inc4 n) (+ n 4))
	(define (next-term i)
		(/ 1 (* i (+ i 2))))

	(define (pi-sum a b)
		(sum (next-term(i))
		a
		inc4 i)
		b))

Note that if you run `(pi-sum n m)` times `8` you'll get a fraction. If you run it times `8.0` you'll get a decimal.

Iterative sum:

	(define (sum term a next b)
		(define (iter j ans)
			(if (> j b)
				ans
				(iter (next j)
					(+ (term j) ans))))
		(iter a 0))

### 1 April 2005 ###

<http://google.com/search?client=safari&rls=en&q=deterministic+finite+automata&ie=UTF-8&oe=UTF-8>

A lot of the stuff you need to do DFA is built into Lisp. We get less than a page of code that solves a fairly complex problem.

#### Variables ####

A _formal parameter_ of a procedure has a special role in the procedure definition in that it doesn't matter what name the formal parameter has. Such a name is called a _bound variable_, and we say that the procedure definition _binds_ its formal parameters.

If a variable is not bound, we say it is _free_. THe set of expressions for which a binding defines a name is called the _scope_ of that name.

In a procedure definition, the bound variables, declared as the formal parameters of the procedure have the body of the procedure as their scope.

#### Using `lambda` to construct procedures ####

Wanted to create an abstraction for summation procedures (see notes above).

In general, `lambda` is used to create procedures the same was as `define`, except that no name is specified for the procedure.

	(lambda (<formal-parameters>) <body>)

The resulting procedure is just as much a procedure as one that is created using `define`. The only difference is that it's not associated with any name in the environment. In fact,

	(define (plus4 x) (+ x 4))

is equivalent to

	(define plus4 (lambda (x) (+ x 4)))

We can read a `lambda` expression as follows:

	the procedure of an argument x that adds x and 4

Like any expression that has a procedure as its value, a `lambda` expression can be used to [Didn't catch what follows. Once again Bruce moves too fast for my fingers.]

#### Creating local variables with `let` ####

	(let ((<var1> <expr1>)
		(<var2> <expr2>)))

The first part of the `let` expression is a list of name-expression pairs. When the `let` is evaluated, each name is associated with the value of the corresponding expression. [more stuff I couldn't catch]

A `let` expression is simply syntactic sugar for the underlying `lambda` application.

	> (let ((x 2))
		(+ x (* x 10)))
	22

	> ((lambda (x)
		(+ x (* x 10))) 2)
	22

<http://www.ccs.neu.edu/home/dorai/t-y-scheme/t-y-scheme.html>

> "I'm trying to illustrate an arguably complex concept, which I'm doing an arguably complex job explaining..."

> Bruce Bolden

<http://paulgraham.com/>

### 6 April 2005 ###

<http://naughtydog.com/jak2/>

Things ahead:

* Objects - Java
* Logic - Prolog

#### Data abstraction ####

_Data abstraction_ is a methodology that enables us to isolate how a compound data object is used from the details of how it is constructed from more primitive data objects.

To illustrate this, we will consider how to design a set of procedures for manipulating rational numbers (fractions).

#### Arithmetic with rational numbers ####

* `(make-rational <n> <d>)` returns the rational number where the numerator is `n` and the denominator is `d`
* `(numer <x>)` returns the numerator of `x`
* `(denom <x>)` returns the denominator of `x`

We're using a powerful strategy of synthesis here, wishful thinking.

Rules: Think about how you manipulate fractions.

	(define (add-rational x y)
		(make-rational (+ (* (numer x) (denom y))
		                  (* (numer y) (denom x)))
			(* (denom x) (denom y))))

#### Pairs ####

Scheme provides a complex structure called a _pair_, which can be constructed with `cons` (short for construct).

	(define (make-rational n d) (cons n d))

	(define (numer x) (car x))

	(define (denom x) (cdr x))

Cool side notes:

<http://www-sop.inria.fr/mimosa/fp/Bigloo/> - Another Scheme implementation

<http://www-sop.inria.fr/mimosa/fp/Skribe/> - Scheme based documentation system

It might be useful to display results:

	(define (print-rational x)
		(newline)
		(display (numer x))
		(display "/")
		(display (denom x)))

Now we can try things out.

	(define one-half (make-rational 1 2))

	(print-rational one-half)
	1/2

	(define one-third (make-rational 1 3))

	(print-rational (add-rational one-half one-third))
	5/6

Note: Reduction is not done! So we can fix `(make-rational)` if we have a GCD procedure.

	(define (gcd a b)
		(if (= b 0)
			a
			(gcd b (remainder a b))))

	(define (make-rational n d)
		(let ((g (gcd n d)))
			(cons (/ n g) (/ d g))))

Another way to do these is:

	(define make-rational cons)

	(define number car)

	(define denom cdr)

The bad news is that if we want to trace something like this, it's invoking `cons` every time we call `make-rational`, thus making it hard to set breakpoints. If we do it the other way, the details of how things are implemented (`cons`, `car`, and `cdr`) is irrelevant to us which is good.

### 8 April 2005 ###

Got our tests back today. I got an 84% which puts my grade for the class at 87%. I'll work a little to bring it up.

### 11 April 2005 ###

#### Expression evaluation ####

	<AE> ::= <num>
		| (+ <AE> <AE>)
		| (- <AE> <AE>)

	(define (add x y)
		(+ x y))

	(define (sub x y)
		(- x y))

	(define (parse sexp)
		(cond
			[(number? sexp) sezp]
			[(list? sexp)
				(case (first sexp)
					[(+) (add (parse (second sexp))
					          (parse (third sexp)))]
					[(-) (sub (parse (second sexp))
					          (parse (third sexp)))])]))

	> (parse (+ 2 3))
	5

	> (parse (+ (- 2 3) (+ 1 1)))
	1

We don't necessarily need another tool to do our expression evaluation.

#### Data abstraction ####

_Data abstraction_ is a methodology that enables us isolate how a compound data object is used from the detail of how it is constructed from more primitive data objects.

#### Hierarchical data ####

Pairs provide a primitive _glue_ that we can use to construct compound data types.

	(cons 1 2)

	(cons (cons 1 2) (cons 3 4))

	(cons (cons 1 (cons 2 3)) 4)

	(cons 1 (cons 2 (cons 3 (cons 4 '()))))

The last is the data structure we're most used to from the C and C++ world.

#### Closure ####

The ability to create pairs whose elements are pairs is the closure property of cons. In general, an option for attaching two data objects satisfies the closure property.

#### Recursion vs. iteration ####

General algorithm for finding the length of a list.

The base case is:

* The length of an empty list is 0.

The reduction step is:

* The length of any list is 1 plus the `length` of the rest (`cdr`) of the list.

This algorithm can be implemented either recursively or iteratively. The choice often depends on the language being used.

Recursive version:

	(define (length list)
		(if (null? items)
		0
		(+ 1 (length (cdr items)))))

Iterative version:

	(define (length-itr items)
		(define (length-itr2 ilist count)
			(if (null? ilist)
			count
			(length-itr (cdr ilist) (+ 1 count))))
		(length-itr2 items 0))

#### Patterns (cliches) ####

Transforming, counting, filtering, and finding (searching) are very useful and common programing operations. So common that there are primatives for them in Lisp. When a template is broadly useful, it is said to be programing cliche. (More recent terminology: design pattern). Common templates that merit cliche status:

* Counting
* Transforming
* Filtering
* Finding

Book recommendation: _Design Patterns_, i.e. the "Gang of Four (GOF)" book

<http://amazon.com/exec/obidos/tg/detail/-/0201633612/002-6924897-7688803>

This is the counting procedure in Lisp:

	(define <counting procedure> (input-list)
		(cond ((end? input-list) 0)
		((<element tester> (first input-list))
			(+ 1 (<counting procedure> (rest input-list))))
		(else (<counting procedure> (rest input-list)))))

Transforming:

	(define <transfroming procedure> (input-list)
		(if (end? input-list) nil
			(cons (<element transformer> (first input-list))
			      (<transforming procedure> (rest input-list)))))

Filtering:

	(define <filtering procedure> (input-list)
		(cond ((end? input-list) nil)
		      ((<element tester> (first input-list))
		       (cons (frist input-list)
		             (<filtering procedure> (rest input-list))))
		       (else (<filtering procedure> (rest input-list)))))

Finding:

	(define <finding procedure> (input-list)
		(cons ((end? input-list) 0)
		      ((<element tester> (first input-list))
		       (first input-list))
		      (else (<finding procedure> (rest input-list)))))

### 13 April 2005 ###

New assignment: Implement a Scheme program to manipulate a database for books.

* Symbol manipulation is a lot like working with words and sentences.
* Lisp makes computers intelligent.

#### set!-ing values ####

Changing a value is sometimes necessary. `set!` allows us to change the value of a variable (name) after is has been defined.

	> (define a 2)
	> a
	2

	> (set! a 3)
	> a
	3

#### Generators ####

Generating a sequence is a very useful process (some languages make this very easy).

	(define *previous-power-of-2* i)

	(define (power-o-two)
		(set! *previous-power-of-2* (* *previous-power-of-2* 2))
		*previous-power-of-2*)

	> (power-of-two)
	2
	> (power-of-two)
	4
	> (power-of-two)
	8

#### set-car! and set-cdr! ####

Can change part of a list using `set-car!` and `set-cdr!`.

	> (define test '(a b))

	> (set-car! text 'c)
	> test
	(c b)

	> (set-cdr! test 'c)
	> test
	(c . c)

#### Association lists ####

A list that consists of sublist, each of which contains a symbol, used as a key, at its first element, and a list value as its second element.

	assoc
	assq
	assv

These procedures find the first pair in the list whose car field is obj, and returns the pair. If no pair in the list has obj as its car, then #f (not the empty list) is returned. `assoc` uses `equal?` to compare `obj` with the `car` field... [Bruce moved too quick, and I didn't catch the rest.]

	(define book
		'((title (C++ in 24 minutes))
		  (author (John Smith))
		  (category (Programing))))

	> (assoc 'author book)
	(author (john smith))

	> (assoc 'title book)
	(title (c++ in 24 minutes))

	> (assoc 'date book)
	#f

We can change stuff in our database.

	> (cdr (assoc 'author book))
	((john smith))

	> (cadr (assoc 'author book))
	(john smith)

	> (set-cdr! (cdr (assoc 'author book)) '(Bill Jones))
	> book
	> ;; Shows the book.

### 15 April 2005 ###

Exam in two weeks. Scheme will be a large focus.

Plan and practice your presentations. Print out your slides and use the overhead projector thingy.

<http://jatha.sourceforge.net/>

<http://moller.com/skycar/>

#### Introduction to objects ####

What are objects? Software objects represent an abstraction of some reality.

What is Object-Oriented Programing (OOP)? OOP is a way of thinking about problem solving and a method of software organization and construction.

#### Data abstraction ####

Data abstraction associates some underlying data type with a set of operations to be performed on the data type. It's not necessary for a user or programmer to know how the data is represented. Data abstraction derives its strength from the separation of how the data is manipulated from the internal representation of the data.

#### Encapsulation ####

The combination of the underlying data and a set of operations that define the data type is called encapsulation. The internal representation of the data is encapsulated (hidden) but can be manipulated by the specified operations.

Each managed piece of state is called an object. An object consists of several stored quantities, called its _fields_, with associated methods (functions) that have access to the fields.

To facilitate the sharing of methods, OOP systems typically provide _classes_ which are structures that specify the fields and methods of each such object. Each object is created as an _instance_ of some class.

Organizing programs is this way permits a straightforward transaction from objects in the physical world or other application domains to the objects of the program.

The attributes that a language needs to be OO:

* _Objects_ encapsulate behavior (methods) and state (stored in fields).
* _Classes_ group objects that differ only in their state.
* _Inheritance_ allows new classes to be derived from existing ones.
* _Polymorphism_ allows messages to be sent to objects of different classes.

Various OO languages:

* Simula - 1967
* Smalltalk - 1972 (Xerox)
* C++ - 1981 (1985 Bjame Stroustrup)
* ObjectiveC - 1983 (1985 Brad Cox) 1993: NeXT, 2000: Apple
* Java - 1995 (Sun)
* CLOS - 1990

Book recommendation: _Dealers of Lightning_

#### OOP methodology ####

In general, the methodology for using Smalltalk consists of four steps:

1. Identify objects that appear in the problem and in the solution.
2. Classify the objects based on their differences and similarities.
3. Design the messages that will constitute the language of interaction between the objects.
4. Implement the methods by means of algorithms that carry out the interaction between objects.

#### Messages ####

Messages are sent or invoked on objects. In most OO languages, the syntax used to do this is:

	anObject.aMessage

In Java and C++ the syntax is:

	anObject.aMessage()

Note: A message may have one or more arguments.

#### Methods ####

A method is a function or procedure that defines an action associated with a message. It is defined as part of the class description. When a message is invoked on an object, the details of the operation are specified by the corresponding method.

### 18 April 2005 ###

#### Examples of objects ####

Geometric objects

* Circle
* Square
* Rectangle

#### Objects in C ####

A circle structure:

	/* circle.h */

	struct circle
	{
		double radius;
	};

	typedef struct circle Circle;

The code that manipulates our circle:

	/* circle.c */

	#include "circle.h"

	void SetRadius( Circle *c, double r);
	void ShowRadius( Circle *c );

	main()
	{
		Circle c1;

		c1.radius = 2.0;
		ShowRadius( c1 );

		SetRadius( &c1, 3.2 );
		ShowRadius( c1 );

		return 0;
	}

Pseudo OO. We can still access fields directly, and we don't have a method for data hiding.

#### Objects in C++ ####

Here's the `class` method for making circles:

	#include <iostream>

	class Circle
	{
		public:
			Circle();
			Circle( double r );

			void SetRadius( double r );
			void ShowRadius();

		private:
			double radius;
	}

	Circle::Circle()
	{
		radius = 1.0;
	}

	Circle::Circle( double r )
	{
		radius = r;
	}

	Circle::SetRadius( double r )
	{
		radius = r;
	}

	Circle::ShowRadius()
	{
		cout << radius << endl;
	}

We can have static or dynamic circles.

	// Static circles.
	Circle c1( 3.0 );
	Circle.ShowRadius();

	// Dynamic circles.
	Circle c2 = new Circle( 3.0 );
	c2->ShowRadius();

> "Use dynamic objects for dynamic things. Everything else, treat statically."

> - Bruce Bolden

#### Objects in Java ####

Making more circles, this time in Java. Notice that we don't have to prototype stuff here. Our interface file and implementation file are one and the same.

	public class Circle
	{
		double radius;

		public Circle()
		{
			radius = 1.0;
		}

		public Circle( double r )
		{
			radius = r;
		}

		public void setRadius( double r )
		{
			radius = r;
		}

		public void showRadius()
		{
			System.out.println( radius );
		}

		public static void main( String [] args )
		{
			Circle c1 = new Circle();
			Circle c2 = new Circle( 5.31 );

			System.out.print( "Radius of c1: " );
			c1.showRadius();
			System.out.print( "Radius of c2: " );
			c2.showRadius();

			c1.setRadius( 2.1 );
			System.out.print( "Radius of c1: " );
			c1.showRadius();
		}
	}

Note: `doulbe radius` is protected (private?) in this implementation. We can have a `main()` method in each class, hence we can put test code in each class.

> "I think compressing your code is really, really bad style."

> - Bruce Bolden

#### Object oriented linked lists ####

Compile: `javac File.java`  Output (byte code) stored in `File.class`

Run: `java File` starts execution at `main()` in the _class_ file.

For Java, recall that:

* it is case sensitive!
* there are no pointers in Java!
* has dynamic execution (we can edit source on the fly)

### 20 April 2005 ###

Book recommendation: anything by Donald Knuth.

<http://google.com/search?client=safari&rls=en&q=%22literate%20programing%22>

<http://www.literateprogramming.com/>

[missed the boat picture] relates to the last Scheme assignment.

Your code should have some kind of a header, who are you, what does it do?

	import java.io.*;

	class TestIntList
	{
		public static void main( String[] args )
		{
			list1 = new IntList( 3, new IntList( 2, list1 ));
			System.out.print( "list1: " );
			list1.print();
		}
	}

	class IntList
	{
		int value;
		IntList next;

		IntList( int x )
		{
			value = x;
			next = null;
		}

		IntList( int x, IntList aList )
		{
			value = x;
			next = aList;
		}

		int head()
		{
			return value;
		}

		IntList tail()
		{
			return next;
		}

		boolean empty()
		{
			return( this == null );
		}

		void print()
		{
			System.out.println( "print()" );

			if( this != null )
			{
				System.out.print( "{" );
				System.out.print( value );

				IntList tmpList = next;
				while( tmpList != null )
				// while( !tmpList.empty() )
				{
					System.out.print( ", " );
					System.out.print( tmpList.head() );
					tmpList = tmpList.tail();
				}

				System.out.print( "}" );
			}
		}
	}

Notice that NULL is all lowercase in Java. Plus, we don't have pointers, hence the self referential bit: `IntList next = aList;`.

* Objects are passed by reference.
* Values are passed by copy.
* Methods can only return one thing.

### 22 April 2005 ###

<http://images.google.com/images?q=liger>

Grading scheme for Scheme assignment:

* Header - 1
* Comments - 2
* Missing problems - 2 each
* Incomplete - 1
* Testing / output - 2
* Loop for table - 1

Test next Friday. Scheme will be a large focus.

A class for reading strings and numbers.

	/*  ReadStringNumber.java
	
		Bruce M. Bolden
		April 21, 2003
		Updated:  December 1, 2003
		http://www.cs.uidaho.edu/~bruceb/
	*/
	
	import java.io.*;
	import java.util.*;
	
	
	public class ReadStringNumber
	{
		/**  Input file name.   */
		static String inFileName = "testFunction.in";
		
		public static void main( String args[] )
		{
			try 
			{
				FileReader fIS = new FileReader( inFileName  );
				BufferedReader inS = new BufferedReader( fIS );
				
				FunctionUsageEntry fEntry;
				
				while( (fEntry = FunctionUsageEntry.readEntry( inS )) != null)
				{
					System.out.print( fEntry.getName() + " | " );
					System.out.println( fEntry.getLineNumber() );
				}
				
				inS.close();
			}
			catch ( java.io.IOException ioe )
			{
				// This are more for the programer than the user. Good error
				// messages should give you an idea of where things went wrong.
				System.out.println( "IO error: " + ioe )
			}
	        
			System.out.println( "Done!" );
		}
	}
	
	
	class FunctionUsageEntry 
	{
		String name; // Data fields
		int lineNumber;

		// Constructor
		FunctionUsageEntry( String fName, int lineNum )
		{
			name = fName;
			lineNumber = lineNum;
		}
		
		// If it throws an exception, it'll get caught in the other class.
		// Share an final (static) data / methods.
 		final public static FunctionUsageEntry readEntry( BufferedReader bIn )
			throws IOException
		{
			FunctionUsageEntry fEntry = null;
			
			String line = bIn.readLine();
			if( line != null )
			{
				// Cool string tokenizer class.
				StringTokenizer t = new StringTokenizer( line, " \t\n" );
				
				String fName = t.nextToken();
				
				// We can't just read a number. We have to read a string and
				// convert it into an integer. You should check to make sure
				// it's an integer before you convert it.
				int lineNum = Integer.parseInt( t.nextToken() );
				
				fEntry = new FunctionUsageEntry( fName, lineNum );
			}
		
			return fEntry;
		}
	   
		public final String getName()
		{
			return name;
		}
		
		final public int getLineNumber()
		{
			return lineNumber;
		}
	}

The Java API is your best friend when programing in Java. You're always looking things up since Java is rather large.

### 25 April 2005 ###

#### Exam ####

Similar to first part of Scheme quiz.

#### Answers to Scheme quiz ####

Problem 1:

a. 23
b. #f
c. 8

Problem 2:

	(define (ge a b)
		((and (> a b) (= a b))
			#t
			#f))
	
	(define (ge a b)
		(not (< a b)))

Study the forms for Scheme. Make sure you know them well.

#### Prolog ####

Prolog is a logic programing language.

A Prolog program is logic--a collection of facts and rules for proving things. They are not really "run". You pose questions, and the language system uses the program's collection of facts and rules to try to answer them.

You can do anything in Prolog that you can do in any other language (though it may not be as easy). Prolog is especially useful for searching in domains that define their problems in terms of logic. Prolog is one of the two most popular AI languages (Lisp is the other).

The solution the the farmer, wolf, goat, cabbage puzzle can be done in a page of Prolog vs. five plus pages for C++.

#### Prolog terms ####

Everything in a Prolog program, both the data and the program, is built from Prolog terms:

* Constants
* Variables
* Compound terms (structures)

#### Constants ####

Integers, real numbers, or an _atom_.

Any name that starts with a lowercase letter is an _atom_. Atoms look like variables in other languages, but are constants in Prolog. The atom _n_ is never equal to anything but the atom _n_.

Sequences of non-alphanumeric characters are atoms.

Special atoms:

* `[]` empty list
* `!` cut
* `;` disjunction

#### Variables ####

Variables are any name beginning with an uppercase letter or an underscore. The underscore (`_`) is an anonymous variable.

#### Compound terms ####

Compound terms have an atom followed by a parenthesized comma-separated list of terms.

	parent(mark, john).
	parent(mark, Child).

Think of these as structured data, even though they look like function calls in other languages.

#### Facts ####

Facts are defined using compound terms.

	parent(mark, john).

Note: must be careful about the order of the objects in the relationship.

* The name of the relationship and objects must begin with lowercase terms.
* The objects are separated by commas and enclosed in parenthesis, and the relationship is written first.
* A period must come at the end of a fact.

#### Unification ####

Pattern matching using Prolog terms is called unification. Prolog makes extensive use of pattern matching. Two terms are said to _unify_ if there is some way of binding their variables that makes them identical. Consider these two terms:

	parent(mark, john).
	parent(mark, Child).

These unify by binding the variable `Child` to the atom `john`. Finding a way to unify two terms can by tricky.

	parent(mark, john).
	parent(sally, sue).
	parent(sally, john).
	parent(mary, sally).
	parent(steve, mark).

An atom that starts a compound term with _n_ predicates is called a _predicate of arity n_.

	?- consult(relations).

The `consult` predicate adds the contents of a file to the system's internal database.

To terminate, type `halt`.

	?- halt.

If we query the relations file:

	?- parent(mary, sally).
	Yes
	?- parent(barney, bambam).
	No
	
	?- parent(P, sally).
	P = mary
	Yes
	
	?- parent(P, pebbles).
	No
	?- parent(mary, Child).
	Child = sally
	Yes
	?- parent(Parent, Child).
	Parent = mary
	Child = sally

#### Conjunctions ####

Here's our data file:

	likes(john, food).
	likes(john, cake).
	likes(john, motorcycles).
	likes(jake, food).
	likes(jake, pepsi).
	
Is there anything both John and Jake like?

	?- likes(john, X), likes(jack, X).

Prolog tries to answer the question by satisfying the first goal. If the first goal is in the database, then Prolog marks the place in the database and attempts to satisfy the second goal. Each goal keeps its own place.

#### Rules ####

Rules are used when we want to say that a fact _depends_ on a group of other facts. Rules consist of a _head_ and a _body_. The head an body are connected by the symbol `:-` and is pronounced _if_.

	male(john).
	male(adam).

	female(marry).
	female(sally).

	parents(john, adam, sally).
	parents(mary, adam, sally).

	sister_of(X, Y) :-
		female(X),
		parents(X, M, F),
		parents(Y, M, F).

Is the neck a `:-` or a `:=`?

### 27 April 2005 ###

Test on Friday:

* Basic Scheme concepts - 20
* Scheme programing - 40
	* Coding
	* Analysis (10)
* OO concepts - 20

#### Topics on test 2 ####

* Scheme
	* Functional
	* Lists
	* Recursion
	* Properties

Coding constraint:

You may only use `car`, `cdr`, `lambda`, `cond`, `if`, `and`, `or`, `not`, `basic` predicates: `equal?`, `null?`, `pair?`, mathematical operators: `+`, `-`, `*`, `/`, `remainder`, relational operators: `=`, `<`, `>`, `<=`, `>=`. There might be code using `(assoc)`, but probably not likely.

> "A well constructed sentence will probably get you full credit. Two sentences may be better in some cases. _War and Peace_ will probably get you negative credits."

> - Bruce Bolden

#### Prolog ####

On the sun-sol machines (sun-sol.cs.uidaho.edu), `gprolog`, the GNU Prolog is available.

#### Structures (compound terms again) ####

Recall that compund terms (structures) are a collection of other objects, colled components.

Structures help to organize the data in a program because they permit a group of related information to be treated as a single object instead of separate entries.

Structures can be used in the question-answering process by using variables.

	owns(bruce,book(prolog,clocksin_mellish)).
	owns(bruce,book(the_c_Programing_Language,kernighan)).

	owns(bruce,book(X,clocksin_mellish)).

	owns(bruce,book(X,_)).  ??

Note that the syntax for structures is the same as for a fact.A predicate is actually the functor of a structure.

Recall that `_` is the anonymous variable.

#### Equality and matching ####

`=` is an infix operator that checks to see if there is a match and is pronounced "equals".

	?- X = Y.

`\=` is a predicate pronounced "not equal".

	?- X \= Y.

#### Arithmetic ####

Typical relation operators:

	X = Y
	X \= Y
	X < Y
	X > Y
	X => Y
	X <= Y

Here's Bruce's notes in PDF form:

<http://www.cs.uidaho.edu/~bruceb/cs310/notes/25_Prolog.pdf>