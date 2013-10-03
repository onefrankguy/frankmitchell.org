<!--
title:  Smoothly scrolling a vertical shooter with JavaScript
created: 24 September 2013 - 5:59 am
updated: 3 October 2013 - 6:50 am
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
every tile in the game. We'll use CSS to handle styling and semantics, and
JavaScript to handle creation and positioning.

    .tile {
      display: block;
      width: 32px;
      height: 32px;
    }

    .grass {
      background: url(grass.png);
    }

Keeping the base shape of a tile separate from the image that fills it makes
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

We'll use the [`document.createElement()`][ce] function to generate new tiles,
and the [`node.appendChild()`][ac] function to add them to the canvas.

    funciton setup () {
      var x = 0
        , y = 0
        , tile = null
        , canvas = document.querySelector('.canvas')

      for (x = 0; x < numCols; x += 1) {
        for (y = 0; y < numRows ; y += 1) {
          tile = document.createElement('div')
          tile.className = 'tile grass'

          tile.style.position = 'absolute'
          tile.style.top = (y * tileHeight) + 'px'
          tile.style.left = (x * tileWidth) + 'px'

          canvas.appendChild(tile)
        }
      }
    }

We're setting the position attribute to "absolute" on the tiles so we can scroll
them later by adjusting their top attribute. A tile's starting top position is
the row it's in multiplied by the tile height. Likewise, it's starting left
position is the column it's in multipled by the tile width.

Here's what it looks like.

<div class="game art" style="position: relative; display: block; width: 320px; height: 356px; overflow: hidden">
<div id="naive-no-scroll" style="position: absolute; top: 0; left: 0; display: block; width: 100%; height: 100%; background: #ef4d94"></div>
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
        top = parseInt(tiles[i].style.top, 10)
        top += scrollSpeed
        if (top < 0) {
          top = canvasHeight - tileHeight
        }
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
from before with changed lines marked in bold.

    var scrollSpeed = -20
    <strong>, timer = new Timer()</strong>

    function render (now) {
      requestAnimationFrame(render)
      <strong>timer.tick(now)</strong>

      var canvas = document.querySelector('.canvas')
        , tiles = canvas.childNodes
        , top = 0
        , i = 0
        <strong>, offset = Math.round(scrollSpeed * timer.elapsed)</strong>

      for (i = 0; i < tiles.length; i += 1) {
        top = parseInt(tiles[i].style.top, 10)
        <strong>top += offset</strong>
        if (top < 0) {
          top = canvasHeight - tileHeight
        }
        tiles[i].style.top = top + 'px'
      }
    }

Instead of subtracting 20 pixels from each tile's top position, we're
subtracting our scroll speed multiplied by our elapsed time. That gives
us the amount to move our tile so that it scrolls at 20 pixels per second.

We're also rounding our offset so our tiles snap to the nearest pixel. CSS
doesn't have great subpixel positioning support, so lining things up exactly
keeps our game looking sharp.

<div class="game art" style="position: relative; display: block; width: 320px; height: 356px; overflow: hidden">
<div id="delta-scroll" style="position: absolute; top: 0; left: 0; display: block; width: 100%; height: 100%; background: #ef4d94"></div>
<div style="position: absolute; right: 0; top: 0; display: block; width: 100%; text-align: right; margin: 0; line-height: 1" class="icon-small icon-square"><span id="delta-scroll-fps">0</span> FPS</div>
<div id="delta-scroll-play" style="position: absolute; top: 0; left: 0" class="icon icon-small icon-square"><div class="icon-play"></div></div>
</div>

## Learning from the masters ##

For the actual move calculations, I took a cue from _Masters of DOOM_, and sized
my board to be one row of tiles taller than the game's visible area. That way
when a tile went out of view, I'd warp it back to the bottom of the board.

    function moveUp (element, offset, delta) {
      var top = parseInt(element.style.top) + delta

      if (top <= -tileHeight) {
        top = offset + delta
      }

      element.style.top = top + 'px'
    }

Warping tiles worked just fine, but the motion was anything but smooth.

For a 320x440 pixel game with 20x20 pixel graphics, that's 352 moving
tiles. As David Rousset points out in his [sprite benchmark][], once you go
past about 43 moving sprites on screen, performance starts to suffer.

Hit the play button below if you want to see the suffering in action. My nice
snowy world was a mess of tearing images and black line glitches.

