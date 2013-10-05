<!--
title:  Smoothly scrolling a vertical shooter with JavaScript
created: 24 September 2013 - 5:59 am
updated: 5 October 2013 - 8:24 am
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
      position: relative;
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
<div id="no-scroll" style="position: absolute; top: 0; left: 0; display: block; width: 100%; height: 100%; background: #ef4d94"></div>
</div>

Now let's see if we can get our world moving.

## Scroll, baby, scroll ##

The simplest approach to scrolling would be to move every row every frame.
That will trigger a DOM repaint with every `<div>` we move, and if we're not
careful about subpixel positioning, it'll lead to gaps where rows don't quite
overlap.

Instead, we can just move the entire canvas, and let the browser handle keeping
the rows butted up next to each other.

    function render (now) {
      requestAnimationFrame(render)

      var canvas = document.querySelector('.canvas')
        , sprite = null
        , top = parseFloat(canvas.style.top, 10)

      top -= 1

      if (top <= -tileHeight) {
        sprite = canvas.removeChild(canvas.firstChild)
        canvas.appendChild(sprite)
        top = 0
      }

      canvas.style.top = top + 'px'
    }

    requestAnimationFrame(render)

We use the [`window.requestAnimationFrmae()`][raf] function to add a render
loop. Because it's not supported by every browser yet, we have to include a
[polyfill][] to make it work.

Every time we run through our render loop, we move the canvas up one pixel.
Once the top row goes out of view, we remove it from the DOM and add it back
to the bottom of the canvas. Then we reset the top of the canvas so it lines
up with the top of the viewport.

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

I get 16 FPS on my [Raspberry Pi][], which is right inside the realm of playble.
A general rule of thumb is that if you can get 15 FPS or better on a Pi, a first
generation iPhone 4 should be able to handle your game just fine.

## Timing is everything ##

Right now, our world is moving one pixel with every call to our render function.
Ideally, we'd be able to set a scroll speed, like 20 pixels per second, and
stick to it regardless of frame rate. Fortunately, `requestAnimationFrame` comes
to our rescue.

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

<pre><code><ins>var scrollSpeed = -20</ins>
  <ins>, timer = new Timer()</ins>

function render (now) {
  requestAnimationFrame(render)
  <ins>timer.tick(now)</ins>

  var canvas = document.querySelector('.canvas')
    , sprite = null
    , top = parseFloat(canvas.style.top, 10)
    <ins>, offset = scrollSpeed * timer.elapsed</ins>

  <del>top -= 1</del>
  <ins>top += offset</ins>

  if (top <= -tileHeight) {
    sprite = canvas.removeChild(canvas.firstChild)
    canvas.appendChild(sprite)
    <del>top = 0</del>
    <ins>top = offset</ins>
  }

  canvas.style.top = top + 'px'
}
</code></pre>

Instead of subtracting one pixel from the canvas's top position, we're
subtracting our scroll speed multiplied by our elapsed time. That gives
us the amount to move the canvas so it scrolls at 20 pixels per second.

Push the play button to see it in action.

<div class="game art" style="position: relative; display: block; width: 320px; height: 356px; overflow: hidden">
<div id="delta-scroll" style="position: absolute; top: 0; left: 0; display: block; width: 100%; height: 100%; background: #ef4d94"></div>
<div style="position: absolute; right: 0; top: 0; display: block; width: 100%; text-align: right; margin: 0; line-height: 1" class="icon-small icon-square"><span id="delta-scroll-fps">0</span> FPS</div>
<div id="delta-scroll-play" style="position: absolute; top: 0; left: 0" class="icon icon-small icon-square"><div class="icon-play"></div></div>
</div>

Now that our world scrolls smoothly, let's see about bringing it to life.

## If a tree falls in a forest ##

Nothing quite says "forest" like a tree, so let's plan some.

<img class="game art" style="background: url(/images/urbansquall-grass.png); padding: 8px" width="64px" height="128px" src="/images/urbansquall-tree.png"/>

<div class="game art" style="position: relative; display: block; width: 320px; height: 356px; overflow: hidden">
<div id="tree-scroll" style="position: absolute; top: 0; left: 0; display: block; width: 100%; height: 100%; background: #ef4d94"></div>
<div style="position: absolute; right: 0; top: 0; display: block; width: 100%; text-align: right; margin: 0; line-height: 1" class="icon-small icon-square"><span id="tree-scroll-fps">0</span> FPS</div>
<div id="tree-scroll-play" style="position: absolute; top: 0; left: 0" class="icon icon-small icon-square"><div class="icon-play"></div></div>
</div>

