<!--
title: Building the NorCal 40A transmit filter
created: 15 May 2014 - 7:06 pm
updated: 20 May 2014 - 8:58 am
publish: 20 May 2014
slug: transmit-filter
tags: building, radio
-->

The first practical circuit you build in [_The Electronics of Radio_][book] is a
transmit filter. By practical, I mean the kind of circuit you could pull out of
one design and drop into another. Something that fits in a black box. Here's
what the transmit filter in the NorCal 40A looks like.

<img class="game art" width="658px" height"253px"
     src="/images/norcal-40a-transmit-filter.png"
     alt="An input signal (P1) feeds into a 4.7 pF coupling capacitor and then into the output signal (P2). A 100 pF capacitor, variable 50 pF capacitor, and 3.14 uH inductor sit in parallel between the coupling capacitor and ground.",
   title="An input signal (P1) feeds into a 4.7 pF coupling capacitor and then into the output signal (P2). A 100 pF capacitor, variable 50 pF capacitor, and 3.14 uH inductor sit in parallel between the coupling capacitor and ground." />

## What's a filter for? ##

What's the point of a filter in a transmitter anyway? At its most basic, a
transmitter consists of four parts. An antenna to radiate a signal,
an oscillator to generate a signal, a power source to drive the oscillator,
and a key to turn the power on and off.

The frequency the oscillator resonates at determines the frequency the
transmitter broadcasts on. Most oscillators are made of quartz, which provides
nice stable frequencies when you excite it with electrons. The problem with
quartz is that it's so stable, it doesn't give you much tuning range. If your
oscillator is a 7.114 MHz quartz crystal, you're pretty much stuck transmitting
on 7.114 MHz. Some radios, like the [Rockmite II][rm40], are designed to be
"rock bound" and operate on just one frequency.

The crystal oscillator in the NorCal 40A operates at 4.9150 MHz. This is known
as the local oscillator or LO. Since 4.9 MHz isn't in the 40 meter amateur radio
band, we need to mix in a second signal to get things into the 7 MHz range. By
making that second signal tunable, we can allow the radio to transmit over a
range of frequencies.

That second signal comes from the variable frequency oscillator or VFO. The one
in the NorCal 40A operates at 2.105 MHz. It's got a bandwidth of about 40 kHz,
which means you can tune it up or down by 20 kHz on either side. Mixing the LO's
4.9 MHz signal with the VFO's 2.1 MHz signal gives us the variable 7 MHz signal
we want.

Signal mixing is known as hetrodyning, and like most things that sound like they
herald the dawn of Skynet, it has a down side. Not only does mixing signals get
you their product, it gets you their difference as well. So we get the 7 MHz
signal we want, but we also get a 2.8 MHz signal we don't want. And that's where
the transmit filter comes in. Filters are used to remove unwanted signals.

## Making a minimal viable filter ##

You can make the worlds smallest filter by putting a capcitor and an inductor in
parallel. This is known as an LC circuit, or a tuned circuit, and it stores
electrical energy through oscillation.

A capacitor stores energy in an electric field. So if you connect a charged
capacitor across an inductor, current will start to flow from the capacitor
to the inductor and build up a magnetic field in the inductor. But the current
doesn't stop once the charge on the capacitor is gone. Because inductors resist
changes in current, the capacitor will begin to charge back up, extracting
engergy from the magnetic field in the inductor. Back and forth it goes, from
electric field to magnetic field, swapping polarity each time, and forming
an oscillator.

You can calculate the frequency an LC circuit oscillates at if you know the
inducatance in henries and capacitance in farads of the components in it.
Multiply the inductance by the capacitance and take the square root. Multiply
that result by two pi and invert it.

<div class="math">&fnof; =
<div class="fraction">
<span class="fup">1</span>
<span class="bar"></span>
<span class="fdn">2&pi;
  <span class="radical">&radic;</span>
  <span class="radicand">LC</span>
</span>
</div>
</div>

The resulting frequency is in hertz, and it's that tuned circuit's resonant
frequency. Becuase capacitors block high-frequency signals and inductors block
low-frequency signals, a tuned circuit will only let signals at its resonate
frequency through. Filters that behave like this are known as band pass filters.

## Functions in filter land ##

The tuned circuit in the transmit filter of the NorCal 40A has a 100 pF
capacitor, a 50 pF capacitor, and a 3.14 uH inductor. Because the two capacitors
are in parallel, we can sum their values and pretend we're working with a 150 pF
capacitor. By plugging these values into the formula for resonate frequency, we
can figure out where the circuit peaks.

<div class="math">7.33 MHz =
<div class="fraction">
<span class="fup">1</span>
<span class="bar"></span>
<span class="fdn">2&pi;
  <span class="radical">&radic;</span>
  <span class="radicand">(3.14 &times; 10<sup>-6</sup>) &sdot; (150 &times; 10<sup>-12</sup>)</span>
</span>
</div>
</div>

