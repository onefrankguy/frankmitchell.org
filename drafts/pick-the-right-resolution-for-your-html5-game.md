<!--
title: Pick the right resolution for your HTML5 game
created: 25 January 2015 - 9:17 am
updated: 8 February 2015 - 11:18 am
publish: 8 February 2015
slug: screen-size
tags: marketing, game
-->

"How big should I make my game?" is one of those questions that comes up a lot
when you're making games for the web. Choosing the right resolution is
important, especially if you're going to render things in `<canvas>` tags.

Usually a game is rendered to a fixed sized canvas and CSS is used to scale it
up or down to match the screen size. But if your initial size is too big text
that looks great on the screen of your twenty-sevn inch iMac becomes unreadable
on an iPhone 4. And if your canvas size is too small graphics that look crisp on
an iPhone 4 become fuzzy blobs on a Galaxy Note Edge.

So how do you pick the right size for your game?

You can always guess. Pick a number and hope you get it right. Or [ask around on
the forums][forum] and see what other people use. The problem with both of those
approaches is that they're subjective. Someone else's process won't necessarily
work for you. They might be looking at a totally different set of users. So
their reasons for choosing the resolution they did might not match up with what
your users want.

It's better to dig up your own data and make your own objective measurements.
Let's say you make mobile HTML5 games. Start with [usage statistics for phones
and tables from November 2014 to January 2015][browser]. When you're gathering
data like this, you want fresh stuff. Limit yourself to the past quarter, maybe
the past year at the most. Anything earlier isn't relevant. The games market
moves quickly.

Below I've grouped the results by vendor. "iPhone" and "Safari" both come under
Apple, since that's who makes those browsers. Likewise the "Android" and
"Chrome" browsers are both made by Google.

<table style="width:100%">
<col style="width:auto">
<col style="width:100%">
<tr><td>Google</td><td><span style="display: inline-block; margin-left: 0.5em; padding-left: 0.5em; background:powderblue; border: 1px solid #000; width:45.82%">45.82%</span></td></tr>
<tr><td>Apple</td><td><span  style="display: inline-block; margin-left: 0.5em; padding-left: 0.5em; background:powderblue; border: 1px solid #000; width:28.64%">28.64%</span></td></tr>
<tr><td>Other</td><td><span  style="display: inline-block; margin-left: 0.5em; padding-left: 0.5em; background:powderblue; border: 1px solid #000; width:25.54%">25.54%</span></td></tr>
</table>

Google's the clear winner here. If you focus your game development on just
devices that run Chrome or Android, you've got almost half the market. Throw in
Apple support and you've got almost three quarters of the market. That's a whole
lot of market share for only having to target two brands.

Your primary target is the Android ecosystem. The next question to ask is, how
big are Android phones?

It turns out the Android market is super fragmented. Every vendor comes up with
their own variations on screen size. The Galaxy S5 has a resolution of 1080
&times; 1920 but the LG G3 boasts slightly higher numbers at 1440 &times; 2560.
Add in brands like HTC One, Nexus, and Moto X, and now you've got a ton of
screen resolutions to support. Fortunately, Android dodges that potential
headache by [only supporting four ranges of screen sizes][screens]: small,
normal, large, and xlarge.

* small screens are at least 320dp &times; 426dp
* normal screens are at least 320dp &times; 470dp
* large screens are at least 480dp &times; 640dp
* xlarge screens are at 720dp &times; 960dp

What's interesting about these measurments is that the small, large, and xlarge
screens all share a common 4:3 aspect ratio. And the normal screen is just a
little taller than the small screen. Ignoring resolution for a minute, if you
design your game with a 4:3 aspect ratio, leaving a little bit of stretchable
vertical room, you can build something that looks good across the entire Android
market.

So the next question then becomes, how fragmented is that market anyway?

<table style="width:100%">
<col style="width:auto">
<col style="width:100%">
<tr><td>other</td><td><span  style="display: inline-block; margin-left: 0.5em; padding-left: 0.5em; background:powderblue; border: 1px solid #000; width:28.53%">28.53%</span></td></tr>
<tr><td>normal</td><td><span style="display: inline-block; margin-left: 0.5em; padding-left: 0.5em; background:powderblue; border: 1px solid #000; width:26.49%">26.49%</span></td></tr>
<tr><td>large</td><td><span  style="display: inline-block; margin-left: 0.5em; padding-left: 0.5em; background:powderblue; border: 1px solid #000; width:24.94%">24.94%</span></td></tr>
<tr><td>xlarge</td><td><span style="display: inline-block; margin-left: 0.5em; padding-left: 0.5em; background:powderblue; border: 1px solid #000; width:17.49%">17.49%</span></td></tr>
<tr><td>small</td><td><span  style="display: inline-block; margin-left: 0.5em; padding-left: 0.5em; background:powderblue; border: 1px solid #000; width:2.57%">2.57%</span></td></tr>
</table>


<!--
small 426
240x320 2.57
total: 2.57

normal 470
320x568 11.94
320x480 7.32
320x534 2.84
800x600 2.58
360x592 1.81
total: 26.49

large 640
360x640 13.86
480x800 6.96
1280x800 1.53
480x854 1.3
375x667 1.29
total: 24.94

x-large 960
768x1024 11.4
720x1280 4.51
540x960 1.58
total: 17.49

other 28.53

http://gs.statcounter.com/#mobile+tablet-resolution-ww-monthly-201410-201412-bar

iPhone 4S (and earlier) has a usable resolution of 320x367
iPhone 5 has a usable resolution of 320x455

640x480 => 4:3
470x320 =>
-->


[forum]: http://www.html5gamedevs.com/topic/1112-what-is-the-best-resolution-for-a-html5-game/ "Various (HTML5 Game Devs): What is the best resolution for a HTML5 game"
[browser]: http://gs.statcounter.com/#mobile+tablet-browser-ww-monthly-201411-201501-bar "StatCounter: Top 9 Mobile & Tablet Browsers from Nov 2014 to Jan 2015"
[screens]: http://developer.android.com/guide/practices/screens_support.html
