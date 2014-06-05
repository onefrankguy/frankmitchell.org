<!--
title: Regulating voltage with junk box parts
created: 31 May 2014 - 7:46 am
updated: 4 June 2014 - 9:17 pm
publish: 4 June 2014
slug: voltage-regulator
tags: building, radio
-->

<script src="/js/d3.min.js" charset="utf-8"></script>

In sharp contrast to something like the transmit filter, where the
mathematical details of complex conjugates are discussed, the description of
the voltage regulator for the NorCal 40A in [_The Electronics of Radio_][book]
is remarkably brief. A line on page 152 simply states,

> We will not study regulators but detailed information about this regulator
> is given in Appendix D.

Thumbing through Appendix D, I found a remarkably thorough parts sheet, but
little insight into what and why. Given that building my own radio is all about
learning, I decided to dig into the details and figure out how the power supply
in the [NorCal 40A][] works. Before we get into that though, here's a picture of
the assembled power supply circuit.

<img class="game art" width="640px" height"640px"
     src="/images/norcal-40a-voltage-regulator-parts.jpg"
     alt="A close up view of the assembled voltage regulator in the NorCal 40A transceiver, looking down on the on/off switch from the back.",
   title="A close up view of the assembled voltage regulator in the NorCal 40A transceiver, looking down on the on/off switch from the back." />

From left to right, there's a 10 microfarad capacitor, a 47 nanofarad capacitor,
a single pole double throw switch, a 78L08 voltage regulator, a 1N5817 diode,
and a 2.1 millimeter power jack. The schematic below shows how they fit together
electrically.

I had a bit of concern about my soldering skills after I put in that switch.
See the front leg (as seen in the picture above, where front is closest to you)
isn't connected to anything. I probed the joint with an ohm meter and it didn't
go anywhere. It didn't go to ground. It wasn't shorted to nearby components. It
was just an unconnected solder pad on the board. The term for that kind of
connection is "floating".

It turns out that's a single pole double throw switch. So when it's in the off
position, the front and middle legs are connected. When it's in the on position,
the middle and back legs are connected. Normally, you'd use a single pole single
throw switch (with just two legs) for an on/off type connection. However,
there's an identical switch on the front panel of the NorCal 40A that uses both
connections. Using the same type of switch for both is one fewer kind of part
you have to buy.

Speaking of parts, I have a friend who spent a couple of semesters at ITT Tech.
He says the best thing he got out of it was a junk box. You really do need a lot
of good junk if you want to build radios. Pete Juliano, N6QW, has a nice article
about [what makes a good junk box][n6qw]. For fun, we'll pretend we've got a
virtual junk box stocked with all the parts Pete lists.

## Why battery packs are big ##

Suppose we want to power a [Philips SA602A double-balanced mixer and
oscillator][sa602a], like the one found in the NorCal 40A transceiver. Looking
through its data sheet, we see typical operation requires 6 volts of power
and draws 2.4 milliamperes of current. How do we get power that precise?

The obvious solution would be a 6 volt battery. The AA alkaline batteries
I keep sitting around in my cupboard for the Xbox controller can supply 1.5
volts and up to 250 milliamperes. Slap four of them together in series, and
we should have enough juice to drive our mixer, right? Not quite.

That 1.5 volt measurement only applies when the battery is fully charged.
Since it's been sitting in my cupboard for months, it might only have 1.4
volts of charge left. So we probably want to stick six or eight batteries
together in series for 9 to 12 volts of power. That will ensure we've got
the minimum 6 volts needed for the mixer, even if some of the batteries
are shot.

## Locking in a reference voltage ##

Given that we've got a variable 9 to 12 volts of power, how can we reduce
that to the 6 volts we need? The solution is to use a voltage regulator.

The heart of a voltage regulator is a Zener diode. A normal diode only
allows current to flow in one direction. Applying voltage in the opposite
direction won't do anything until the diode's reverse breakdown voltage is
exceeded. After that, current flows through the diode uncontrollably and it
overheats. This is known as avalanche breakdown.

But a Zener diode has controlled breakdown. When it's reverse-biased and its
reverse breakdown voltage is exceeded, it regulates the amount of current
flowing through it to keep the voltage drop across it constant. That reference
voltage drop is known as the Zener voltage.

Dig through our junk box, and we can pull out a 8.2 volt Zener diode like the
[Philips BZX79-B8V2][bzx79].

## Simple voltage regulation ##

The circuit below shows the simplest possible voltage regulator we can use
for our mixer. We've got our 12 volt battery pack. We've got our 8.2 volt Zener
diode for a reference voltage, and we've got a 470 ohm resistor.

