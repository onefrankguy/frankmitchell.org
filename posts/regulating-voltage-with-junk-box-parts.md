<!--
title: Regulating voltage with junk box parts
created: 31 May 2014 - 7:46 am
updated: 14 June 2014 - 7:02 am
publish: 14 June 2014
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
little insight into what how the voltage regulator worked, or why all the other
bits are there. Given that building my own radio is all about learning, I
decided to dig into the details and figure out how the power supply in the
[NorCal 40A][] works. Before we get into that though, here's a picture of the
assembled circuit.

<img class="game art" width="640px" height"640px"
     src="/images/norcal-40a-voltage-regulator-parts.jpg"
     alt="A close up view of the assembled power supply in the NorCal 40A transceiver, looking down on the on/off switch from the back.",
   title="A close up view of the assembled power supply in the NorCal 40A transceiver, looking down on the on/off switch from the back." />

From left to right, there's a 10 microfarad capacitor, a 47 nanofarad capacitor,
a single pole double throw switch, a 78L08 voltage regulator, a 1N5817 Schottky
diode, and a 2.1 millimeter DC power jack. The schematic below shows how they
fit together electrically.

A 10 to 15 volt DC power source feeds power in through the jack, past the diode,
to the switch, where it's filtered by the capacitors, then regulated down to
8 volts. Pretty standard for a power circuit. Here's how it works and why
each piece is there. We'll start with the battery pack and the DC jack.

## Why battery packs are big ##

The image below shows the back panel of the NorCal 40A. The 2.1 millimeter
power input jack is clearly labeled as accepting 10 to 15 volts DC. It's also
labeled as being center pin positive. I dug through the wall warts in my junk
box, and all of them where center pin negative. So much for driving my radio
off the mains. Guess I'm going wth a portable power supply.

<img class="game art" width="640px" height"640px"
     src="/images/norcal-40a-voltage-regulator-panel.jpg"
     alt="A view of back panel of the NorCal 40A transceiver, showing off the DC power jack and on/off switch.",
   title="A view of back panel of the NorCal 40A transceiver, showing off the DC power jack and on/off switch." />

Part of that 10 to 15 volts of power will go to the [Philips SA602A
double-balanced mixer and oscillator][sa602a]. Looking through its data sheet,
we see typical operation requires 6 volts of power and draws 2.4 milliamperes
of current. How do we get power that precise?

The obvious solution would be a 6 volt battery. The AA alkaline batteries
I keep sitting around in my cupboard for the Xbox controller can supply 1.5
volts and up to 250 milliamperes. Slap four of them together in series, and
we should have enough juice to drive our mixer, right? Not quite.

That 1.5 volt measurement only applies when the battery is fully charged.
Since it's been sitting in my cupboard for months, it might only have 1.4
volts of charge left. So we probably want to stick seven or eight batteries
together in series for 10 to 12 volts of power. That will ensure we've got
the minimum 6 volts needed for the mixer, even if some of the batteries
are shot.

Below is a picture of a 12 volt battery back, the kind that holds eight AA
batteries in place with spring connectors. I got mine from [Adafruit][12v].

It ended up being cheaper to get the battery pack than it was to get the 2.1
millimeter plug and switch on their own. Dave Bixler, W0CH, points out that his
NorCal 40A [runs just fine from a 12 volt battery pack][w0ch], so we don't
have to worry about not having enough juice for our mixer. With the power source
covered, we can move on to the next part in our circuit, the diode.

## Basic polarity protection ##

The diode prevents the mixer from frying if the power source is accidentally
plugged in backwards. Assuming there's a fuse in the power source line, the
diode will block the flow of current if power is reversed and trip the fuse.
This is known as polarity protection, and it's the most basic kind of power
protection.

If there's no fuse in the power source line, the diode will actually probably
survive just fine. A [1N5817 Schottky diode][1n5817] has a maximum reverse
voltage of 20 volts, which is about 8 volts more than what we'll get out of
our battery pack.

The fact that it's a Schottky diode means that the forward voltage drop will
be low compared to other types of diodes. At three amps, the 1N5817 has a
forward voltage of 750 millivolts. Ohm's Law tells us that resistance in a DC
circuit is voltage divided by current.

