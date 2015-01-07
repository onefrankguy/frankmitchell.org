<!--
title: Animate your game sprites without jQuery
created: 4 January 2015 - 12:14 pm
updated: 6 January 2015 - 9:40 pm
publish: 6 January 2015
slug: spritely
tags: coding, game
-->

When you're first starting out with HTML5 game development, it's tempting to
reuse existing knowledge. Especially if you've got a web development background.
Need to animate a sprite? [Spritely][] is a jQuery plugin that does just that.

Grab a sprite sheet that's set up with animation frames from left to right.
This jewel from [Dan Cook's collection of Tyrian graphics][tyrian] works nicely.

<img class="art" src="/images/tyrian-jewel.png" width="144px" height="24px"
    alt="A six frame sprite sheet of an orange jewel with a moving hilight applied to it."
  title="A six frame sprite sheet of an orange jewel with a moving hilight applied to it."/>

Create a HTML `<div>` element for the jewel and a style it up with a little bit
of CSS.

    <div id="jewel"/>

    #jewel {
      background: url(jewel.png) 0px 0px no-repeat;
      width: 24px;
      height: 24px;
    }

Sprinkle in some JavaScript to animate it.

    $('#jewel')
      .sprite({fps: 4, no_of_frames: 6})
      .active()

And you're good, right?

<div id="jewel-spritely" class="art"
  style="width: 24px; height: 24px; background: url(/images/tyrian-jewel.png) 0px 0px no-repeat"
  title="An animation of an orange jewel with a hilight that moves from top left to bottom right twice a second."></div>

Kind of. At four frames per second, the jewel loops through its animation in
1.5 seconds. But what if you want something more compilicated? Say a three
second animation loop where half the time the jewel is unlit. The "easy"
solution would be to change the image. Just add four more unlit frames before
the first one.

If you go down that road, you'll wind up with two problems. One, it'll take
forever to tweak animations, since you'll be doing the work in an image editor.
And two, you'll blow up your game size. [Bytes matter][small-code]. Smaller
games make for faster downloads. Faster downloads make for happier users.

## Getting consistent FPS ##

jQuery is a lovely library, but it's seriously overkill for simple sprite
animation. Instead, we'll use the [`window.requestAnimationFrame` function][raf]
to roll our own animation loop.

    function render (now) {
      requestAnimationFrame(render)
    }
    requestAnimationFrame(render)

The `now` value that's passed into our render function is a high resolution
time stamp. It tells us when our render function will be called. If we want a
consistent FPS, we'll need to capture it in a timer class.

    function Timer () {
      this.last = null
      this.elapsed = 0
    }

    Timer.prototype = {
      tick: function (now) {
        this.last = this.last || now
        this.elapsed = now - this.last
      }
    }

We want to animate our jewel at four frames per second. That means we draw one
frame every 250 milliseconds. We'll use a global timer to track elapsed time,
and if it's been more than 250 milliseconds, we'll draw a frame.

    var timer = new Timer()

    function render (now) {
      requestAnimationFrame(render)
      timer.tick(now)
      if (timer.elapsed >= 250) {
        timer.last = now
        // draw jewel
      }
    }

Before we get into the drawing code, let's take a minute to reason about our
timing ocde and make sure it's doing what we want. Timing is the heart of
animation, so it's important we get this right.

Let's pretend time starts at zero and our render function gets called every 16
milliseconds. That means the first time through the `now` value will be 16. The
second time through it will be 32. Then 48 and so on. How many loops do we have
to go through before our jewel gets drawn?

<p class="math">15.625 =
<span class="fraction">
<span class="fup">250</span>
<span class="bar">/</span>
<span class="fdn">16</span>
</span>
</p>

So we have to go through 16 loops before our jewel's first frame is drawn. After
16 loops, our `now` value will be 256. When does the second frame get drawn?

<p class="math">15.25 =
<span class="fraction">
<span class="fup">500 - 256</span>
<span class="bar">/</span>
<span class="fdn">16</span>
</span>
</p>

Again, 16 calls to our render function later, we get another frame. How about
the third frame?

<p class="math">14.875 =
<span class="fraction">
<span class="fup">750 - 512</span>
<span class="bar">/</span>
<span class="fdn">16</span>
</span>
</p>

