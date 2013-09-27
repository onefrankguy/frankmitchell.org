<!--
title:  Smoothly scrolling a vertical shooter with JavaScript
created: 24 September 2013 - 5:59 am
updated: 27 September 2013 - 7:05 am
publish: 24 September 2013
slug: scroll-js
tags: coding, mobile
-->

[Hard Vacuum: Recon][] is a vertical shooter without the shooting. To pull off
the illusion of flight, I move the world as the player flys over it. Getting
that animation running smoothly, while allowing the world to form dynamically,
was tricky.

## 310 sprites too many ##

My first approach was na&iuml;ve. Put a `<div>` on the screen for every tile
in the game. Move each `<div>` with every call to `requestAnimationFrame`.

    function render (dt) {
      var tiles = $('#board').childNodes
        , offset = scrollSpeed * dt
        , i = 0

      for (i = 0; i < tiles; i += 1) {
        moveUp(tiles[i], offset)
      }
    }

For the actual move calculations, I took a cue from _Masters of DOOM_, and sized
my board to be one row of tiles taller than the game's visible area. That way
when a tile went out of view, I'd warp it back to the bottom of the board.

    function moveUp (element, dy) {
      var top = parseInt(element.style.top) + dy

      if (top  < -tileHeight) {
        top = dy
      }

      element.style.top = top + 'px'
    }

Warping tiles worked just fine, but the motion was anything but smooth.

For a 320x440 pixel game with 20x20 pixel graphics, that's 352 moving
tiles. As David Rousset points out in his [sprite benchmark][], once you go
past about 43 moving sprites on screen, performance starts to suffer.

Hit the play button below if you want to see the suffering in action. My nice
snowy world was a mess of tearing images and black line glitches.

<div class="game art" style="background: #000; position: relative; display: block; height: 440px; width: 320px; overflow: hidden">
<div id="naive-scroll" style="position: absolute; top: 0; left: 0"></div>
<div id="naive-scroll-fps" style="position: absolute; right: 0; top: 0; display: block; width: 100%; text-align: right; margin: 0; line-height: 1" class="icon-small icon-square">0 FPS</div>
<div id="naive-scroll-play" style="position: absolute; top: 0; left: 0" class="icon icon-small icon-square"><div class="icon-play"></div></div>
</div>

I got about 2 FPS on my [Raspberry Pi][], making the game totally unplayable
and sending me back to the drawing board.

## Trimming back the DOM ##

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

This time I got a solid 15 FPS on my Pi. Well inside the realm of playable. Hit
the play button below if you want to row scrolling in action. My snowy world was
looking less messy.

<div class="game art" style="background: #000; position: relative; display: block; height: 440px; width: 320px; overflow: hidden">
<div id="row-scroll" style="position: absolute; top: 0; left: 0"></div>
<div id="row-scroll-fps" style="position: absolute; right: 0; top: 0; display: block; width: 100%; text-align: right; margin: 0; line-height: 1" class="icon-small icon-square">0 FPS</div>
<div id="row-scroll-play" style="position: absolute; top: 0; left: 0" class="icon icon-small icon-square"><div class="icon-play"></div></div>
</div>

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

function Game (callback) {
  this.timer = new Timer()
  this.callback = callback
  this.raf = null
}
Game.prototype = {
  render: function (time) {
    this.play()
    this.timer.tick(time)
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

var canvasHeight = 440
  , canvasWidth = 320
  , tileHeight = 20
  , tileWidth = 20
  , scrollSpeed = -20

function getTop (element) {
  return parseFloat(element.getAttribute('data-top'), 10)
}

function setTop (element, value) {
  element.setAttribute('data-top', value)
  element.style.top = ((value + 0.5) | 0) + 'px'
}

function moveUp (element, delta) {
  var offset = getTop(element) + delta
  if (offset <= -tileHeight) {
    offset = canvasHeight + delta
  }
  setTop(element, offset)
}

function naiveScrollRender (delta) {
  var tiles = document.getElementById('naive-scroll').childNodes
    , i = 0

  for (i = 0; i < tiles.length; i += 1) {
    moveUp(tiles[i], scrollSpeed * delta)
  }
}

function rowScrollRender (delta) {
  var rows = document.getElementById('row-scroll').childNodes
    , i = 0

  for (i = 0; i < rows.length; i += 1) {
    moveUp(rows[i], scrollSpeed * delta)
  }
}

function naiveScrollSetup () {
  var canvas = document.getElementById('naive-scroll')
    , play = document.getElementById('naive-scroll-play')
    , game = new Game(naiveScrollRender)
    , tile = null
    , x = 0
    , y = 0

  canvas.style.height = canvasHeight + 'px'
  canvas.style.width = canvasWidth + 'px'

  for (x = 0; x < (canvasWidth / tileWidth); x += 1) {
    for (y = 0; y < (canvasHeight / tileHeight) + 1; y += 1) {
      tile = document.createElement('img')
      tile.src = '/images/hvrecon-snow.png'
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
    , game = new Game(rowScrollRender)
    , row = null
    , y = 0

  canvas.style.height = canvasHeight + 'px'
  canvas.style.width = canvasWidth + 'px'

  for (y = 0; y < (canvasHeight / tileHeight) + 1; y += 1) {
    row = document.createElement('div')
    row.style.background = 'url(/images/hvrecon-snow.png)'
    row.style.display = 'block'
    row.style.position = 'absolute'
    row.style.height = tileHeight + 'px'
    row.style.width = (canvasWidth * tileWidth) + 'px'
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

naiveScrollSetup()
rowScrollSetup()
</script>


[Hard Vacuum: Recon]: /hvrecon "Frank Mitchell (js13kGames): Hard Vacuum: Recon"
[polyfill]: https://github.com/darius/requestAnimationFrame "Darius Bacon (GitHub): requestAnimationFrame"
[sprite benchmark]: http://sitepoint.com/html5-gaming-benchmarking-sprite-animations "David Rousset (sitepoint): HTML5 Gaming: Benchmarking Sprite Animations"
[Raspberry Pi]: http://raspberrypi.org/ "A ARM Linux computer for $35 USD"
