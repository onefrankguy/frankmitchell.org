<!--
title: Pick the right resolution for your HTML5 game
created: 25 January 2015 - 9:17 am
updated: 3 February 2015 - 10:44 pm
publish: 3 February 2015
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
their reasons for choosing the resolution that did might not match up with what
your users want.

It's better to dig up your own data and make your own objective measurements.
Take a look at [the browser breakdown for phones and tables from November 2014
to January 2015][browser]. I've grouped the results by vendor. "iPhone" and
"Safari" both come under Apple, since that's who makes those browsers. Likewise
"Android" and "Chrome" are both made by Google.

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
lot of market share for only having to target two vendors.

small: 426dp x 320dp
normal: 470dp x 320dp
large: 640dp x 480dp
x-large: 960dp x 720dp

http://developer.android.com/guide/practices/screens_support.html

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


[forum]: http://www.html5gamedevs.com/topic/1112-what-is-the-best-resolution-for-a-html5-game/ "Various (HTML5 Game Devs): What is the best resolution for a HTML5 game"
[browser]: http://gs.statcounter.com/#mobile+tablet-browser-ww-monthly-201411-201501-bar "StatCounter: Top 9 Mobile & Tablet Browsers from Nov 2014 to Jan 2015"
