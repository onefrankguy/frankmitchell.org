<!--
title:  Hit boxes matter on the mobile web
created: 16 September 2013 - 5:35 am
updated: 16 September 2013 - 8:20 am
publish: 17 September 2013
slug: big-boxes
tags: coding, mobile
-->

Mobile development doesn't happen on mobile devices. I wrote
[Hard Vacuum: Recon][] on a [Raspberry Pi][], not the iPhone 5 it was built
to run on. Design, development, and testing took place on the Pi, and it wasn't
until late in the cycle that I actually fired it up on a phone to see how it
felt.

Turns out it felt all wrong.

Hard Vacuum: Recon is a memory game. As you fly over rocks, you scan them by
touch them, which reveals the ice underneath. Match two icicles of the same
size, and your copter gets a little more fuel so you can keep flying. Icicles
come in three sizes, big, medium, and small, but rocks are just one size, small.

<img class="game art" width="320px" height="120px" alt="Icicles from Hard Vacuum: Recon" title="Icicles from Hard Vacuum: Recon" src="/images/hvrecon-icicles.png"/>

My first attempt bound an `onTouchBegin` event handler to the `<img>` tag that
held a rock. The base tile size is 20x20 pixels, so the hit box for the rock was
the same size. On the Pi, this felt just fine. I easily clicked on rocks and
kept my copter flying. But the iPhone was a different story.

Every time I went to touch a rock, it would slip past my fingers. Maybe one in
three touches got through, but it didn't feel fun or fluid. Mash your finger on
a phone screen, and you can see why. On a 320x480 pixel screen, your finger tip
covers a square about 40x40 pixels. Since my hit boxes where a quarter the size
they needed to be, my rock collecting wasn't cutting it.

Bumping the hit box size to 40x40 pixels helped. My hit rate went up. My copter
stayed in the air longer. Yet every once in a while I found myself saying, "Hey,
I touched that. Why didn't it flip?"

Hard Vacuum: Recon is a vertical scroller. Rocks move up the screen as the game
progresses. On a comptuer with a mouse, the delay between click and hit test is
zero. Since the mouse is already over the pixel you're clicking, the vertical
motion isn't an impediment to precision picking.

On a phone, when your finger touches the screen, it's now in the way of your
seeing what's happening. So we tend to keep our fingers back, darting them
forward to tap as needed. The delay between "I want to touch hat" and the actual
finger hitting the phone screen is about 0.25 seconds. Hard Vacuum: Recon
scrolls at 20 pixels per second, turning that quarter second reaction time into
a 5 pixel error. Couple that error with the soft, round, imprecise nature of
fingers and you have touch screen selection disaster.

My solution was to make the hit boxes for rocks 40x60 pixels. Those extra 20
pixels of vertical space account for reaction time and vertical motion. Since
rocks are 20 pixels square, centered in the hit box, you actually get a full
three seconds of time to touch them. Picking the space a rock was in a second
ago, or where it will be a second from now, counts.

P.S. The graphics for Hard Vacuum: Recon came from Daniel Cook's
"[Hard Vacuum][]" art on [lostgarden.com][]. If you're looking for free game
graphics, his work is an excellent choice.


[Hard Vacuum: Recon]: http://js13kgames.com/entries/hard-vacuum-recon "Frank Mitchell (js13kGames): Hard Vacuum: Recon"
[Raspberry Pi]: http://raspberrypi.org/ "Various (Raspberry Pi): An ARM GNU/Linux box for $35"
[Hard Vacuum]: http://lostgarden.com/ "Daniel Cook (Lostgarden):"
[lostgarden.com]: http://lostgarden.com/ "Daniel Cook (Lostgarden):"
