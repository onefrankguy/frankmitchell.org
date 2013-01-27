<!--
title: Measuring software reliability
created: 2 February 2006 - 9:37 pm
updated: 2 February 2006 - 10:39 pm
slug: robust-code
tags: design
-->

I attended a talk by John Munson entitled "Measuring Software Reliability". The
gist of it was:

> "Tell me how you use the software and I'll tell you how reliable you'll be."

According to the speaker, software can be mapped from a description of its use
(operational specification), to a description of its design (functional
specification), to a description of its actual implementation in code (modular
specification). This gives you the ability to go from use case to code that's
executed during that use case.

Measurements of the software are then taken over a period of time (though what
exactly these measurements are was never explained), and the reliability of the
software at the current time can be calculated from its past performance.

Does anyone else see where this breaks down in the real world? Case example: the
Y2K bug. Everything is running fine for decades. We have a solid history of
reliability. Then all of the sudden, we're up against a scenario that the
designers never considered, and suddenly reliability goes down the tubes.

Plus, you have to realize that customers are motivated by features and companies
are motivated by money. You have to constantly be putting in new stuff, or your
customer's going to go looking for the competition when you can't provide her
with what she wants. Release cycles where the code is continually changing
really mess with your ability to measure reliability.

Change is inevitable. The sooner we start looking at software engineering as a
discipline that's unprecedented (because it is), the better off we'll be. The
practices that work for the mechanical engineers and the electrical engineers
don't work for us. Software is far more flexible and bounded by far fewer laws
than some academics would have you believe.

I will, however, agree that there are some instances where this kind of
measurement could be really useful. ATMs, airplane flight control systems, and
anything else where the operational environment is controlled, and all the
inputs are known, could probably benefit from reliability measurement.
Interestingly enough, those are the kinds of environments where you would
_want_ reliability measurement, because they're the ones that are high risk.

So it's one of those things that works well in academia and fault tolerant
systems, but is of little use when it comes to building applications that real
people will use to do many different things.

## Notes ##

Here are my notes from the talk. The roughly correspond to the PowerPoint
slides presented.

### The Notion of Reliability ###

* Related to the notion of a failure event
* Likelihood that a system will not fail during some usage interval
* Failure event is observable
* Time between failure events is observable

### Characteristics of Hardware Systems ###

* All manufactured systems are different
* Different molecules
* Different mechanical structures
* Slight variation in manufactured components
* Will wear out over _time_
* Will eventually _fail_

### Characteristics of Software Systems ###

* All manufactured systems are identical
* Software is eternal
* Software is ethereal
* Software does not change as a function of time
* Software does not wear out

### Measuring Software Behavior ###

* Software systems do not fail monolithically
* Software modules fail
* Not all features execute all modules
* Some features execute some fail prone modules

### Functional Reliability ###

* Programs made up of many structurally independent modules
* Some modules are good (fault free)
* Some modules are bad (fault prone)
* Each functionality exercises only a small set of program modules

### Software Physics ###

* The notion of time has no meaning in software
* Programs do not fail because they wear out
* Programs do not change with respect to time
* Past reliability of a program is not a good predictor of future reliability
  (Y2K)

### 3D Mouse Example ###

* User manipulates a tennis ball
* Put spots on a tennis ball and user pattern recognition
* Put accelerometers in a tennis ball and measure the delta
* Operations map to Functionalities (O x F)
* Functionalities map to Modules (F x M)

### Measurement ###

* There are probabilities for the execution of operations, functions, and
  modules
* Watch your software execute and see the patterns of execution
* Build a meter to give an estimate of reliability right now based on past
  performance
