<!--
title:  In-game advertising achievement unlocked
created: 4 November 2013 - 6:12 am
updated: 7 November 2013 - 6:35 pm
publish: 4 November 2013
slug: html5-ads
tags: coding, mobile
-->

Play enough video games and you'll eventually come across an in-game
advertisement.In the mobile world, these tend to take the form of banner
bars or full screen ads. If you're just starting out with HTML5 game
development, navigating the world of advertising can get tricky fast.
Here's a guide to get you started.

## When television and radio ruled ##

## eCPM and other acronyms ##

As with any social setting, the adversiting world has its own lingo. Words
like "creative" are used as nouns instead of adjectives, and concepts like
"click through rate" get replaced with three letter acronyms. But at its
core, advertising is driven by one thing, revenue.

Revenue is the total amount of money a publisher makes from advertising.
For an advertiser, it's the amoutn of money they make from sales of product.
For a publisher, it's the amoutn of money they make from selling ad space.
For a user, yeah, they don't make money off ads.

## Clicks vs. impressions ##

## A permission based world ##


<script type="text/javascript">
;(function () {
"use strict";

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

})()
</script>


[sma]: http://www.operamediaworks.com/sma_q2_2013.html "Various (Opera Mediaworks): The Sztate of Mobile Advertising, Q2 2013"
