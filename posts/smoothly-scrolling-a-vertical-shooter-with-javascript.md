<!--
title:  Smoothly scrolling a vertical shooter with JavaScript
created: 24 September 2013 - 5:59 am
updated: 24 September 2013 - 7:19 am
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
For a 320x440 pixel game with 20x20 pixel graphics, that's 352 moving
tiles. As David Rousset points out in his [sprite benchmark][], once you go
past about 43 moving sprites on screen, performance starts to suffer.

Hit the play button below if you want to see the suffering in action. My nice
snowy world was a mess of images tearing and black line glitches.

<div id="naive-scroll-play" class="icon icon-small icon-square"><div class="icon-play"></div></div>
<div style="overflow: hidden">
<div id="naive-scroll" class="game art" style="position: relative; background: #000"></div>
</div>

It's messy.

<script type="text/javascript">
;(function () {
"use strict";

var lastTime = 0
  , vendor = ["ms", "mos", "webkit", "o"]
  , i = 0

while (i < vendor.length && !window.requestAnimationFrame) {
  window.requestAnimationFrame = window[vendor[i]+"RequestAnimationFrame"]
  window.cancelAnimationFrame = window[vendor[i]+"CancelAnimationFrame"] || window[vendor[i]+"RequestCancelAnimationFrame"]
  i += 1
}

if (!window.requestAnimationFrame) {
  window.requestAnimationFrame = function (callback, element) {
    var currTime = new Date().getTime()
    var timeToCall = Math.max(0, 16 - (currTime - lastTime))
    var timerId = setTimeout(function () {
      callback(currTime + timeToCall)
    }, timeToCall)
    lastTime = currTime + timeToCall
    return timerId
  }
}

if (!window.cancelAnimationFrame) {
  window.cancelAnimationFrame = function (id) {
    clearTimeout(id)
  }
}
})()

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

function setupNaiveScroll () {
  var canvas = document.getElementById('naive-scroll')
    , play = document.getElementById('naive-scroll-play')
    , tile = null
    , x = 0
    , y = 0

  canvas.style.height = '440px'
  canvas.style.width = '320px'

  for (x = 0; x < 16; x += 1) {
    for (y = 0; y < 22; y += 1) {
      tile = document.createElement('img')
      tile.src = '/images/hvrecon-snow.png'
      tile.style.position = 'absolute'
      tile.style.left = (x * 20) + 'px'
      tile.style.top = (y * 20) + 'px'
      tile.style.height = '20px'
      tile.style.width = '20px'
      canvas.appendChild(tile)
    }
  }

  addTouch(play, function () {
    var icon = play.childNodes[0]
    if (icon.className === 'icon-play') {
      icon.className = 'icon-stop'
    }
    else {
      icon.className = 'icon-play'
    }
  }, null)
}

setupNaiveScroll()
</script>


[Hard Vacuum: Recon]: /hvrecon "Frank Mitchell (js13kGames): Hard Vacuum: Recon"
[sprite benchmark]: http://sitepoint.com/html5-gaming-benchmarking-sprite-animations "David Rousset (sitepoint): HTML5 Gaming: Benchmarking Sprite Animations"
