<!--
title:  Smoothly scrolling a vertical shooter with JavaScript
created: 24 September 2013 - 5:59 am
updated: 26 September 2013 - 7:03 am
publish: 24 September 2013
slug: scroll-js
tags: coding, mobile
-->

[Hard Vacuum: Recon][] is a vertical shooter without the shooting. To pull off
the illusion of flight, I move the world as the player flys over it. Getting
that animation running smoothly, while allowing the world to form dynamically,
was tricky.

## Timing is everything ##

At the heart of a smooth animation loop lies a call to `requestAnimationFrame`.
Invoking the `requestAnimationFrame` method tells the browser you want to
perform an animation before the next repaint. It's not implemented in every
browser, so we have to [polyfill][] it. First, we'll check for Safari, FireFox, IE,
and Opera specific extensions.

    var ext = ['webkit', 'moz', 'ms', 'o']

    for (var i = 0; i < ext.length; i += 1) {
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

If we don't find a vendor specific extensions, we can fall back to using
`setTimeout` and `clearTimeout`. To run our game at 60 frames per seoncd, we
call our render function every 16 milliseconds. If you do the math, that
actually comes out to 62.5 frames per second, but the spec for
`requestAnimationFrame` leaves the max speed up to the browser, so we're okay.

    var last = 0

    window.requestAnimationFrame = function (callback) {
      var now = Date.now()
        , later = Math.max(last + 16, now)
      return setTimeout(function () {
        callback(last = later)
      }, later - now)
    }

    window.cancelAnimationFrame = clearTimeout

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

## 310 sprites too many ##

My first approach was na&iuml;ve. Put a `<div>` on the screen for every tile
in the game. Move each `<div>` with every call to `requestAnimationFrame`.
For a 320x440 pixel game with 20x20 pixel graphics, that's 352 moving
tiles. As David Rousset points out in his [sprite benchmark][], once you go
past about 43 moving sprites on screen, performance starts to suffer.

Hit the play button below if you want to see the suffering in action. My nice
snowy world was a mess of tearing images and black line glitches.

<div class="game art" style="background: #000; position: relative; display: block; height: 440px; width: 320px; overflow: hidden">
<div id="naive-scroll" style="position: absolute; top: 0; left: 0"></div>
<div id="naive-scroll-play" style="position: absolute; top: 0; left: 0" class="icon icon-small icon-square"><div class="icon-play"></div></div>
</div>

It's messy.

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

naiveScrollSetup()
</script>


[Hard Vacuum: Recon]: /hvrecon "Frank Mitchell (js13kGames): Hard Vacuum: Recon"
[polyfill]: https://github.com/darius/requestAnimationFrame "Darius Bacon (GitHub): requestAnimationFrame"
[sprite benchmark]: http://sitepoint.com/html5-gaming-benchmarking-sprite-animations "David Rousset (sitepoint): HTML5 Gaming: Benchmarking Sprite Animations"
