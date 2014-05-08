<!--
title: Building my first HF radio
created: 6 May 2014 - 7:15 am
updated: 8 May 2014 - 6:40 am
publish: 8 May 2014
slug: norcal-40a
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

I thought about getting a [Cyclone 40][] from the [Four State QRP Group][], but
asside from [the Yahoo discussion group][yahoo], there's not much documentation
on how that particular radio works. The [K1][] from [Elecraft][] got some
consideration, since it's got great documentation, but the $300 USD price tag
was a bit out of my budget.

When I heard Bob Dyer was stopping production on [Wilderness Radio][] kits, I
decided I didn't want to miss out. So I picked up a NorCal 40A, complete with
all the bells and whistles e.g. a [KC1 Frequency Counter][] and [BuzzNot Noise
Blanker][]. As it turns out, another perk of the NorCal 40A is that there's a
book about it! [_The Electronics of Radio_][book] is a college text book that
walks you through a step-by-step construction and testing process, explaining
how and why each part of the radio works.

Inspired by [Dave Richards's photography][aa7ee], I'm going to document my build
of the NorCal 40A. To kick things off, here's an overview of the bare circuit
board sitting in the lower half of its case.

<img class="game art" src="/images/norcal-40a-board-overview.jpg" width="640px" height="640px"
       alt="Looking down on the NorCal 40A circuit board balanced on stand offs in the bottom half of its case."
     title="Looking down on the NorCal 40A circuit board balanced on stand offs in the bottom half of its case." />

I ended up screwing the stand offs in and balancing the board on them, since I
thought the bare circuit board looked pretty boring by itself. No doubt it'll
get more exciting once I get a few components on it.

<img class="game art" src="/images/norcal-40a-board-size.jpg" width="640px" height="640px"
       alt="Viewing the NorCal 40A from the side with a ruler next to the case."
     title="Viewing the NorCal 40A from the side with a ruler next to the case." />

The case itself is about four and a half inches by four and a half inches.
With a quarter inch of clearance between the bottom of the case and the
board, and a top half that mirrors the bottom one, there's plenty of room for
expansions, add-ons, and experiments.

<img class="game art" src="/images/norcal-40a-board-name.jpg" width="640px" height="640px"
       alt="Zoomed in on the NorCal 40A circuit board showing the text &ldquo;NorCal 40A rev C &copy;1999 N6KR&rdquo;"
     title="Zoomed in on the NorCal 40A circuit board showing the text &ldquo;NorCal 40A rev C &copy;1999 N6KR&rdquo;" />

The NorCal 40A was designed by Wayne Burdick, N6KR, for the [Northern California
QRP Club][]. My board is revision C, from 1999. While [the manual][] lists the
differences between the A and B revisions, it doesn't tell me what's different
between the B and C revisions. I'm not going to worry though, since the
component placement drawing in Appendix B shows the same "rev C" text that
appears on my board.

For the curious, photos where taken with an [iPhone 5][], cropped and resized
with [Acorn][], and compressed with [ImageOptim][]. Dave Richards, AA7EE has
[a nice article][] about taking good pictures of projects.


[Heathkit]: http://heathkit.com/ "Various (Heathkit): We won't let you fail"
[Elmer 101]: http://qsl.net/kf4trd/lessons.htm "KF4TRD (QSL.net): Elmer 101 Lessons"
[builder]: http://zerobeat.net/qrp/authors/buildpart1.html "Doug Hendricks, KI6DS (Zerobeat.net): So You Want To Be A Builder, Huh?"
[SW-40+]: http://smallwonderlabs.com/docs/SW40+_manual.pdf "Dave Benson, K1SWL (Small Wonder Labs): Instruction Manual: The &ldquo;Small Wonder - 40+&rdquo; 40 Meter Superhet Transceiver Kit"
[Small Wonder Labs]: http://smallwonderlabs.com/ "Dave Benson, K1SWL (Small Wonder Labs): Quality kits for the amateur radio enthusiast"
[Wilderness Radio]: http://fix.net/~jparker/wild.html "Bob Dyer, K6KK (Wilderness Radio): Kits aimed specifically at the outdoor QRP enthusiast"
[book]: http://cambridge.org/us/academic/subjects/engineering/rf-and-microwave-engineering/electronics-radio "David Rutledge (Cambridge University Press): The Electronics of Radio"
[Cyclone 40]: http://4sqrp.com/cyclone.php "David Cripe, NM0S (Four State QRP Group): Cyclone 40M Transceiver"
[Four State QRP Group]: http://4sqrp.com/ "Various (Four State QRP Group): Little Radios, Big Fun!"
[yahoo]: https://groups.yahoo.com/neo/groups/cyclone40/info "Various (Yahoo): NM0S Cyclone Transceiver"
[K1]: http://elecraft.com/k1_page.htm "Various (Elecraft): K1 Four Band and Two Band HF Transceiver"
[Elecraft]: http://elecraft.com/ "Various (Elecraft): Hands-On Ham Radio"
[KC1 Frequency Counter]: http://fix.net/~jparker/wilderness/kc1.htm "Bob Dyer, K6KK (Wilderness Radio): KC1 Keyer/Frequency Counter"
[BuzzNot Noise Blanker]: http://fix.net/~jparker/wilderness/buznt.htm "Bob Dyer, K6KK (Wilderness Radio): BuzzNot Noise Blanker"
[aa7ee]: http://aa7ee.wordpress.com/ "Dave Richards, AA7EE: Home"
[Northern California QRP Club]: http://norcalqrp.org/ "Various (NorCal QRP Club): Home"
[the manual]: http://ecee.colorado.edu/~ecen2420/Files/NorCal40A_Manual.pdf "Bob Dyer, K6KK &amp; Wayne Burdick, N6KR (Wilderness Radio): NorCal 40A 40-Meter CW Transceiver: Assembly and Operating Manual"
[iPhone 5]: http://support.apple.com/kb/sp655 "Various (Apple): iPhone 5 Technical Specification"
[Acorn]: http://flyingmeat.com/acorn/ "Gus &amp; Kirstin Mueller (Flying Meat): Acorn - The image editor for humans"
[ImageOptim]: http://imageoptim.com/ "@pornel (ImageOptim): Image compression made easy for Mac OS X"
[a nice article]: http://aa7ee.wordpress.com/2012/06/18/photography-and-air-spaced-variable-capacitors/ "Dave Richards, AA7EE: Photography and Air Speed Variable Capacitors"
