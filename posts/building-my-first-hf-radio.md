<!--
title: Building my first HF radio
created: 6 May 2014 - 7:15 am
updated: 7 May 2014 - 11:29 pm
publish: 7 May 2014
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

The NorCal 40A was designed by Wayne Burdick, N6KR, for the [Northern California
QRP Club][]. My board is revision C, from 1999. While [the manual][] lists the
differences between the A and B revisions, it doesn't tell me what's different
between the B and C revisions. I'm not going to worry though, since the
component placement drawing in Appendix B shows the same "rev C" text that
appears on my board.

<img class="game art" src="/images/norcal-40a-board-name.jpg"/>

Photos where taken with an [iPhone 5][], cropped with [Acorn][], and compressed
with [ImageOptim][].


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
[Northern California QRP Club]: http://www.norcalqrp.org/ "Various (NorCal QRP Club): Home"
[the manual]: http://ecee.colorado.edu/~ecen2420/Files/NorCal40A_Manual.pdf "Bob Dyer, K6KK &amp; Wayne Burdick, N6KR (Wilderness Radio): NorCal 40A 40-Meter CW Transceiver: Assembly and Operating Manual"
[iPhone 5]: #
[Acorn]: #
[ImageOptim]: http://imageoptim.com/ "@pornel (ImageOptim): Image compression made easy for Mac OS X"