<div class="game art" style="background: #000; position: relative; display: block; height: 356px; width: 320px; overflow: hidden">
<div id="naive-scroll" style="position: absolute; top: 0; left: 0"></div>
<div style="position: absolute; right: 0; top: 0; display: block; width: 100%; text-align: right; margin: 0; line-height: 1" class="icon-small icon-square"><span id="naive-scroll-fps">0</span> FPS</div>
<div id="naive-scroll-play" style="position: absolute; top: 0; left: 0" class="icon icon-small icon-square"><div class="icon-play"></div></div>
</div>

I got about 2 FPS on my [Raspberry Pi][], making the game totally unplayable
and sending me back to the drawing board.

## Trim back the DOM ##

All those tiles where killing performance, so I decided to cut back on the
number of moving things. Given the snowy background was just a repeated texture,
I figured I could make a row of snow and just move each row.

A 320x440 pixel tall game with 20x20 pixel tiles has 16 columns and 22 rows.
Twenty-two images for a background is well under a 43 sprite budget. I kept the
move code the same and just changed the board setup.

    function setup () {
      var y = 0
        , row = null

      for (y = 0; y < 22 + 1; y += 1) {
        row = document.createElement('div')
        row.style.background = 'url(snow.png)'

        row.style.display = 'block'
        row.style.height = 20 + 'px'
        row.style.width = 320 + 'px'

        row.style.position = 'absolute'
        row.style.top = (y * 20) + 'px'

        $('#board').appendChild(row)
      }
    }

This time I got 10 FPS on my Pi. It's inside the realm of playable, but not
great. Hit the play button below if you want to row scrolling in action.

<div class="game art" style="background: #000; position: relative; display: block; height: 356px; width: 320px; overflow: hidden">
<div id="row-scroll" style="position: absolute; top: 0; left: 0"></div>
<div style="position: absolute; right: 0; top: 0; display: block; width: 100%; text-align: right; margin: 0; line-height: 1" class="icon-small icon-square"><span id="row-scroll-fps">0</span> FPS</div>
<div id="row-scroll-play" style="position: absolute; top: 0; left: 0" class="icon icon-small icon-square"><div class="icon-play"></div></div>
</div>

My snowy world was looking less messy, but there was still room for improvement.
Every once in a while single fine black lines would show up between rows as
textures snapped imperfectly and pixels bleed through.

## Give me a lever long enough ##

One way to create a seamless background is to let the texture repeat across the
entire canvas.

    #canvas {
      background: url(snow.png);
    }

We know the texture tiles nicely, so we can let CSS handle the tiling. That
leaves us with a single node in the DOM we have to move. Our render function
changes slightly. since we want to warp the canvas back to zero once the top
row's moved off screen.

    function render (dt) {
      var tiles = $('#board').childNodes
        , offset = scrollSpeed * dt
        , i = 0

      for (i = 0; i < tiles; i += 1) {
        moveUp(tiles[i], 0, offset)
      }
    }

<div class="game art" style="background: #000; position: relative; display: block; height: 356px; width: 320px; overflow: hidden">
<div id="world-scroll" style="position: absolute; top: 0; left: 0"></div>
<div style="position: absolute; right: 0; top: 0; display: block; width: 100%; text-align: right; margin: 0; line-height: 1" class="icon-small icon-square"><span id="world-scroll-fps">0</span> FPS</div>
<div id="world-scroll-play" style="position: absolute; top: 0; left: 0" class="icon icon-small icon-square"><div class="icon-play"></div></div>
</div>

## Credits ##

Graphics for the grass and flowers come from a sprite set by [Urbansquall][].
They where posted to the Game Poetry blog back in 2009, and I'd kept them around
on my hard drive since, waiting for a project. Guess this tutorial is it.


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
    top = parseInt(tiles[i].style.top, 10)
    top += scrollSpeed
    if (top < 0) {
      top = canvasHeight + tileHeight
    }
    tiles[i].style.top = top + 'px'
  }
}

function deltaScrollRender (dt) {
  var tiles = document.getElementById('pixel-scroll').childNodes
    , top = 0
    , i = 0
    , offset = Math.round(scrollSpeed * dt)

  for (i = 0; i < tiles.length; i += 1) {
    top = parseInt(tiles[i].style.top, 10)
    top += offset
    if (top < 0) {
      top = canvasHeight + tileHeight
    }
    tiles[i].style.top = top + 'px'
  }
}

