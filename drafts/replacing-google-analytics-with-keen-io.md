<!--
title: Replacing Google Analytics with Keen IO
created: 22 April 2013 - 7:43 pm
updated: 22 April 2013 - 9:07 pm
publish: 23 April 2023
slug: keen-analysis
tags: coding, design
-->

[Google Analytics][] is the 800 lb. gorilla when it comes to website metrics
collection. But when you're working on a single page application, that one size
fits all approach often falls short. If you're building a [word search game][],
Google makes it hard to track arbitrary metrics like the most frequently found
word.

[Keen IO][] fixes that by letting you track anything. Seriously, anything. If
you can represent it as text, you can track it. Given that, here are the steps
for replacing Google Analytics with Keen IO. Note that this isn't a full on
1-for-1 replacement. It's a bare bones basic analytics package for your website,
with enough flexibility that you can dress it up any way you see fit.

## Four questions for your website ##

When someone comes to your site, there are four basic things you want to know.

* Who are they?
* Where did they come from?
* When did they get here?
* What page are they on?

You're interested in other questions too, like "How long did they stay?", but
you can get that sort of data by answering the first four questions. Looking
at the differences in time between visits by the same person will tell you how
long they stayed on a given page.

Tracking individual users to your website gets fuzzy unless you want to give
people cookies. For now, skip the baking and just grab the name of the browser
they're using to view your site. You'll find it in the
[`window.navigator.userAgent`][agent] object.

    var info = function () {
      {
        agent: window.navigator.userAgent
      }
    }

Figuring out where someone came from to get to your site is a lot easier than
figuring out who they are. The [`document.referrer`][referrer] object holds the
URL that was visited just before they got to your site. Want to figure out who's
linking to your content and how people are finding your stuff? This is what you
need.

    var info = function () {
      {
        referrer: document.referrer,
        agent: window.navigator.userAgent
      }
    }

[Google Analytics]: https://google.com/analytics/ "Various (Google): Google Analytics Official Website - Web Analytics and Reporting"
[word search game]: http://prolix-app.com/ "Frank Mitchell: Prolix is a word search game that lets you tweet your scores so your friends can play with you."
[Keen IO]: https://keen.io/ "Various (Keen IO): Analytics Backend as a Service"
[agent]: https://developer.mozilla.org/en-US/docs/DOM/window.navigator.userAgent "Various (Mozilla): window.navigator.userAgent - Document Object Model"
[referrer]: https://developer.mozilla.org/en-US/docs/DOM/document.referrer "Various (Mozilla): document.referrer - Document Object Model"