How did we pick that value for the resistor? We know the current through the
resistor will be split between the diode and the mixer. The mixer will draw
2.4 milliamperes and the rest will go through the diode. Let's double that
and go up a bit, and we'll say we want 5 milliamperes through our resistor.
Ohm's Law tells us that resistance is voltage divided by current.

<p class="math">R =
<span class="fraction">
<span class="fup">V</span>
<span class="bar">/</span>
<span class="fdn">I</span>
</span>
</p>

Our Zener diode will use 8.2 volts and our resistor will pick up the rest.
If we run with the maximum power of 12 volts, we'll have 3.8 volts across
our resistor. Plugging in 3.8 volts for V and 5 milliamperes for I gives
us the maximum value of our resistor.

<p class="math">760 ohms =
<span class="fraction">
<span class="fup">3.8 volts</span>
<span class="bar">/</span>
<span class="fdn">0.005 amps</span>
</span>
</p>

If we run with the minimum power of 9 volts, we'll have 0.8 volts across
our resistor. Plugging in 0.8 volts for V and 5 milliamperes for I gives
us the minimum value of our resistor.

<p class="math">160 ohms =
<span class="fraction">
<span class="fup">0.8 volts</span>
<span class="bar">/</span>
<span class="fdn">0.005 amps</span>
</span>
</p>

The 470 ohm resistor in our junk box fits nicely between those two ranges.

## Stepping down the voltage ##

Digging into the data hseet for our Zener diode, we see that its total power
dissipation is 500 milliwatts. That's the maximum amount of power we can feed
our diode before it breaks down. Ohm's Law tells us that the maximum current
through our diode will be its maximum power in watts divided by its Zener
voltage in volts.

<p class="math">I =
<span class="fraction">
<span class="fup">P</span>
<span class="bar">/</span>
<span class="fdn">V</span>
</span>
</p>

We can plug in 0.5 watts for P and 8.2 volts for V to figure out how
much current our diode will handle.

<p class="math">0.061 &asymp;
<span class="fraction">
<span class="fup">0.5</span>
<span class="bar">/</span>
<span class="fdn">8.2</span>
</span>
</p>

Our diode can handle about 61 milliamperes before it fails. In practice, it's
a good idea never to load a Zener diode with more than half its maximum allowed
current. That gives us a max of 30 milliamperes to power our mixer with, which
is plenty.

## Where we go from here ##

This is the third part in a multi-part series about building the NorCal
40A transceiver. Links to the other parts are below.

1. [Building my first HF radio][norcal-40a]
2. [Learning how a transmit filter works][transmit-filter]
3. Regulating voltage with junk box parts

For the curious, photos where taken with an [iPhone 5][], cropped and resized
with [Acorn][], and compressed with [ImageOptim][]. Schematics where drawn with
[circuitikz][] and graphs where created with [D3][].


[book]: http://cambridge.org/us/academic/subjects/engineering/rf-and-microwave-engineering/electronics-radio "David Rutledge (Cambridge University Press): The Electronics of Radio"
[NorCal 40A]: http://www.fix.net/~jparker/wilderness/nc40a.htm "Bob Dyer, K6KK (Wilderness Radio): The NorCal 40A"

[sa602a]: http://www.nxp.com/documents/data_sheet/SA602A.pdf "Various (NXP Semiconductors): SA602A Double-balanced mixer and oscillator - Product data sheet"
[n6qw]: http://www.jessystems.com/How%20To%20Stuff%20A%20Junk%20Box.pdf "Pete Juliano, N6QW: How To Stuff A Junk Box"
[bzx79]: http://www.nxp.com/documents/data_sheet/BZX79.pdf "Various (NXP Semiconductors): BZX79 series voltage regulator diodes - Product data sheet"

[norcal-40a]: /2014/05/norcal-40a "Frank Mitchell: Building my first HF radio"
[transmit-filter]: /2014/05/transmit-filter "Frank Mitchell: Learning how a transmit filter works"
[iPhone 5]: http://support.apple.com/kb/sp655 "Various (Apple): iPhone 5 Technical Specification"
[Acorn]: http://flyingmeat.com/acorn/ "Gus &amp; Kirstin Mueller (Flying Meat): Acorn - The image editor for humans"
[ImageOptim]: http://imageoptim.com/ "@pornel (ImageOptim): Image compression made easy for Mac OS X"
[circuitikz]: http://www.ctan.org/pkg/circuitikz "Massimo Redaelli (CTAN): circuitikz - Draw electrical networks with TikZ"
[D3]: http://d3js.org/ "Mike Bostock (D3): Data-Driven Documents"