<p class="math">R =
<span class="fraction">
<span class="fup">V</span>
<span class="bar">/</span>
<span class="fdn">I</span>
</span>
</p>

Plugging 0.75 volts in for V and 3 amps in for I, we find the diode has a
resistance of about 0.25 ohms.

<p class="math">0.25 ohms =
<span class="fraction">
<span class="fup">0.75 volts</span>
<span class="bar">/</span>
<span class="fdn">3 amps</span>
</span>
</p>

Of course resistance is a function of how much current we pump through the
diode, and it's not linear. The lower the current, the higher the resistance.
At one amp the forward voltage is 450 millivolts for a resistance of 0.45 ohms.
That's still very low. It's nice to know that we're not sacrificing much power
for polarity protection. There are actually [polarity protection schemes that
sacrifice less power][n0gsg], like using a MOSFET, but they come with other
costs, like requiring more components to ruggedize them.

## Keeping part counts (and cost) low ##

The switch is next, and I had a bit of concern about my soldering skills after
getting it in. Looking at the switch from the back, you can see there are three
legs that come off it and attach to the circuit board.

<img class="game art" width="640px" height"640px"
     src="/images/norcal-40a-voltage-regulator-switch.jpg"
     alt="An overhead view of the single pole double throw on/off switch in the NorCal 40A transceiver, showing the three solder pads that attach the switch to the circuit board.",
   title="An overhead view of the single pole double throw on/off switch in the NorCal 40A transceiver, showing the three solder pads that attach the switch to the circuit board." />

