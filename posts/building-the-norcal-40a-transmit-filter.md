<!--
title: Building the NorCal 40A transmit filter
created: 15 May 2014 - 7:06 pm
updated: 16 May 2014 - 11:08 pm
publish: 16 May 2014
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

The crystal oscillator in the NorCal 40A operates at 2.1 MHz. This is known as
the local oscillator or LO. Since 2.1 MHz isn't in the 40 meter amateur radio
band, we need to mix in a second signal to get things into the 7 MHz range. By
making that second signal tunable, we can allow the radio to transmit over a
range of frequencies.

That second signal comes from the variable frequency oscillator or VFO. The one
in the NorCal 40A operates at 4.9 MHz. It's got a bandwidth of about 50 kHz,
which means you can tune it up or down by 25 kHz on either side. Mixing the LO's
2.1 MHz signal with the VFO's 4.9 MHz signal gives us the variable 7 MHz signal
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

<div class="math">
<i>f</i> =
<div class="fraction">
<span class="fup">1</span>
<span class="bar"></span>
<span class="fdn">
  2&pi;
  <span class="radical">&radic;</span>
  <span class="radicand">LC</span>
</span>
</div>
</div>

The resulting frequency is in hertz, and it's that tuned circuit's resonant
frequency. Becuase capacitors block high-frequency signals and inductors block
low-frequency signals, a tuned circuit will only let signals at its resonate
frequency through. Filters that behave like this are known as band pass filters.


[book]: http://cambridge.org/us/academic/subjects/engineering/rf-and-microwave-engineering/electronics-radio "David Rutledge (Cambridge University Press): The Electronics of Radio"
[rm40]: http://www.qrpme.com/?p=product&id=RM4 "Rex Harper, W1REX (QRPme): Rockmite ][ 40m Transceiver"
