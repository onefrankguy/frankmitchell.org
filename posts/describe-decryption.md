<!--
title: Describing Your Way to Decryption
created: 3 May 2005 - 4:41 pm
updated: 3 May 2005 - 4:41 pm
slug: ste-decipher
tags: security
-->

Al's talk to the ACM on STE and decryption.

### History ###

* Encryption has been used for thousands of years.
* Written security took many forms
	* Shaved heads and then codes
* Computers begin being used around WWII
* The "modern" era of cryptography dates to Shannon in 1940's

### Shannon Theory ###

* Comes from "Communication Theory of Secrecy" in 1949
* Talks about "confusion" and "diffusion"
* Discusses "unicity", "redundancy", and "entropy"
* These key concepts have resulted in DES, RSA, and CipherSmith
* Also responsible for the direction of modern cryptography

### Entropy ###

* Entropy is the uncertainty in a letter before you know it
* Based on Hartley's function
* Gives an idea of how much uncertainty remains after randomly picking a member of a set
* Maximum where you have a uniform probability

### Entropy and Redundancy ###

* Redundancy indicates how often information is repeated in a string
* Languages are not uniformly random
* This is all conditional

### Unicity ###

* Unicity is the measure of the average number of symbols needed to break a code
* For a substitution cipher _n_ = 26 symbols
* The R<sub>L</sub> measure was empirically determined
* Minimum (lower limit) when R<sub>L</sub> = 1

### Set Theoretic Estimation ###

* Been used for years for many different problems
* The method is based largely on set theory and has certain requirements
* Uses "Last Man Standing"
* Requires:
	* A function that resolves to a discrete point
	* The function and any "noise" must be bounded
	* The function and it's inverse must be one-to-one and onto
	* Must know elements of target set
	* Must be continuous

### Property Sets ###

* Describe some property of the solution given an input
* The property set maps back to the possible inputs
* Each property must be a subset of possible inputs
* The solutions must be a member of all the property sets
* We can use AND and intersection
* Finding one property eliminates other property sets

### Sets ###

Language -> English -> Letters -> Sentences -> Words -> M-grams

### Why STE? ###

* A close examination of Shannon reveals he used a STE approach
* Shannon attempted to build up a solution with p(k) = 1
* Shannon used m-grams to find p(k)

### More M-grams ###

* We have a list of forbidden m-grams: qqq, zxy, bbqxnk, etc.
* We also used allowed m-grams

### Property Sets ###

1. English language
2. Doubled letters
3. M-grams for 2 through 6 and 13
4. Letter frequency for very uncommon and extremely common letters
5. Words and sentences

### Simple Example ###

* Encrypted data: xyz
* Possible decryptions: amy, mut, oop, lly
* oop and lly are out since their patterns don't match

### Where's the data come from? ###

* Training done by checking generally recognizable works in English
* Works are chosen from literature from various genres
* Each author is represented by several texts
* Removed non-alphabetic characters to count words, m-grams, etc.

### Testing ###

1. Encrypt file
2. Randomly select start point
3. Read one character at a time
4. If the matrix changes, reapply the changes to the stuff we've already seen
5. Continue until all letters are found (need 25)
6. Constantly check against key to make sure we haven't made a mistake

### Results ###

* Shift cipher
	* Using all property sets
	* 1142 tests
	* 100% success
	* 5.0 symbols average std. dev = .5545 symbols
	* Traditional unicity is 1.3 symbols
	* Used only 4 and 5-grams
* General substitution cipher
	* Used 12 runs per work
	* Ran a composite set of all authors against each author
	* Ran a total of 12792 tests
	* Authors always correctly decrypt their own works
	* Authors of similar style and era sometimes work
	* The composite set decrypted all works correctly
	* Unicity was 17.456 symbols
	* Std. dev. was 5.53 symbols
	* High was 91 symbols
	* Low was 13 symbols
	* Average time / test was less than 1 ms
	* Remove worst 5 cases and get std. dev. of 3.36 symbols

### Extensions and Future Work ###

* Add data from words (variable length m-grams)
* Add data from sentence structure
* Entropy needs a ton more attention
* Examine more ciphers to see if they're vulnerable too (XOR, stream, block, etc.)
* Stylometry (Morton 1976)
* Language recognition via STE
* Parallel processing

### Conclusions ###

* Can't apply theories of uniform and random distribution to language since they're not valid
* Certain parts of a string are more vulnerable than others. How can we find them?
* In effect, we're changing the probability distribution function
* STE can be a powerful tool for decryption
* STE provides a framework for explaining Shannon
* Need more people
