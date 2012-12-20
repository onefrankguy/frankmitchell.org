<!--
title: You don't always need to frame things
date: 27 September 2010
-->

One of the questions I've been asked a lot since building [Prolix][] is, "Why
didn't you use a framework like [jQuery][]?" The short answer is, "Because I
didn't need it."

## There's no point in diving unless you can swim ##

When I started working on Prolix, I knew next to nothing about JavaScript. I
still don't know much about it, but I'm making a point to learn. I've read
[JavaScript: The Good Parts][]. I've looked at the code behind
[web apps Iadmire][]. And I've poured over every line of jQuery until I
understand what each one does.

Frameworks are wonderful things. They speed up the development process and make
changing things easier. They help you write more portable code. They are
wonderful tools that make my life as an engineer better.

But personally, I've never felt comfortable using a tool I don't understand.  I
know that violates the whole concept of "layers of abstraction", that you
should be able to use something without having to understand how it works. But
when my electric knife sharpener breaks, I want the confidence that comes from
knowing that I can pull out a whetstone and still get stuff done.

JavaScript is such a fundamental part of web development that I wanted to really
understand it before I started using a framework that abstracted it all away
from me. Now that I've built Prolix, I'm a lot more confident about my ability
to use frameworks like jQuery in other projects.

## Size matters not, until it does ##

When it comes to application development on the mobile web [size matters][]. The
smaller your code, the faster it's going to download and execute.  Even when
it's minified and gzipped, jQuery is still 24 kilobytes. While things like the
[Google Libraries API][] help, they don't eliminate all that sting.

Instead, here's the 276 byte version of jQuery I used in Prolix:

    function $(id) {
      return document.getElementById(id);
    }

    function html(id, text) {
      $(id).innerHTML = text;
    }

    function animate(element, animation) {
      element.style.webkitAnimationName = '';
      setTimeout(function () {
        element.style.webkitAnimationName = animation;
      }, 0);
    }

Yes, it only supports [WebKit][] animations, but that's okay. Animations aren't
necessary for the game to work. Because the only platforms I was targeting were
CSS 3 compliant browsers, I didn't need all the cross browser compatibility that
jQuery provides.

Instead, I wrote the minimum amount of functionality I needed in as few bytes as
possible. Including jQuery would have made Prolix 1.25 times bigger, and I
wouldn't have gained much from it.

## Not every photo needs a frame ##

Frameworks are great for starting up, for helping you compose an application and
focus on the core functionality. When you're writing something big, or if you
need it to be really robust, tried and tested code from a framework is much
better than rolling your own.

But if you really want to learn a concept, or you need to keep the code as small
as possible, frameworks just get in the way.

[Prolix]: http://prolix-app.com/ "A tweetable word search game for the iPhone and iPod touch"
[jQuery]: http://jquery.com/ "jQuery: The Write Less, Do More, JavaScript Library"
[JavaScript: The Good Parts]: http://oreilly.com/catalog/9780596517748 "JavaScript: The Good Parts - O'Reilly Media"
[web apps I admire]: http://everytimezone.com/ "Every Time Zone"
[size matters]: /2010/09/small-code "Frank Mitchell: Bytes matter on the mobile web"
[Google Libraries API]: http://code.google.com/apis/libraries/ "Google Code: A content distribution network for popular JavaScript libraries"
[WebKit]: http://webkit.org/ "The WebKit Open Source Project"
