<!--
title:  Smoothly scrolling a vertical shooter with JavaScript
created: 24 September 2013 - 5:59 am
updated: 5 October 2013 - 6:49 am
publish: 28 September 2013
slug: scroll-js
tags: coding, mobile
-->

[Hard Vacuum: Recon][] is a vertical shooter without the shooting. To pull off
the illusion of flight, I move the world as the player flys over it. Getting
that animation running smoothly, while allowing the world to form dynamically,
is tricky. Here's how it works.

## Build a better tomorrow, today ##

Start with a simple scene, canvas wrapped in a viewport. To keep our game
playable on as many devices as possible, we'll be using DOM sprites instead of
the `<canvas>` tag.

    <div class="viewport">
      <div class="canvas"></div>
    </div>

Remember to put the closing tag for the canvas element right up against its
opening tag. White space e.g. new lines, carriage returns, tabs, and spaces,
will cause a TEXT node to show up inside that `<div>` in the DOM. When we're
looping over DOM sprites, having to skip TEXT nodes is annoying. Best just to
prevent them showing up in the first place.

We're targeting an old iPhone 4, so we'll use CSS to size the viewport at
320x356 pixels. That's the visible area in Safari on iOS, when the app's not
pinned to the home screen.

    .viewport {
      position: relative;
      display: block;
      width: 320px;
      height: 356px;
      overflow: hidden;
    }

Setting the overflow property to "hidden" means we can size our canvas larger
than our viewport and draw sprites on the non-visible areas. We'll use this to
stage sprites before they're needed and smoothly scroll them in an out of view.

    .canvas {
      position: absolute;
      top: 0;
      left: 0;
      display: block;
      width: 100%;
      height: 100%;
      background: #ef4d94;
    }

Finally, we'll position our canvas inside our viewport, and give it dark pink
background. It's easier to spot misaligned textures if keep your background
color set to something that's not in your sprite pallete.

<div class="game art" style="position: relative; display: block; width: 320px; height: 356px; overflow: hidden">
<div style="position: absolute; top: 0; left: 0; display: block; width: 100%; height: 100%; background: #ef4d94"></div>
</div>

The stage is set. Time for the sprites to enter.

## Plant fields of green ##

We're going to take a na&iuml;ve approach to start, just to get something
on the screen. We'll use a 32x32 tile set, and put a `<div>` in the DOM for
every row of tiles in the game. We'll use CSS to handle styling and semantics,
and JavaScript to handle creation and positioning.

    .row {
      display: block;
      width: 100%;
      height: 32px;
    }

    .grass {
      background: url(grass.png);
    }

Keeping the base shape of a row separate from the image that fills it makes
it easy to add other tile types later. If we where building this out as a normal
web page, we'd probably define "position", "left" and "top" properties for our
tiles as well. But by limiting ourselves to just keeping the look of a tile in
CSS, we can freely experiment with different DOM layouts in JavaScript.

    var tileWidth = 32
      , tileHeight = 32
      , canvasWidth = 320
      , canvasHeight = 356
      , numCols = Math.ceil(canvasWidth / tileWidth)
      , numRows = Math.ceil(canvasHeight / tileHeight)

Feel free to abuse global variables for constants like canvas and tile size.
The goal here is to get something working. Note that we round up when
calculating the number of rows and columns. This prevents gaps at the edges
of the viewport.

    funciton setup () {
      var canvas = document.querySelector('.canvas')
        , sprite = null
        , y = 0

      for (y = 0; y < numRows + 1; y += 1) {
        sprite = document.createElement('div')
        sprite.className = 'row grass'
        canvas.appendChild(sprite)
      }
    }

We use the [`document.createElement()`][ce] function to generate new rows,
and the [`Node.appendChild()`][ac] function to add them to the canvas.

Notice that we're creating one more row than we need to cover the canvas.
Because the viewport's overflow attribute is set to "hidden", this extra row
will be invisible. As the rows scroll up, it will come into view.

