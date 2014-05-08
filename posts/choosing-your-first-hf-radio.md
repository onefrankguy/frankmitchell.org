<!--
title: Building my first HF radio
created: 6 May 2014 - 7:15 am
updated: 7 May 2014 - 10:55 pm
publish: 6 May 2014
slug: first-radio
tags: building, radio
-->

I missed out on the [Heathkit][] heyday, those times in the 1960s and 70s when
building your own HF radio was the defacto way to get on the air. So when
I upgraded to a General class amateur license in January, I decided I wanted to
build my own radio.

Part of my motivaion was to really understand how a radio works, instead of
just turning knobs and pushing buttons on an applicance. Originally, I planned
to follow the suggestions in Doug Hendricks's ["So You Want To Be A Builder,
Huh?"][builder] course and follow along with [Elmer 101][] to build a
[SW-40+][].  But I missed out on the chance to pick one up before [Small Wonder
Labs][] went out of business.

I thought about getting a [Cyclone 40][] from the [Four State QRP Club][], but
asside from [the Yahoo discussion group][yahoo], there's not much documentation
on how that particular radio works. The [K1][] from [Elecraft][] got some
consideration, since it's got great documentation, but the $300 USD price tag
was a bit out of my budget.

When I heard Bob Dyer was stopping production on [Wilderness Radio][] kits, I
decided I didn't want to miss out. So I picked up a NorCal 40A, complete with
all the bells and whistles e.g. a [KC1 Frequency Counter][] and [BuzzNot Noise
Blanker][]. As it turns out, another perk of the NorCal 40A is that there's a
book about it! [The Electronics of Radio][] walks you through construction
step by step, explaining how and why each circuit works.