## Credits ##

Graphics for this demo come from a sprite set by [Urbansquall][]. They where
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

var oddOrEven = 0
function updateRow (row) {
  row.innerHTML = ''

  oddOrEven += 1
  oddOrEven %= 2

  if (oddOrEven === 0) {
    return
  }


  var tree = document.createElement('div')
  tree.style.background = 'url(/images/urbansquall-tree.png)'
  tree.style.width = '32px'
  tree.style.height = '64px'
  tree.style.position = 'absolute'
  tree.style.top = '-32px'
  tree.style.left = '0px'

  row.appendChild(tree)
}

function pixelScrollRender () {
  var canvas = document.getElementById('pixel-scroll')
    , sprite = null
    , top = parseFloat(canvas.style.top, 10) + -1

  if (top <= -tileHeight) {
    sprite = canvas.removeChild(canvas.firstChild)
    canvas.appendChild(sprite)
    top = 0
  }
  canvas.style.top = top + 'px'
}

function deltaScrollRender (dt) {
  var canvas = document.getElementById('delta-scroll')
    , sprite = null
    , offset = scrollSpeed * dt
    , top = parseFloat(canvas.style.top, 10) + offset

  if (top <= -tileHeight) {
    sprite = canvas.removeChild(canvas.firstChild)
    canvas.appendChild(sprite)
    top = offset
  }
  canvas.style.top = top + 'px'
}

function treeScrollRender (dt) {
  var canvas = document.getElementById('tree-scroll')
    , sprite = null
    , offset = scrollSpeed * dt
    , top = parseFloat(canvas.style.top, 10) + offset

  if (top <= -tileHeight) {
    sprite = canvas.removeChild(canvas.firstChild)
    updateRow(sprite)
    canvas.appendChild(sprite)
    top = offset
  }
  canvas.style.top = top + 'px'
}

function rowSetup (id, rows, callback) {
  var canvas = document.getElementById(id)
    , sprite = null
    , y = 0

  for (y = 0; y < rows; y += 1) {
    sprite = document.createElement('div')
    sprite.style.background = 'url(/images/urbansquall-grass.png)'
    sprite.style.position = 'relative'
    sprite.style.display = 'block'
    sprite.style.width = '100%'
    sprite.style.height = tileHeight + 'px'
    if (typeof callback === 'function') {
      callback(sprite)
    }
    canvas.appendChild(sprite)
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
  var rows = Math.ceil(canvasHeight / tileHeight) + 1
  rowSetup('pixel-scroll', rows)
  demoSetup('pixel-scroll', pixelScrollRender)
}

function deltaScrollSetup () {
  var rows = Math.ceil(canvasHeight / tileHeight) + 1
  rowSetup('delta-scroll', rows)
  demoSetup('delta-scroll', deltaScrollRender)
}

function treeScrollSetup () {
  var rows = Math.ceil(canvasHeight / tileHeight) + 1
  rowSetup('tree-scroll', rows, updateRow)
  demoSetup('tree-scroll', treeScrollRender)
}

noScrollSetup()
pixelScrollSetup()
deltaScrollSetup()
treeScrollSetup()
</script>


[Hard Vacuum: Recon]: /hvrecon "Frank Mitchell (js13kGames): Hard Vacuum: Recon"
[ce]: https://developer.mozilla.org/en-US/docs/Web/API/document.createElement "Various (Mozilla Developer Network): document.createElement()"
[ac]: https://developer.mozilla.org/en-US/docs/Web/API/Node.appendChild "Various (Mozilla Developer Network): Node.appendChild()"
[raf]: https://developer.mozilla.org/en-US/docs/Web/API/window.requestAnimationFrame "Various (Mozilla Developer Network): Window.requestAnimationFrame()"
[polyfill]: https://github.com/darius/requestAnimationFrame "Darius Bacon (GitHub): requestAnimationFrame"
[sprite benchmark]: http://sitepoint.com/html5-gaming-benchmarking-sprite-animations "David Rousset (sitepoint): HTML5 Gaming: Benchmarking Sprite Animations"
[Raspberry Pi]: http://raspberrypi.org/ "A ARM Linux computer for $35 USD"
[Urbansquall]: http://kongregate.com/ "Urbansquall (Kongregate Games): A lovely web game company that is no more"