function naiveScrollRender (delta) {
  var tiles = document.getElementById('naive-scroll').childNodes
    , i = 0

  for (i = 0; i < tiles.length; i += 1) {
    moveUp(tiles[i], canvasHeight, scrollSpeed * delta)
  }
}

function rowScrollRender (delta) {
  var rows = document.getElementById('row-scroll').childNodes
    , i = 0

  for (i = 0; i < rows.length; i += 1) {
    moveUp(rows[i], canvasHeight, scrollSpeed * delta)
  }
}

function worldScrollRender (delta) {
  var rows = document.getElementById('world-scroll').childNodes
    , i = 0

  for (i = 0; i < rows.length; i += 1) {
    moveUp(rows[i], 0, scrollSpeed * delta)
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

function naiveNoScrollSetup () {
  var rows = canvasHeight / tileHeight
    , cols = canvasWidth / tileWidth

  tileSetup('naive-no-scroll', rows, cols)
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

function naiveScrollSetup () {
  var canvas = document.getElementById('naive-scroll')
    , play = document.getElementById('naive-scroll-play')
    , fps = document.getElementById('naive-scroll-fps')
    , game = new Game(naiveScrollRender, fps)
    , tile = null
    , x = 0
    , y = 0

  canvas.style.height = canvasHeight + 'px'
  canvas.style.width = canvasWidth + 'px'

  for (x = 0; x < (canvasWidth / tileWidth); x += 1) {
    for (y = 0; y < (canvasHeight / tileHeight) + 1; y += 1) {
      tile = document.createElement('img')
      tile.src = '/images/urbansquall-grass.png'
      tile.style.position = 'absolute'
      tile.style.left = (x * tileWidth) + 'px'
      tile.style.height = tileHeight + 'px'
      tile.style.width = tileWidth + 'px'
      setTop(tile, y * tileHeight)
      canvas.appendChild(tile)
    }
  }

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

function rowScrollSetup () {
  var canvas = document.getElementById('row-scroll')
    , play = document.getElementById('row-scroll-play')
    , fps = document.getElementById('row-scroll-fps')
    , game = new Game(rowScrollRender, fps)
    , row = null
    , y = 0

  canvas.style.height = canvasHeight + 'px'
  canvas.style.width = canvasWidth + 'px'

  for (y = 0; y < (canvasHeight / tileHeight) + 1; y += 1) {
    row = document.createElement('div')
    row.style.background = 'url(/images/urbansquall-grass.png)'
    row.style.display = 'block'
    row.style.position = 'absolute'
    row.style.height = tileHeight + 'px'
    row.style.width = canvasWidth + 'px'
    setTop(row, y * tileHeight)
    canvas.appendChild(row)
  }

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

function worldScrollSetup () {
  var canvas = document.getElementById('world-scroll')
    , play = document.getElementById('world-scroll-play')
    , fps = document.getElementById('world-scroll-fps')
    , game = new Game(worldScrollRender, fps)
    , world = null

  canvas.style.height = canvasHeight + 'px'
  canvas.style.width = canvasWidth + 'px'

  world = document.createElement('div')
  world.style.background = 'url(/images/urbansquall-grass.png)'
  world.style.display = 'block'
  world.style.position = 'absolute'
  world.style.height = (canvasHeight + tileHeight) + 'px'
  world.style.width = canvasWidth + 'px'
  setTop(world, 0)
  canvas.appendChild(world)

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

naiveNoScrollSetup()
pixelScrollSetup()
deltaScrollSetup()
naiveScrollSetup()
rowScrollSetup()
worldScrollSetup()
</script>


[Hard Vacuum: Recon]: /hvrecon "Frank Mitchell (js13kGames): Hard Vacuum: Recon"
[raf]: https://developer.mozilla.org/en-US/docs/Web/API/window.requestAnimationFrame "Various (Mozilla Developer Network): Window.requestAnimationFrame()"
[polyfill]: https://github.com/darius/requestAnimationFrame "Darius Bacon (GitHub): requestAnimationFrame"
[sprite benchmark]: http://sitepoint.com/html5-gaming-benchmarking-sprite-animations "David Rousset (sitepoint): HTML5 Gaming: Benchmarking Sprite Animations"
[Raspberry Pi]: http://raspberrypi.org/ "A ARM Linux computer for $35 USD"
[Urbansquall]: http://kongregate.com/ "Urbansquall (Kongregate Games): A lovely web game company that is no more"