The peak of the filter lands on the edge of the 40 meter band at 7.33 MHz.
That's good because it means the 7 MHz signal generated by the mixer will pass
through the filter. But what about the 2.8 MHz signal we don't want? How well
does this filter remove that unwanted signal? To answer that, we have to look
at the filter's transmission loss.

Transmission loss is the ratio of the voltage that a circuit puts out to the
voltage the circuit takes in. Here's the function to calculate the transmission
loss for an inductor and capacitor in parallel.

<div class="math"><div class="fraction">
<span class="fup">V<sub>out</sub><sup>2</sup></span>
<span class="fdn">V<sub>in</sub><sup>2</sup></span>
</div> = <div class="fraction">
<span class="fup">&omega;<sup>2</sup>L<sup>2</sup></span>
<span class="fdn">R<sup>2</sup>(1 - &omega;<sup>2</sup>LC)<sup>2</sup> + &omega;<sup>2</sup>L<sup>2</sup></span>
</div>
</div>

There are two variables in that function we don't know. One is R, the input
resistance of the filter in ohms. The other is &omega; (pronounced "omega"),
the input frequency to the filter in radians. We can figure out the input
resistance by looking at the circuit's input. The transmit filter in the NorCal
40A is fed by a ???? mixer. Digging through the data sheet for the mixer, we
find that its output resistance is 1500 ohms. Which means the input resistance
to our filter will also be 1500 ohms.

We know what the input frequency to our filter is, it's 2.8 MHz. We can convert
hertz to radians by multiplying by two pi.

<p class="math">12566371 rad = 2&pi; &sdot; 2800000</p>

Now we know enough to figure out how good our filter is at rejecting a 2.8 MHz
signal. We can take the formula for transmission loss and  plug in 1500 ohms for
R, 3.14 &times; 10<sup>-6</sup> henries for L, 150 &times; 10<sup>-12</sup>
farads for C, and 12566371 radians for &omega;.

<p class="math"><span class="fraction">
<span class="fup">12566371<sup>2</sup> &sdot; 3.14e-6<sup>2</sup></span>
<span class="fdn">1500<sup>2</sup> &sdot; (1 - 12566371<sup>2</sup> &sdot; 3.14e-6 &sdot; 150e-12)<sup>2</sup> + 12566371<sup>2</sup> &sdot; 3.14e-6<sup>2</sup></span>
</p>

Note that I'm being a little fast and loose with my notation here. Scientific e
notation is usually reserved for calculators and programming languages, but I
wanted to fit everything on one line.

Crunching through all those numbers, we find our filter has a transmission loss
of 0.0284 volts at 2.8 MHz. Transmission loss is usually expressed in decibals,
which are a logarithmic scale where minus three deciabals corresponds to a loss
of half the voltage. We can convert volts to decibals by taking the base ten
logarithm of the voltage and multiplying by twenty.

<p class="math">-31 dB = 20 &sdot; log<sub>10</sub>(0.0284)</p>

Quality factor is a constant.

<div class="math">Q =
<div class="fraction">
<span class="fup">R</span>
<span class="bar"></span>
<span class="fdn">2&pi;&fnof;L</span>
</div>
</div>

Bandwidth in hertz.

<div class="math">BW =
<div class="fraction">
<span class="fup">&fnof;</span>
<span class="fdn">Q</span>
</div>
</div>

Upper and lower -3dB frequencies.

<div class="math">&fnof;<sub>L</sub> = &fnof; -
<div class="fraction">
<span class="fup">1</span>
<span class="bar"></span>
<span class="fdn">2</span>
</div> BW
</div>

<div class="math">&fnof;<sub>H</sub> = &fnof; +
<div class="fraction">
<span class="fup">1</span>
<span class="bar"></span>
<span class="fdn">2</span>
</div> BW
</div>

Transfer function

<div class="math"><div class="fraction">
<span class="fup">V<sub>out</sub></span>
<span class="fdn">V<sub>in</sub></span>
</div> = <div class="fraction">
<span class="fup">j&omega;L</span>
<span class="fdn">R(1 - &omega;<sup>2</sup>LC) + j&omega;L</span>
</div>
</div>

where j is the imaginary number

<div class="math">j = -
<span class="radical">&radic;</span>
<span class="radicand">-1</span>
</div>

<div class="math"><div class="fraction">
<span class="fup">V<sub>out</sub><sup>2</sup></span>
<span class="fdn">V<sub>in</sub><sup>2</sup></span>
</div> = <div class="fraction">
<span class="fup">&omega;<sup>2</sup>L<sup>2</sup></span>
<span class="fdn">R<sup>2</sup>(1 - &omega;<sup>2</sup>LC)<sup>2</sup> + &omega;<sup>2</sup>L<sup>2</sup></span>
</div>
</div>


[book]: http://cambridge.org/us/academic/subjects/engineering/rf-and-microwave-engineering/electronics-radio "David Rutledge (Cambridge University Press): The Electronics of Radio"
[rm40]: http://www.qrpme.com/?p=product&id=RM4 "Rex Harper, W1REX (QRPme): Rockmite ][ 40m Transceiver"
