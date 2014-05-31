<!--
title: Regulating voltage with junk box parts
created: 31 May 2014 - 7:46 am
updated: 31 May 2014 - 9:13 am
publish: 31 May 2014
slug: voltage-regulator
tags: building, radio
-->

<script src="/js/d3.min.js" charset="utf-8"></script>

## Why battery packs are big ##

Suppose we want to power a [Philips SA602A double-balanced mixer and
oscillator][sa602a], like the one found in the NorCal 40A transceiver. Looking
through its data sheet, we see typical operation requires 6 volts of power
and draws 2.4 milliamperes of current. How do we get power that precise?

The obvious solution would be a 6 volt battery. The AA alkaline batteries
I keep sitting around in my cupboard for the XBox controller can supply 1.5
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

Dig through [a good junk box][n6qw] and you can probably pull out a 8.2 volt
Zener diode like the [Philips BZX79-B8V2][bzx79].

## Where we go from here ##

This is the third part in a multi-part series about building the NorCal
40A transceiver. Links to the other parts are below.

1. [Building my first HF radio][norcal-40a]
2. [Learning how a transmit filter works][transmit-filter]
3. Regulating voltage with junk box parts

For the curious, photos where taken with an [iPhone 5][], cropped and resized
with [Acorn][], and compressed with [ImageOptim][]. Schematics where drawn with
[circuitikz][] and graphs where created with [D3][].


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