We don't need to bother setting position attriubtes on the rows. Because they
have "block" display attributes, they'll naturally stack up on on top of each
other.

Here's what it looks like.

<div class="game art" style="position: relative; display: block; width: 320px; height: 356px; overflow: hidden">
<div id="no-scroll" style="position: relative; display: block; width: 100%; height: 100%; background: #ef4d94"></div>
</div>

Now let's see if we can get our world scrolling.

## Make it dance and move ##

In keeping with the "get something working" theme, we'll use the
[`window.requestAnimationFrmae()`][raf] function to add a render loop. Because
it's not supported by every browser yet, we have to include a [polyfill][] to
make it work. First we'll check for vendor specific prefixes.

    var ext = ['webkit', 'moz', 'ms', 'o']
      , i = 0

    for (i = 0; i < ext.length; i += 1) {
      if (window.requestAnimationFrame) {
        break
      }

      window.requestAnimationFrame = (
        window[ext[i] + 'RequestAnimationFrame']
      )

      window.cancelAnimationFrame = (
        window[ext[i] + 'CancelAnimationFrame'] ||
        window[ext[i] + 'CancelRequestAnimationFrame']
      )
    }

If we don't find a vendor specific prefix, we can fall back to using
the [`window.setTimeout()`][st] and [`window.clearTimeout()`][ct] functions.

    var last = 0

    window.requestAnimationFrame = function (callback) {
      var now = Date.now()
        , later = Math.max(last + 16, now)
      return setTimeout(function () {
        callback(last = later)
      }, later - now)
    }

    window.cancelAnimationFrame = clearTimeout

Once that's in, we can set up our render loop with a callback. We want the world
to scroll up, so we'll move the top of each tile by a negative amount. Once a
tile goes out of the viewport, we'll warp it back down to the bottom.

    var scrollSpeed = -20

    function render () {
      requestAnimationFrame(render)

      var canvas = document.querySelector('.canvas')
        , tiles = canvas.childNodes
        , top = 0
        , i = 0

      for (i = 0; i < tiles.length; i += 1) {
        top = parseFloat(tiles[i].style.top, 10)
        if (top < 0) {
          top = canvasHeight - tileHeight
        }
        top += scrollSpeed
        tiles[i].style.top = top + 'px'
      }
    }

    requestAnimationFrame(render)

We kick off our render loop with a call to `requestAnimationFrame`. This ensures
our first repaint lines up with the browser's rendering. From then on, each time
our `render` function's triggered, it calls `requestAnimationFrame` to schedule
itself again.

Push the play button to see it in action.

<div class="game art" style="position: relative; display: block; width: 320px; height: 356px; overflow: hidden">
<div id="pixel-scroll" style="position: absolute; top: 0; left: 0; display: block; width: 100%; height: 100%; background: #ef4d94"></div>
<div style="position: absolute; right: 0; top: 0; display: block; width: 100%; text-align: right; margin: 0; line-height: 1" class="icon-small icon-square"><span id="pixel-scroll-fps">0</span> FPS</div>
<div id="pixel-scroll-play" style="position: absolute; top: 0; left: 0" class="icon icon-small icon-square"><div class="icon-play"></div></div>
</div>

Wow, the's slow. I get 6 FPS on my [Raspberry Pi][], and giant pink stripes show
up between rows of tiles. Let's see what we can do to fix that.

## Timing is everything ##

Right now, our world is moving 20 pixels with every call to our render function.
But what we want is for it to move 20 pixels every second. Fortunately,
`requestAnimationFrame` comes to our rescue.

When `requestAnimationFrame` triggers our render function, it passes in a time
stamp indicating when the repaint will happen. If we subtract that current time
stamp from the last time stamp, we can figure out how much time has passed
between repaints. Let's set up a timer class to handle that.

    function Timer () {
      this.elapsed = 0
      this.last = null
    }

    Timer.prototype = {
      tick: function (now) {
        this.elapsed = (now - (this.last || now)) / 1000
        this.last = now
      }
    }

