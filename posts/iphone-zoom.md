<!--
title: Fixing the iPhone zooming bug
date: 29 April 2012
-->

You're on the bus to work, crusing [Pinboard][] on your iPhone for something to
read. A nice juicy tech article comes up. The headline grabs your attention.
There are blocks of code in it. You flip your phone into landscape mode for more
comfortable reading.

"Arrgghh! Why did it zoom?"

At this outburst, the other passengers eye you wearily. You hurredly flip back
to portrait mode, but it's no use. The blocks of code don't fit in 320 pixels.
You sigh and resign yourself to a commute filled with videos of kittens on
YouTube.

You've just been bitten by the [zooming bug][] in Mobile Safari.

## What causes the bug? ##

Websites that want to create a nice mobile user experience will usually
set the [meta viewport tag][]. This tag tells your phone how to scale
the page it's rendering. The orientation bug happens when a site
sets the tag like this:

    <meta  name="viewport"
      content="width=device-width,initial-scale=1">

The `width=device-width` part says to scale the view so that
it's 320 pixels wide. (In portrait mode, the iPhone's device width
is 320 pixels. In landscape mode, it's 480 pixels.) The `initial-scale=1`
part tells your phone to map pixels 1-to-1, so that a one pixel measurement in
<abbr title="Cascading Style Sheets">CSS</abbr> will show up as one rendered
pixel on the screen.

From a design standpoint it's great. You get pixel perfect control and the
maximum possilbe sreen space to play with. But as soon as you set that tag, you
also get the zooming bug.

## How do I fix it? ##

The fix is simple. Drop the `initial-scale=1` part from the meta viewport tag.

    <meta name="viewport"
      content="width=device-width">

There is a bit of a catch. The iPhone won't reset the device width when you
switch from portrait to landscape. Start viewing a website in portrait mode,
flip to landscape, and the the page will render as if you only have 320 pixels
of screen space. You'd expect to have the full 480 pixels available, but that's
not the case.

It's a minor annoyance, but one you only have to deal with once as a designer.
And designing with that limit in mind prevents your users from being subjected
to unexpected bouts of zooming.

Those of us who ride the bus will thank you.

[Pinboard]: http://pinboard.in/t:programming/ "Pinboard: global tag page for programming"
[zooming bug]: http://filamentgroup.com/examples/iosScaleBug/ "Filament Group - iOS bug test page"
[meta viewport tag]: https://developer.mozilla.org/en/Mobile/Viewport_meta_tag "Using the viewport meta tag to control layout on mobile browsers - MDN"