Inspired by [Dave Richards's photography][aa7ee], I'm going to document my build
of the NorCal 40A. To kick things off, here's an overview of the bare circuit
board sitting in the lower half of its case.

<img class="game art" src="/images/norcal-40a-board-overview.jpg"/>

The case itself is about four and a half inches by four and a half inches.
With ??? inches of clearance between the bottom of the case and the
board, and a top case that mirrors the bottom one, there's plenty of room for
expansions, add-ons, and experiments.

<img class="game art" src="/images/norcal-40a-board-size.jpg"/>
<img class="game art" src="/images/norcal-40a-board-name.jpg"/>

Photos where taken with an [iPhone 5][], cropped with [Acorn][], and compressed
with [ImageOptim][].

<!--
Choosing your first radio is a bit like choosing a cell phone. Some people are
fans of one equipment manufacturer and just want to buy from them. Others have
been operating one particular mode for so long that they wouldn't dream of
switching. Consequently, there are a whole lot of opinions about what makes for
a good first radio.

I really don't know what you should buy as a first radio, but here's a story
about how I picked mine.

## Antenna first, radio second ##

I live on postage stamp sized city lot. It's tiny, like "takes ten minutes to
mow the whole back yard" tiny. Consequently, a big antenna, or anything up on
top of a tower, was out of the question. So my first step was to figure out
how big of an antenna I could put up and what bands that would let me work.

The general formula for dipole antenna length is to take 468 and divde by the
frequency in megahertz. The reult is the antenna's length in feet. Here's a
chart of amateur radio HF bands and their dipole lengths.

<table>
  <tr><td>HF Band</td><td>Dipole Length</td></tr>
  <tr><td>160 meters</td><td>247 feet</td></tr>
  <tr><td>80 meters</td><td>125 feet</td></tr>
  <tr><td>40 meters</td><td>66 feet</td></tr>
  <tr><td>30 meters</td><td>47 feet</td></tr>
  <tr><td>20 meters</td><td>33 feet</td></tr>
  <tr><td>17 meters</td><td>26 feet</td></tr>
  <tr><td>15 meters</td><td>23 feet</td></tr>
  <tr><td>12 meters</td><td>19 feet</td></tr>
  <tr><td>10 meters</td><td>17 feet</td></tr>
</table>

Those lengths where calculated by taking the US band plan, picking the center
spot of the frequency range General class license holders are allowed to operate
in, dividing 468 by that frequency, and rounding up to the nearest foot.

From that chart, it was obvious that I didn't have space for an antenna that
would work the 160 or 80 meter bands. At sixty-six feet, a full size 40 meter
dipole probably wasn't going to fit either. Dipoles are typically mounted
in a straight line horizontally, but you can zigzag them or let the ends
dangle without affecting their radiating pattern too much.

Linear loading and traps are two common ways to shorten dipoles. Lew Gordon,
K4VX has an article in the July 2001 issue of QST called "[A Linear-Loaded
Dipole for 7 MHz][linear-loaded]". In it he describes how to fold a 40 meter
dipole back on itself so it fits in forty-five feet. Martin Meserve, K7MEM has
an article describing [W5VM's "Shorty 40" antenna][shorty-forty], a 40 meter
dipole with a center loading coil that fits in thirty-eight feet.

## Paying attention to propagation patterns ##

Gabriel Sampol maintains a site called [DX Maps][dx-map] that shows where in the
world amateur radio operators are communicating in real time. You can break it
down by band and get a good feel for when a particular band is active for your
location.

<table>
  <tr><td>HF Band</td><td>Morning Propagation</td><td>Evening Propagation</td></tr>
  <tr><td>40 meters</td><td>US, Europe, Asia</td><td></td></tr>
  <tr><td>30 meters</td><td>US, South America, Australia</td><td></td></tr>
  <tr><td>20 meters</td><td>Europe, South America, Australia</td><td></td></tr>
  <tr><td>17 meters</td><td>Europe, South America</td><td></td></tr>
  <tr><td>15 meters</td><td>Europe</td><td></td></tr>
  <tr><td>12 meters</td><td>N/A</td><td></td></tr>
  <tr><td>10 meters</td><td>N/A</td><td></td></tr>
</table>
-->


[Heathkit]: http://heathkit.com/ "Various (Heathkit): We won't let you fail"
[Elmer 101]: http://www.qsl.net/kf4trd/lessons.htm "KF4TRD (QSL.net): Elmer 101 Lessons"
[builder]: http://www.zerobeat.net/qrp/authors/buildpart1.html "Doug Hendricks, KI6DS (Zerobeat.net): So You Want To Be A Builder, Huh?"
[SW-40+]: #
[Small Wonder Labs]: http://smallwonderlabs.com/ "Dave Benson, K1SWL (Small Wonder Labs): Quality kits for the amateur radio enthusiast"
[Wilderness Radio]: http://www.fix.net/~jparker/wild.html "Bob Dyer, K6KK (Wilderness Radio): Kits aimed specifically at the outdoor QRP enthusiast"
[The Electronics of Radio]: http://www.cambridge.org/us/academic/subjects/engineering/rf-and-microwave-engineering/electronics-radio "David Rutledge (Cambridge University Press): The Electronics of Radio"
[Cyclone 40]: #
[Four State QRP Club]: #
[yahoo]: #
[K1]: #
[Elecraft]: #
[KC1 Frequency Counter]: #
[BuzzNot Noise Blanker]: #
[aa7ee]: http://aa7ee.wordpress.com/ "Dave Richards, AA7EE: Home"
[iPhone 5]: #
[Acorn]: #
[ImageOptim]: http://imageoptim.com/ "@pornel (ImageOptim): Image compression made easy for Mac OS X"

[linear-loaded]: http://www.af2cw.com/license/dipole.pdf "Lew Gordon, K4VX (af2cw.com): A Linear-Loaded Dipole for 7 MHz"
[shorty-forty]: http://www.k7mem.com/Electronic_Notebook/antennas/shorty_40.html "Martin Meserve, K7MEM (k7mem.com): W5VM's Shorty 40 Antenna"
[dx-map]: http://www.dxmaps.com/spots/ "Gabriel Sampol (DX Maps): QSO real time maps"
[dx-map-40]: http://www.dxmaps.com/spots/map.php?Lan=E&Frec=7&ML=M&Map=W2LN&DXC=N&HF=S&GL=N "Gabriel Sampol (DX Maps): QSO real time map of 40 meters"