Oops. The third frame gets drawn 15 calls after the second frame. In this case,
when we're only animating at four frames per second, being off by a few
calls might not matter. But once we try to animate at speeds of 30 or 60 FPS,
being off by a few calls starts to add up.

To fix this, we can set the `last` variable in our timer to the expected
time, instead of the actual time. If we expect our first frame to draw happen at
250 milliseconds, but it doesn't happen until 256 milliseconds, we need to
remove those extra 6 milliseconds from the recorded time.

    function render (now) {
      requestAnimationFrame(render)
      timer.tick(now)
      if (timer.elapsed >= 250) {
        timer.last = now - (timer.elapsed % 250)
        // draw jewel
      }
    }

Now the timeing of our render function is more accurate, since errors per frame
won't accumulate over time. As a side effect, this also handles cases where the
time between calls to our render function isn't consistent.

## Animating without jQuery ##

Even though we're not using jQuery and the Spritely plugin, we'd like to keep
some of its flexibility. Like being able to set different frame rates for
different sprites. Instead of keeping a global timer in our render function,
lets put a custom timer in each sprite.

    function Sprite (options) {
      this.interval = 1000 / options.fps
      this.timer = new Timer()
    }

    Sprite.prototype = {
      render: function (now) {
        this.timer.tick(now)
        if (this.timer.elapsed >= this.interval) {
          var then = this.timer.elapsed % this.interval
          this.timer.last = now - then
          // draw sprite
        }
      }
    }

Now we can create a new instance of the `Sprite` class as our jewel and
call its render function in the global render function.

    var jewel = new Sprite({
      fps: 4
    })

    function render (now) {
      requestAnimationFrame(render)
      jewel.render(now)
    }

I'm pretty sure it was Dave Shea who popularized the idea of [doing image
rollovers by changing an element's background position on hover][sprites].
We can use the same idea to animate our sprite. Get the HTML element that
corresponds to our jewel and adjust its [`backgroundPositionX` property][bpx].

Our Sprite class needs to track a few more things to make this happen.
We'll keep track of the HTML element for our sprite, the index of the frame
we're in, the pixel width of each frame, and the total number of frames.

    function Sprite (element, options) {
      this.interval = 1000 / options.fps
      this.timer = new Timer()
      this.element = element
      this.width = options.width
      this.index = 0
      this.frames = options.frames
    }

Assuming our jewel image is in a HTML element with an id attribute of "jewel",
we can set up our sprite like this

    var element = document.getElementById('jewel')
    var jewel = new Sprite(element, {
      fps: 4,
      width: 24,
      frames: 6
    })

Now we can tweak the render function in the Sprite class to increment the
frame index, calculate a new background position based on the frame index and
image width, and set the background position on the element.

    render: function (now) {
      this.timer.tick(now)
      if (this.timer.elapsed >= this.interval) {
        var then = this.timer.elapsed % this.interval
        this.timer.last = now - then

        this.index += 1
        this.index %= this.frames

        var offset = this.index * this.width
        var x = '-' + offset + 'px'
        this.element.style.backgroundPositionX = x
      }
    }

Since the image we're using has frames that go left to right, we use a negative
offset for the background position so the frames move in the correct direction.
Taking the modulus of the index by the total number of frames after incrementing
it means our animation will loop. Once we hit the last frame we'll go back to
the start.

## Livening things up a bit ##

We've ditched jQuery but we haven't improved on Spritely much. Our API looks
very similar and we can still only do a single step animation that matches
up with our original image. How do we do something more complicated? Like
animate our jewel so it looks like it's breathing.

A normal human breathing cycle is a 1.5 second inhilation, a 1.5 second
exhilation, and a 2 second rest period. Five seconds total. To get our
jewel to animate like that, we can play frames 1, 2, and 3 as the inhale,
frames 3, 4, and 5 as the exhale, and frame 0 as the rest period. What if
we made the "frames" option in the Sprite class an array of frame indices
instead of the total number of frames? Than we could construct a breathing
jewel.

    var element = document.getElementById('jewel')
    var jewel = new Sprite(element, {
      fps: 2,
      width: 24,
      frames: [1, 2, 3, 3, 4, 5, 0, 0, 0, 0]
    })

