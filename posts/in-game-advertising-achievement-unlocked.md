<!--
title:  In-game advertising achievement unlocked
created: 4 November 2013 - 6:12 am
updated: 4 November 2013 - 6:30 am
publish: 4 November 2013
slug: html5-ads
tags: coding, mobile
-->

Play enough video games and you'll eventually come across an in-game
advertisement.

## When television and radio ruled ##

## eCPM and other acronyms ##

## Clicks vs. impressions ##

## A premission based world ##


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
