<!--
title:  Sketching out a rogue lite
created: 10 October 2013 - 7:35 am
updated: 11 October 2013 - 6:35 am
publish: 10 October 2013
slug: board-game
tags: coding, design, mobile
-->

Back when I was a kid, we had this great board game called [Master Labryinth][].
Part of what made it great was that it had this set of tiles that let you build
your own maze. They showed a light road on a dark background, and they came in
three shapes: corners, tees, and straight lines. I figured they'd be the sort of
easy to mock up in HTML, so let's give that a shot.

    <div class="tile"></div>

Start with an empty `<div>`. Give it a dark background and round the corners.
Outline it in something that's not quite black too so you can see it. This is
a game board piece after all.

    .tile {
      position: relative;
      display: block;
      width: 32px;
      height: 32px;
      background: #63698c;
      border-left:   2px solid #8c7594;
      border-top:    2px solid #8c7594;
      border-right:  2px solid #29657b;
      border-bottom: 2px solid #29657b;
      border-radius: 3px;
    }

In today's high resolution world, a 32x32 pixel tile is no longer HD. But they
work well enough on a mobile device, where a screen might only be 320 pixels
wide. The example below is rendered at 2x resolution to make it easier to spot
the details. Not that there are any yet.

<div class="art" style="
  position: relative;
  display: block;
  width: 64px;
  height: 64px;
  background: #63698c;
  border-left:   2px solid #8c7594;
  border-top:    2px solid #8c7594;
  border-right:  2px solid #29657b;
  border-bottom: 2px solid #29657b;
  border-radius: 6px"></div>

We'll use the `:before` selector to insert a pseudo element for a vertical road.

    .tile.line.vertical:before {
      position: absolute;
      top: -1px;
      left: 10px;
      display: block;
      width: 10px;
      height: 34px;
      background: #e7cb84;
      border-left:   1px solid #29657b;
      border-right:  1px solid #8c7594;
    }

<div class="art" style="
  position: relative;
  display: block;
  width: 64px;
  height: 64px;
  background: #63698c;
  border-left:   2px solid #8c7594;
  border-top:    2px solid #8c7594;
  border-right:  2px solid #29657b;
  border-bottom: 2px solid #29657b;
  border-radius: 6px
"><div style="
    position: absolute;
    top: -2px;
    left: 20px;
    display: block;
    width: 20px;
    height: 68px;
    background: #e7cb84;
    border-left:   2px solid #29657b;
    border-right:  2px solid #8c7594;
"></div></div>

<div class="art" style="
  position: relative;
  display: block;
  width: 64px;
  height: 64px;
  background: #63698c;
  border-left:   2px solid #8c7594;
  border-top:    2px solid #8c7594;
  border-right:  2px solid #29657b;
  border-bottom: 2px solid #29657b;
  border-radius: 6px
"><div style="
    position: absolute;
    top: 20px;
    left: -2px;
    display: block;
    width: 68px;
    height: 20px;
    background: #e7cb84;
    border-top:    2px solid #29657b;
    border-bottom: 2px solid #8c7594;
"></div><div style="
    position: absolute;
    top: -2px;
    left: 20px;
    display: block;
    width: 20px;
    height: 24px;
    background: #e7cb84;
    border-left:   2px solid #29657b;
    border-right:  2px solid #8c7594;
"></div></div>