The two FPS value was calculated by divinding the three inhalation frames by
the one and half seconds we want the inhalation to take.

<p class="math">2 =
<span class="fraction">
<span class="fup">3</span>
<span class="bar">/</span>
<span class="fdn">1.5</span>
</span>
</p>

Given an animation speed of 2 FPS, we need four unlit frames to account for the
two seconds of rest. Hence the four zeros at the end of the frames array. The
only other bit of code that needs to change is the render function in the
Sprite class. It needs to index into the frames array for the offset.

    render: function (now) {
      this.timer.tick(now)
      if (this.timer.elapsed >= this.interval) {
        var then = this.timer.elapsed % this.interval
        this.timer.last = now - then

        this.index += 1
        this.index %= this.frames.length

        var offset = this.frames[this.index] * this.width
        var x = '-' + offset + 'px'
        this.element.style.backgroundPositionX = x
      }
    }

Now we've got a jewel that breathes.

<div id="jewel-sexy" class="art"
  style="width: 24px; height: 24px; background: url(/images/tyrian-jewel.png) 0px 0px no-repeat"
  title="An animation of an orange jewel with a hilight that moves from top left to bottom right, pulsing at the same speed a person breathes."></div>

## Writing your own code ##

It's totally tempting to say, "I can rewrite Spritely in 37 lines of code. Less
code is always better. I'll just use my version." Sometimes that's the right
decision. Like in a game jam where one of the rules is that all code has to be
new. Sometimes it's the wrong decision. Like when you're prototyping animations
and you need something that just works. You have to pick.

I tend to do code rewrites when I want to really learn how something works. By
taking an idea like sprite animation and writing my own handful of functions to
implement it, I gain a better understanding of the potential issues that might
crop up while I'm using a library I didn't write. So when I have to dig into
someone else's code to fix something, I've already got a mental map of how it
might work.

Plus it expands my toolbox for making video games.

<script>
;(function () {
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
        , timeToCall = Math.max(0, 16 - (currTime - lastTime))
        , timerId = setTimeout(function () {
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
}())

function Timer () {
  this.last = null
  this.elapsed = 0
}

Timer.prototype = {
  tick: function (now) {
    this.last = this.last || now
    this.elapsed = now - this.last
  }
}

function Sprite (options) {
  this.interval = 1000 / options.fps
  this.timer = new Timer()
  this.frames = options.frames
  this.width = options.width
  this.index = 0
  this.element = document.getElementById(options.id)
}

Sprite.prototype = {
  render: function (now) {
    this.timer.tick(now)
    if (this.timer.elapsed >= this.interval) {
      var then = this.timer.elapsed % this.interval
      this.timer.last = now - then

      this.index += 1
      this.index %= this.frames.length

      var offset = this.frames[this.index] * this.width
      var x = '-' + offset + 'px'
      this.element.style.backgroundPositionX = x
    }
  }
}

var jewel_spritely = new Sprite({
  id: 'jewel-spritely'
, width: 24
, fps: 4
, frames: [0, 1, 2, 3, 4, 5]
})

var jewel_sexy = new Sprite({
  id: 'jewel-sexy'
, width: 24
, fps: 2
, frames: [1, 2, 3, 3, 4, 5, 0, 0, 0, 0]
})

function render (now) {
  requestAnimationFrame(render)
  jewel_spritely.render(now)
  jewel_sexy.render(now)
}
requestAnimationFrame(render)
</script>


[Spritely]: http://sprite.ly/ "Michael Schuller (Artlogic Media): Spritely"
[tyrian]: http://www.lostgarden.com/2007/04/free-game-graphics-tyrian-ships-and.html "Dan Cook (Lost Garden): Free game graphics: Tyrian ships and tiles"
[small-code]: /2010/09/small-code "Frank Mitchell: Bytes matter on the mobile web"
[raf]: https://developer.mozilla.org/en-US/docs/Web/API/window.requestAnimationFrame "Various (Mozilla Developer Network): Window.requestAnimationFrame()"
[bpx]: https://developer.mozilla.org/en-US/docs/Web/CSS/background-position "Various (Mozilla Developer Network): background-position - CSS"
[sprites]: http://alistapart.com/article/sprites "Dave Shea (A List Aprt): CSS Sprites: Image Slicing's Kiss of Death"