We set the elapsed time to `now - (last || now)` so that the first time we call
`Timer.tick()` the elapsed time is zero. And we divide by a thousand so that our
elapsed time is measured in seconds. Feel free to skip the division if you find
milliseconds easier to deal with.

Now we can set up a new timer for our render loop. Here's our render function
from before with new lines underlined.

<pre><code>
var scrollSpeed = -20
  <ins>, timer = new Timer()</ins>

function render (now) {
  requestAnimationFrame(render)
  <ins>timer.tick(now)</ins>

  var canvas = document.querySelector('.canvas')
    , tiles = canvas.childNodes
    , top = 0
    , i = 0
    <ins>, offset = scrollSpeed * timer.elapsed</ins>

  for (i = 0; i < tiles.length; i += 1) {
    top = parseFloat(tiles[i].style.top, 10)
    if (top < 0) {
      top = canvasHeight - tileHeight
    }
    <ins>top += offset</ins>
    tiles[i].style.top = top + 'px'
  }
}
</code></pre>

Instead of subtracting 20 pixels from each tile's top position, we're
subtracting our scroll speed multiplied by our elapsed time. That gives
us the amount to move our tile so that it scrolls at 20 pixels per second.

<div class="game art" style="position: relative; display: block; width: 320px; height: 356px; overflow: hidden">
<div id="delta-scroll" style="position: absolute; top: 0; left: 0; display: block; width: 100%; height: 100%; background: #ef4d94"></div>
<div style="position: absolute; right: 0; top: 0; display: block; width: 100%; text-align: right; margin: 0; line-height: 1" class="icon-small icon-square"><span id="delta-scroll-fps">0</span> FPS</div>
<div id="delta-scroll-play" style="position: absolute; top: 0; left: 0" class="icon icon-small icon-square"><div class="icon-play"></div></div>
</div>

It's still slow on my Pi at 6 FPS, but the pink lines are thinner. There's an
occasional fat one, but most seem to only be one pixel tall. Since 6 FPS is
unplayable for a game, we'll tackle the speed issue first, and then worry about
pixel bleed.

## Trimming back the DOM ##

A 320x352 pixel game with 32x32 pixel tiles has 10 columns and 12 rows. That's
120 tiles that have to move each frame. As David Rousset points out in his
[sprite benchmark][], once you go past about 43 moving sprites on screen,
performance starts to suffer.

Because our background for each row is just repeated grass, we can create a
single `<div>` per row and just move the rows. Twelve images for a background
is well under a forty-three sprite budget. We'll need a little bit of CSS to
to set the shape of a row.

    .row {
      display: block;
      width: 320px;
      height: 32px;
    }

But can keep the render code the same and just change the setup.

<pre><code>
funciton setup () {
  var y = 0
  <del>, x = 0</del>
  , sprite = null
  , canvas = document.querySelector('.canvas')

  <del>for (x = 0; x < numCols; x += 1) {</del>
    for (y = 0; y < numRows; y += 1) {
      sprite = document.createElement('div')
      <del>sprite.className = 'tile grass'</del>
      <ins>sprite.className = 'row grass'</ins>

      sprite.style.position = 'absolute'
      sprite.style.top = (y * tileHeight) + 'px'
      <del>sprite.style.left = (x * tileWidth) + 'px'</del>
      <ins>sprite.style.left = 0 + 'px'</ins>

      canvas.appendChild(sprite)
    }
  <del>}</del>
}
</code></pre>

Hit the play button below if you want to see row scrolling in action.

