<!--
title: Building the NorCal 40A transmit filter
created: 15 May 2014 - 7:06 pm
updated: 16 May 2014 - 6:46 am
publish: 16 May 2014
slug: transmit-filter
tags: building, radio
-->

The first practical circuit you build in [_The Electronics of Radio_][book] is a
transmit filter. By practical, I mean the kind of circuit you could pull out of
one design and drop into another. Something that fits in a black box.

<img class="game art" width="658px" height"253px"
     src="/images/norcal-40a-transmit-filter.png"
     alt=""
     title="" />

What's the point of a filter in a transmitter anyway? At it's most basic, a
transmitter consists of four parts. An antenna to radiate a signal,
an oscillator to generate a signal, a power source to drive the oscillator,
and a key to turn the power on and off.

The frequency the oscillator resonates at determines the frequency being sent.
Most oscillators are made of quartz, which provides nice stable frequencies when
you excite it with electrons. The problem with quartz is that it's so stable,
it doesn't give you much tuning range. If your oscillator is a 7.114 MHz quartz
crystal, you're pretty much stuck transmitting on 7.114 MHz. Some radios, like
the [Rockmite II][rm40], are designed to be "rock bound" and operate on just
one frequency.

The crystal oscillator in the NorCal 40A operates at 2.1 MHz. This is known as
the local oscillator or LO. Since 2.1 MHz isn't in the 40 meter amateur radio
band, we need to mix in a second signal to get things into the 7 MHz range. By
making that second signal tunable, we can allow the radio to transmit over a
range of frequencies.

That second signal comes from the variable frequency oscillator or VFO. THe one
in the NorCal 40A operates at 4.9 MHz. It's got a bandwidth of about 50 kHz,
which means you can tune it up or down by 25 kHz on either side. Mixing the LO's
2.1 MHz signal with the VFO's 4.9 MHz signal gives us the variable 7 MHz signal
we want.

Signal mixing is known as hetrodyning, and like most things that sound like they
herald the dawn of Skynet, it has a down side. Not only does mixing signals get
you their product, it gets you their difference as well. So we get the 7 MHz
signal we want, but we also get a 2.8 MHz signal we don't want. And that's where
the transmit filter comes in. Filters are used to remove unwanted signals.


[book]: http://cambridge.org/us/academic/subjects/engineering/rf-and-microwave-engineering/electronics-radio "David Rutledge (Cambridge University Press): The Electronics of Radio"
[rm40]: http://www.qrpme.com/?p=product&id=RM4 "Rex Harper, W1REX (QRPme): Rockmite ][ 40m Transceiver"