The top leg (as seen in the picture above, it's the one closest to you) isn't
connected to anything. I probed the joint with the continuity check function on
my multimeter and it didn't go anywhere. It didn't go to ground. It wasn't
shorted to nearby components. It was just an unconnected solder pad on the
board. The term for that kind of connection is "floating".

It turns out that's a single pole double throw switch. So when it's in the off
position, the top and middle legs are connected. When it's in the on position,
the middle and bottom legs are connected. Normally, you'd use a single pole
single throw switch (with just two legs) for an on/off type connection. However,
there's an identical switch on the front panel of the NorCal 40A that uses both
connections. Using the same type of switch for both makes for fewer kinds of
parts. When you're building radios, that's a good thing, since it keeps costs
down.

## Noisy power source protection ##

We can't do the same cost savings on the capacitors that we did with the switch.
We actually do need both of them, one large electrolytic at 10 microfarads and
one small disc at 47 nanofarads. These capacitors smooth out noisy power
sources.

Our circuit has a little bit of inductance from the diode. This inductance means
the power source can't respond instantly to power need changes in the mixer. The
large electrolytic capacitor (it's the blue one in the picture) acts as a
reservoir of charge. It can deliver a burst of power on demand until current can
get through the diode. It also acts as a filter to remove low frequency AC noise
that might be imposed on the line.

The small disc capacitor (it's the orange one in the picture) acts as a filter
to remove high frequency AC noise that might be imposed on the line. Sometimes
a small ferrite bead is placed in series with the supply line to help remove
internally generated noise too.

Capacitors used in this fashion are called decoupling capacitors, since they
break the circuit into two parts, and offer an alternative path for AC to flow
through. Other names for them are bypass capacitors or shunt capacitors.

## Sourcing a junk box of parts ##

Okay, we've got a safe clean variable power source of 10 to 12 volts. How can
we reduce that to the 6 volts we need for our mixer? The solution is to use a
voltage regulator.

The voltage regulator in the NorCal 40A is a [78L08][78l08]. On the outside it's
a tiny three legged device in a TO-92 package. But inside it's packed with about
thirty-two discrete parts. Rather than try to analyze that entire circuit, we'll
build our own virtual one instead.

You need a lot of good junk if you want to build stuff. I have a friend who
spent a couple of semesters at ITT Tech. He says the best thing he got out of it
was a junk box. For our virtual junk box, we'll borrow a parts list from Pete
Juliano, N6QW. He has a nice article about [what makes a good junk box][n6qw],
so let's build our voltage regulator from that.

## Locking in a reference voltage ##

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
diode for a reference voltage, and we've got a 100 ohm resistor.

<img class="game art" width="446px" height"216px"
     src="/images/norcal-40a-voltage-regulator-simple.png"
     alt="An unregulated 12 volt battery is connected in series to a 100 ohm resistor. In parallel with the battery is a reverse-biased 8.2 volt Zener diode. The result is a regulated 8.2 volt source.",
   title="An unregulated 12 volt battery is connected in series to a 100 ohm resistor. In parallel with the battery is a reverse-biased 8.2 volt Zener diode. The result is a regulated 8.2 volt source." />

How did we pick that value for the resistor? Well we know the current through
the resistor will be split between the diode and the mixer. The mixer will draw
2.4 milliamperes and the rest will go through the diode. How much current
can the diode handle?

Digging into the data sheet for our Zener diode, we see that its total power
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

<p class="math">0.061 amps &asymp;
<span class="fraction">
<span class="fup">0.5 watts</span>
<span class="bar">/</span>
<span class="fdn">8.2 volts</span>
</span>
</p>

Our diode can handle about 61 milliamperes before it fails. In practice, it's
a good idea never to load a Zener diode with more than half its maximum allowed
current. That gives us a max of 30 milliamperes to power our mixer with, which
is plenty.

Thirty milliamperes of power minus the 2.4 milliamperes the mixer will draw
leaves us with 27.6 milliamperes through our resistor. Ohm's Law tells us that
resistance is voltage divided by current.

<p class="math">R =
<span class="fraction">
<span class="fup">V</span>
<span class="bar">/</span>
<span class="fdn">I</span>
</span>
</p>

Our Zener diode will use 8.2 volts and our resistor will pick up the rest.
If we run with the minimum power of 10 volts, we'll have 1.8 volts across
our resistor. Plugging in 1.8 volts for V and 27.6 milliamperes for I gives
us the minimum value of our resistor.

<p class="math">65 ohms &asymp;
<span class="fraction">
<span class="fup">1.8 volts</span>
<span class="bar">/</span>
<span class="fdn">0.0276 amps</span>
</span>
</p>

We don't actually have a 65 ohm resistor in our junk box. The closest we've got
are 50 ohm resistors and 100 ohm resistors. Using a 50 ohm resistor feeds
our diode with about 36 milliamperes. That's more than the 30 milliampere
maximum we calculated. Using a 100 ohm resistor feeds our diode with about 18
milliamperes. That's well under the 30 milliampere maximum and still leaves us
with the 2.4 milliamperes we need to drive our mixer. Hence our choice of a 100
ohm resistor.

## Kicking up the current ##

While 18 milliamperes might be enough to drive our mixer, it's not enough to
drive our mixer plus all the other parts in our radio. We've still got buffers,
amplifiers, and oscillators we need to power as well. How do we go from 18
milliamperes to the 225 milliamperes the NorCal 40A consumes when it transmits?

The solution is a current amplifier, which we can implement with a 2N2222
transistor. Wayne Burdick, N6KR, once referred to the 2N2222 as "the cockroach
of the transistor world." As he said, "No matter what happens to us or the
planet, you'll sill be able to find them in huge quantities." And it's true.
We've got one in our junk box. Here's what it looks like plugged into our
voltage regulator.

<img class="game art" width="505px" height"322px"
     src="/images/norcal-40a-voltage-regulator-amped.png"
     alt="The positive terminal of an unregulated 12 volt battery is connected to the collector of a 2N2222 transistor. A reverse-biased 8.2 volt Zener diode is connected to the negative terminal of the battery and the base of the transistor. A 220 ohm resistor is shorted across the base and collector of the transistor. The result is a regulated 8.2 volt source (at the emitter of the transistor) that can handle a load of at least 225 milliamperes.",
   title="The positive terminal of an unregulated 12 volt battery is connected to the collector of a 2N2222 transistor. A reverse-biased 8.2 volt Zener diode is connected to the negative terminal of the battery and the base of the transistor. A 220 ohm resistor is shorted across the base and collector of the transistor. The result is a regulated 8.2 volt source (at the emitter of the transistor) that can handle a load of at least 225 milliamperes." />

Current flows through our resistor into our Zener diode, which regulates the
amount of current passing through it so the voltage at the base of the
transistor is 8.2 volts. Since the transistor is connected in forward-emitter
mode, it will open a path for current to flow from the collector to the emitter.
This collector-emitter current is what powers our radio.

Let's suppose we've got our receiver on, and it's drawing 15 milliamperes.
If we switch our transmitter on, the load current will increase to 225
milliamperes. Previously, that current would have to pass through our Zener
diode, which we know can't handle it. But the addition of the transistor puts
the Zener diode on a separate branch. Load current passes through the transistor
instead, which can handle the demand.

I addition to dropping in that transistor, we also increased the value of our
resistor from 100 ohms to 220 ohms. The formula for computing that resistance in
ohms is to take the minimum voltage across the resistor in volts and divide it
by the sum of the minimum current through the diode in amperes, plus the value
of the maximum load current in amperes divided by one plus the forward gain of
the transistor.

<p class="math">R =
<span class="fraction">
<span class="fup">V<sub>R</sub></span>
<span class="bar">/</span>
<span class="fdn">I<sub>D</sub> + I<sub>L</sub> &divide; (1 + h<sub>FE</sub>)</span>
</span>
</p>

We know the minimum voltage we'll supply is 10 volts, and our Zener diode will
draw 8.2 volts, leaving 1.8 volts across our resistor for V<sub>R</sub>. We know
our Zener diode provides 8.2 volts when the current through it is 5
milliamperes, so we can use that as the minimum current I<sub>D</sub>. The [data
sheet on the 2N2222 transistor][2n2222] tells us its minimum forward gain is 75,
so we'll plug that in for h<sub>FE</sub>. And our radio consumes 225
milliamperes when transmitting, so that's our maximum load I<sub>L</sub>.
Crunching through those numbers tells us how big our resistor needs to be.

<p class="math">226 ohms &asymp;
<span class="fraction">
<span class="fup">1.8 volts</span>
<span class="bar">/</span>
<span class="fdn">0.005 amps + 0.255 amps &divide; (75 + 1)</span>
</span>
</p>

The 220 ohm resistor in our junk box is close enough.

## Stepping down the voltage ##

Our Zener diode is keeping our voltage regulated at 8.2 volts, and we know
we can pull the 225 milliamperes of current we need through our resistor.
But what do we do about the fact that our mixer doesn't actually need 8.2 volts?
We can step the voltage down from 8.2 volts to 6 volts with a voltage divider.

The simplest voltage divider is two resistors in series. Here's what that looks
like when we wire it into our circuit.

<img class="game art" width="623px" height"312px"
     src="/images/norcal-40a-voltage-regulator-stepped.png"
     alt="The positive terminal of an unregulated 12 volt battery is connected to the collector of a 2N2222 transistor. A reverse-biased 8.2 volt Zener diode is connected to the negative terminal of the battery and the base of the transistor. A 220 ohm resistor is shorted across the base and collector of the transistor. A voltage divider consisting of a 1000 ohm resistor and a 330 ohm resistor in series is place between the emitter of the transistor and the base of the Zener diode. The result is a regulated 6.2 volt source (at the junction of the voltage divider) that can handle a load of at least 225 milliamperes.",
   title="The positive terminal of an unregulated 12 volt battery is connected to the collector of a 2N2222 transistor. A reverse-biased 8.2 volt Zener diode is connected to the negative terminal of the battery and the base of the transistor. A 220 ohm resistor is shorted across the base and collector of the transistor. A voltage divider consisting of a 1000 ohm resistor and a 330 ohm resistor in series is place between the emitter of the transistor and the base of the Zener diode. The result is a regulated 6.2 volt source (at the junction of the voltage divider) that can handle a load of at least 225 milliamperes." />

Given two resistors of the same value, the voltage at the point they join will
be half the input voltage. The formula for output voltage given two arbitrary
resistors is to take the value of the second resistor in ohms and divide it by
the sum of the first resistor's value in ohms plus the second resistor's value
in ohms. Then multiply the result by the input voltage.

<p class="math">V<sub>out</sub> =
<span class="fraction">
<span class="fup">R<sub>2</sub></span>
<span class="bar">/</span>
<span class="fdn">R<sub>1</sub> + R<sub>2</sub></span>
</span> &sdot; V<sub>in</sub>
</p>

We know that our input voltage is 8.2 volts and our output voltage is 6 volts.
Digging through the set of resistors in our junk box, we find that a 330 ohm
resistor and a 1000 ohm resistor will get us close.

<p class="math">6.2 volts &asymp;
<span class="fraction">
<span class="fup">1000 ohms</span>
<span class="bar">/</span>
<span class="fdn">330 ohms + 1000 ohms</span>
</span> &sdot; 8.2 volts
</p>

Our mixer needs at least 4.5 volts and can handle up to 8.5 volts, so driving it
with 6.2 volts isn't a problem. The reason we stepped down the voltage in the
first place, is because our Zener diode can potentially deliver up to 8.7 volts,
which is more than our mixer can handle.

## What we've got so far ##

The image below shows the power circuit in relation to the transmit filter in
the NorCal 40A. I put nuts on the stand offs for the circuit board, since
without them the weight of the on/off switch caused the whole thing to tilt.

<img class="game art" width="640px" height"640px"
     src="/images/norcal-40a-voltage-regulator-overview.jpg"
     alt="An overhead view of the NorCal 40A showing the power supply circuit and transmit filter.",
   title="An overhead view of the NorCal 40A showing the power supply circuit and transmit filter." />

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
[12v]: https://www.adafruit.com/products/875 "Various (Adafruit): 8 x AA battery holder with 5.5mm/2.1mm Plug and On/Off Switch"

[sa602a]: http://www.nxp.com/documents/data_sheet/SA602A.pdf "Various (NXP Semiconductors): SA602A Double-balanced mixer and oscillator - Product data sheet"
[n6qw]: http://www.jessystems.com/How%20To%20Stuff%20A%20Junk%20Box.pdf "Pete Juliano, N6QW: How To Stuff A Junk Box"
[bzx79]: http://www.nxp.com/documents/data_sheet/BZX79.pdf "Various (NXP Semiconductors): BZX79 series voltage regulator diodes - Product data sheet"
[1n5817]: http://www.fairchildsemi.com/ds/1N/1N5819.pdf "Various (Farchild Semiconductor): 1N5817 - 1N5819 Schottky Barrier Rectifier"
[n0gsg]: http://www.arrl.org/files/file/Technology/HandsOnRadio/Thoughts%20on%20Reverse%20Power%20Protection%20using%20Power%20MOSFETs%20-%20Wheeler%20N0GSG.pdf "Tom Wheeler, N0GSG (ARRL): Thoughts on Reverse Power Protection using Power MOSFETs"
[w0ch]: http://www.w0ch.net/nc40a/nc40a.htm "Dave Bixler, W0CH: Wilderness / NorCal 40A"
[78l08]: http://www.st.com/web/en/resource/technical/document/datasheet/CD00000446.pdf "Various (STMicroelectronics): L78L Positive voltage regulators - Product data sheet"
[2n2222]: http://www.onsemi.com/pub_link/Collateral/P2N2222A-D.PDF "Various (ON Semiconductor): P2N2222A - Product data sheet"

[norcal-40a]: /2014/05/norcal-40a "Frank Mitchell: Building my first HF radio"
[transmit-filter]: /2014/05/transmit-filter "Frank Mitchell: Learning how a transmit filter works"
[iPhone 5]: http://support.apple.com/kb/sp655 "Various (Apple): iPhone 5 Technical Specification"
[Acorn]: http://flyingmeat.com/acorn/ "Gus &amp; Kirstin Mueller (Flying Meat): Acorn - The image editor for humans"
[ImageOptim]: http://imageoptim.com/ "@pornel (ImageOptim): Image compression made easy for Mac OS X"
[circuitikz]: http://www.ctan.org/pkg/circuitikz "Massimo Redaelli (CTAN): circuitikz - Draw electrical networks with TikZ"
[D3]: http://d3js.org/ "Mike Bostock (D3): Data-Driven Documents"