<div class="game art" style="position: relative; display: block; width: 320px; height: 356px; overflow: hidden">
<div id="row-scroll" style="position: absolute; top: 0; left: 0; display: block; width: 100%; height: 100%; background: #ef4d94"></div>
<div style="position: absolute; right: 0; top: 0; display: block; width: 100%; text-align: right; margin: 0; line-height: 1" class="icon-small icon-square"><span id="row-scroll-fps">0</span> FPS</div>
<div id="row-scroll-play" style="position: absolute; top: 0; left: 0" class="icon icon-small icon-square"><div class="icon-play"></div></div>
</div>

The good news is that the framerate's gone up and the little one pixel lines
of background bleed through lines have disappeared. I get around 13 FPS on my
Pi, which is just insde the realm of playable.

A fat pink line shows up every time a top row is moved back to the bottom.
Let's see what we can do about that.

## Learning from the masters ##

In the book _Masters of DOOM_, David Kushner describes a trick Jon Carmack used
to get side scrolling working on the PC. Draw an extra row of tiles off the
screen at the edge of the world, then move them into view as the player moves
in that direction.

We can do something similar to get rid of background bleed through in our world.
First, we'll change setup so it draws an extra row.

<pre><code>
funciton setup () {
  var y = 0
  , sprite = null
  , canvas = document.querySelector('.canvas')

  <del>for (y = 0; y < numRows; y += 1) {</del>
  <ins>for (y = 0; y < numRows + 1; y += 1) {</ins>
    sprite = document.createElement('div')
    sprite.className = 'row grass'

    sprite.style.position = 'absolute'
    sprite.style.top = (y * tileHeight) + 'px'
    sprite.style.left = 0 + 'px'

    canvas.appendChild(sprite)
  }
}
</code></pre>

Because rows are positioned relative to the canvas, and 0 marks the top edge, w
end up with an extra row off screen. The "hidden" value we set earlier on the
viewport's overflow attribute ensures the extra row won't show up.

Next, we'll change render to offset the row correctly.

<pre><code>
var scrollSpeed = -20
  , timer = new Timer()

function render (now) {
  requestAnimationFrame(render)
  timer.tick(now)

  var canvas = document.querySelector('.canvas')
    , tiles = canvas.childNodes
    , top = 0
    , i = 0
    , offset = scrollSpeed * timer.elapsed

  for (i = 0; i < tiles.length; i += 1) {
    top = parseFloat(tiles[i].style.top, 10)
    <ins>top += offset</ins>
    <del>if (top < 0) {</del>
    <ins>if (top < -tileHeight) {</ins>
      <del>top = canvasHeight - tileHeight</del>
      <ins>top = canvasHeight + offset</ins>
    }
    <del>top += offset</del>
    tiles[i].style.top = top + 'px'
  }
}
</code></pre>

Press the play button below to see the new scrolling in action.

<div class="game art" style="position: relative; display: block; width: 320px; height: 356px; overflow: hidden">
<div id="extra-row-scroll" style="position: absolute; top: 0; left: 0; display: block; width: 100%; height: 100%; background: #ef4d94"></div>
<div style="position: absolute; right: 0; top: 0; display: block; width: 100%; text-align: right; margin: 0; line-height: 1" class="icon-small icon-square"><span id="extra-row-scroll-fps">0</span> FPS</div>
<div id="extra-row-scroll-play" style="position: absolute; top: 0; left: 0" class="icon icon-small icon-square"><div class="icon-play"></div></div>
</div>

The frame rate stays the same and the big pink line is gone. But every once in
a while, a thin one pixel line bleeds through.

## Give me a lever long enough ##

Look at our render function, and you'll notice we've been using `parseFloat` to
extract the top attriubte for each row. This meas rows are being placed with
subpixel precision. Instead of snapping to exact coordinations, like 160 pixels,
thye'll land on floating point coordinates like 159.9999999999954 pixels. Those
tiny differences in value are what's causiing the think pink lines to appear.

Let's back up for a second and look at what we're tyring to accomplish. We want
to scroll our game at 20 pixels per second. Our rows line up correctly when
they're not moving, but render with subpixel errors when they are moving. So
what if we didn't move the rows? What if we moved the world instead?

Let's change our render to move the canvas instead of the tiles.

<pre><code>var scrollSpeed = -20
  , timer = new Timer()

function render (now) {
  requestAnimationFrame(render)
  timer.tick(now)

  <del>var canvas = document.querySelector('.canvas')</del>
  <ins>var canvas = document.querySelector('.viewport')</ins>
    , tiles = canvas.childNodes
    , top = 0
    , i = 0
    , offset = scrollSpeed * timer.elapsed

  for (i = 0; i < tiles.length; i += 1) {
    top = parseFloat(tiles[i].style.top, 10)
    top += offset
    if (top < -tileHeight) {
      <del>top = canvasHeight + offset</del>
      <ins>top = offset</ins>
    }
    tiles[i].style.top = top + 'px'
  }
}</code></pre>

Press the play button and watch the world scroll.

<div class="game art" style="position: relative; display: block; width: 320px; height: 356px; overflow: hidden">
<div id="world-scroll" style="position: absolute; top: 0; left: 0; display: block; width: 100%; height: 100%; background: #ef4d94"></div>
<div style="position: absolute; right: 0; top: 0; display: block; width: 100%; text-align: right; margin: 0; line-height: 1" class="icon-small icon-square"><span id="world-scroll-fps">0</span> FPS</div>
<div id="world-scroll-play" style="position: absolute; top: 0; left: 0" class="icon icon-small icon-square"><div class="icon-play"></div></div>
</div>

## Credits ##

Graphics for the grass come from a sprite set by [Urbansquall][]. They where
posted to the Game Poetry blog back in 2009, and I've kept them around on my
hard drive since, waiting for a project. Guess this tutorial is it.


<script type="text/javascript">
;(function () {
"use strict";

var ext = ['webkit', 'moz', 'ms', 'o']
  , last = 0
  , i = 0

for (i = 0; i < ext.length; i += 1) {
  if (window.requestAnimationFrame) {
    break
  }

  window.requestAnimationFrame = (
    window[ext[i] + 'RequestAnimationFrame']
  )

  window.cancelAnimationFrame = (
    window[ext[i] + 'CancelAnimationFrame'] ||
    window[ext[i] + 'CancelRequestAnimationFrame']
  )
}

if (!window.requestAnimationFrame || !window.cancelAnimationFrame) {
  window.requestAnimationFrame = function (callback) {
    var now = Date.now()
      , later = Math.max(last + 16, now)
    return setTimeout(function () {
      callback(last = later)
    }, later - now)
  }

  window.cancelAnimationFrame = clearTimeout
}
})()

function Timer () {
  this.reset()
}
Timer.prototype = {
  tick: function (now) {
    this.delta = (now - (this.then || now)) / 1000
    this.then = now
  }
, reset: function () {
    this.delta = 0
    this.then = null
  }
}

function Game (callback, fps) {
  this.timer = new Timer()
  this.callback = callback
  this.raf = null
  this.fps = fps
  this.last = 0
}
Game.prototype = {
  render: function (time) {
    this.play()
    this.timer.tick(time)
    if (this.timer.then - this.last > 1000) {
      this.last = this.timer.then
      this.fps.innerHTML = Math.round(1 / this.timer.delta)
    }
    this.callback(this.timer.delta)
  }
  , play: function () {
    var self = this
    this.raf = requestAnimationFrame(function (time) {
      self.render(time)
    })
  }
  , stop: function () {
    cancelAnimationFrame(this.raf)
    this.timer.reset()
    this.fps.innerHTML = 0
  }
}

function addTouch (element, touchStart, touchEnd) {
  element.onmousedown = function (event) {
    if (touchStart) {
      touchStart(event)
    }
    document.onmousemove = function (event) {
      event.preventDefault()
    }
    document.onmouseup = function (event) {
      if (touchEnd) {
        touchEnd(event)
      }
      document.onmousemove = null
      document.onmouseup = null
    }
  }
  element.ontouchstart = function (event) {
    element.onmousedown = null
    if (touchStart) {
      touchStart(event)
    }
    document.ontouchmove = function (event) {
      event.preventDefault()
    }
    document.ontouchend = function (event) {
      if (touchEnd) {
        touchEnd(event)
      }
      document.ontouchmove = null
      document.ontouchend = null
    }
  }
}

var canvasHeight = 356
  , canvasWidth = 320
  , tileHeight = 32
  , tileWidth = 32
  , scrollSpeed = -20

function getTop (element) {
  return parseFloat(element.getAttribute('data-top'), 10)
}

function setTop (element, value) {
  element.setAttribute('data-top', value)
  element.style.top = ((value + 0.5) | 0) + 'px'
}

function moveUp (element, offset, delta) {
  var top = getTop(element) + delta
  if (top <= -tileHeight) {
    top = offset + delta
  }
  setTop(element, top)
}

function pixelScrollRender () {
  var tiles = document.getElementById('pixel-scroll').childNodes
    , top = 0
    , i = 0

  for (i = 0; i < tiles.length; i += 1) {
    top = parseFloat(tiles[i].style.top, 10)
    if (top < 0) {
      top = canvasHeight + tileHeight
    }
    top += scrollSpeed
    tiles[i].style.top = top + 'px'
  }
}

function deltaScrollRender (dt) {
  var tiles = document.getElementById('delta-scroll').childNodes
    , top = 0
    , i = 0
    , offset = scrollSpeed * dt

  for (i = 0; i < tiles.length; i += 1) {
    top = parseFloat(tiles[i].style.top, 10)
    if (top < 0) {
      top = canvasHeight + tileHeight
    }
    top += offset
    tiles[i].style.top = top + 'px'
  }
}

function rowScrollRender (dt) {
  var tiles = document.getElementById('row-scroll').childNodes
    , top = 0
    , i = 0
    , offset = scrollSpeed * dt

  for (i = 0; i < tiles.length; i += 1) {
    top = parseFloat(tiles[i].style.top, 10)
    if (top < 0) {
      top = canvasHeight + tileHeight
    }
    top += offset
    tiles[i].style.top = top + 'px'
  }
}

function extraRowScrollRender (dt) {
  var tiles = document.getElementById('extra-row-scroll').childNodes
    , top = 0
    , i = 0
    , offset = scrollSpeed * dt

  for (i = 0; i < tiles.length; i += 1) {
    top = parseFloat(tiles[i].style.top, 10) + offset
    if (top <= -tileHeight) {
      top = canvasHeight + offset
    }
    tiles[i].style.top = top + 'px'
  }
}

function worldScrollRender (dt) {
  var world = document.getElementById('world-scroll')
    , top = 0
    , offset = scrollSpeed * dt

  top = parseFloat(world.style.top, 10) + offset
  if (top <= -tileHeight) {
    top = offset
  }
  world.style.top = top + 'px'
}

function rowSetup (id, rows) {
  var canvas = document.getElementById(id)
    , sprite = null
    , y = 0

  for (y = 0; y < rows; y += 1) {
    sprite = document.createElement('div')
    sprite.style.background = 'url(/images/urbansquall-grass.png)'
    sprite.style.display = 'block'
    sprite.style.width = '100%'
    sprite.style.height = tileHeight + 'px'
    canvas.appendChild(sprite)
  }
}

function tileSetup (id, rows, cols) {
  var canvas = document.getElementById(id)
    , tile = null
    , x = 0
    , y = 0

  canvas.style.height = canvasHeight + 'px'
  canvas.style.width = canvasWidth + 'px'

  for (x = 0; x < cols; x += 1) {
    for (y = 0; y < rows; y += 1) {
      tile = document.createElement('div')
      tile.style.background = 'url(/images/urbansquall-grass.png)'
      tile.style.position = 'absolute'
      tile.style.left = (x * tileWidth) + 'px'
      tile.style.height = tileHeight + 'px'
      tile.style.width = tileWidth + 'px'
      setTop(tile, y * tileHeight)
      canvas.appendChild(tile)
    }
  }
}

function demoSetup (id, render) {
  var play = document.getElementById(id + '-play')
    , fps = document.getElementById(id + '-fps')
    , game = new Game(render, fps)

  addTouch(play, function () {
    var icon = play.childNodes[0]
    if (icon.className === 'icon-play') {
      game.play()
      icon.className = 'icon-stop'
    }
    else {
      game.stop()
      icon.className = 'icon-play'
    }
  }, null)
}

function noScrollSetup () {
  var rows = Math.ceil(canvasHeight / tileHeight) + 1
  rowSetup('no-scroll', rows)
}

function pixelScrollSetup () {
  var rows = canvasHeight / tileHeight
    , cols = canvasWidth / tileWidth

  tileSetup('pixel-scroll', rows, cols)
  demoSetup('pixel-scroll', pixelScrollRender)
}

function deltaScrollSetup () {
  var rows = canvasHeight / tileHeight
    , cols = canvasWidth / tileWidth

  tileSetup('delta-scroll', rows, cols)
  demoSetup('delta-scroll', deltaScrollRender)
}

function rowScrollSetup () {
  var rows = canvasHeight / tileHeight
    , i = 0

  tileSetup('row-scroll', rows, 1)
  demoSetup('row-scroll', rowScrollRender)

  rows = document.getElementById('row-scroll').childNodes
  for (i = 0; i < rows.length; i += 1) {
    rows[i].style.width = canvasWidth + 'px'
    rows[i].style.left = '0px'
  }
}

function extraRowScrollSetup () {
  var rows = (canvasHeight / tileHeight) + 1
    , i = 0

  tileSetup('extra-row-scroll', rows, 1)
  demoSetup('extra-row-scroll', extraRowScrollRender)

  rows = document.getElementById('extra-row-scroll').childNodes
  for (i = 0; i < rows.length; i += 1) {
    rows[i].style.width = canvasWidth + 'px'
    rows[i].style.left = '0px'
  }
}

function worldScrollSetup () {
  var rows = (canvasHeight / tileHeight) + 1
    , i = 0

  tileSetup('world-scroll', rows, 1)
  demoSetup('world-scroll', worldScrollRender)

  rows = document.getElementById('world-scroll').childNodes
  for (i = 0; i < rows.length; i += 1) {
    rows[i].style.width = canvasWidth + 'px'
    rows[i].style.left = '0px'
  }
}

noScrollSetup()
pixelScrollSetup()
deltaScrollSetup()
rowScrollSetup()
extraRowScrollSetup()
worldScrollSetup()
</script>


[Hard Vacuum: Recon]: /hvrecon "Frank Mitchell (js13kGames): Hard Vacuum: Recon"
[ce]: https://developer.mozilla.org/en-US/docs/Web/API/document.createElement "Various (Mozilla Developer Network): document.createElement()"
[ac]: https://developer.mozilla.org/en-US/docs/Web/API/Node.appendChild "Various (Mozilla Developer Network): Node.appendChild()"
[raf]: https://developer.mozilla.org/en-US/docs/Web/API/window.requestAnimationFrame "Various (Mozilla Developer Network): Window.requestAnimationFrame()"
[polyfill]: https://github.com/darius/requestAnimationFrame "Darius Bacon (GitHub): requestAnimationFrame"
[sprite benchmark]: http://sitepoint.com/html5-gaming-benchmarking-sprite-animations "David Rousset (sitepoint): HTML5 Gaming: Benchmarking Sprite Animations"
[Raspberry Pi]: http://raspberrypi.org/ "A ARM Linux computer for $35 USD"
[Urbansquall]: http://kongregate.com/ "Urbansquall (Kongregate Games): A lovely web game company that is no more"
