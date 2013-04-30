<!--
title: Replacing Google Analytics with Keen IO
created: 22 April 2013 - 7:43 pm
updated: 30April 2013 - 8:10 am
publish: 30 April 2013
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
one-for-one replacement. It's a bare bones basic analytics package for your
website, with enough flexibility that you can dress it up any way you see fit.

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

    var pageView = function () {
      return {
        agent: window.navigator.userAgent
      };
    };

Figuring out where someone came from to get to your site is a lot easier than
figuring out who they are. The [`document.referrer`][referrer] object holds the
URL that was visited just before they got to your site. Want to figure out who's
linking to your content and how people are finding your stuff? This is what you
need.

    var pageView = function () {
      return {
        referrer: document.referrer,
        agent: window.navigator.userAgent
      };
    };

"What time is it?" is a simple question to answer with the [`Date`][date]
object. You can even get the answer in ISO 8601 format, which makes it perfect
for storing.

    var pageView = function () {
      return {
        time: new Date().toISOString(),
        referrer: document.referrer,
        agent: window.navigator.userAgent
      };
    };

Details about where in your site a user landed are kept in the
[`window.location`][href] object. Recording the `href` attribute gives you
the complete URL. Other attributes, like `pathname` give you more fine grained
information.

    var pageView = function () {
      return {
        page: window.location.href,
        time: new Date().toISOString(),
        referrer: document.referrer,
        agent: window.navigator.userAgent
      };
    };

Now that you've got all the information you want to record about visits to
your site, you can push that data into Keen IO.

## Getting page views into Keen IO ##

[Sign up][] for a Keen IO account if you don't already have one. It takes
two seconds if you've already on [GitHub][]. Once you're logged in, rename
your default project to your site's domain name. Keeping separate projects
for each of the sites you have lets you track page views for each site
separately. Then make a note of the project's token. That UUID is what lest
Keen IO know what site a particular page view came from.

Keen IO has [great documentation][] for setting up their JavaScript client.
The first thing you need is the `Keen` object. It provides a temporary
storage place for your metrics until they can be sent to Keen. Calling the
`Keen.addEvent` function gives you a way to start capturing metrics as soon as
your page loads.

    var Keen = Keen || {
      configure: function (a, b, c) {
        this._pId = a;
        this._ak = b;
        this._op = c;
      },
      addEvent: function (a, b, c, d) {
        this._eq = this._eq || [];
        this._eq.push([a, b, c, d]);
      },
      setGlobalProperties: function (a) {
        this._gp = a;
      },
      onChartsReady: function (a) {
        this._ocrq = this._ocrq || [];
        this._ocrq.push([a]);
      }
    };

Once you've got the `Keen` object, you can load the actual analytics script.
One of the benefits of Keen IO is its small size. The latest version of Google
Analytics weighs in at 40 kilobytes, compared to Keen's 28 kilobytes.
[Bytes matter on the mobile web][], and a smaller analytics engine means your
code loads and runs faster.

    var protocol = 'https:';
    if (document.location.protocol !== 'https://') {
      protocol = 'http://';
    }

    var keen = document.createElement('script');
    keen.type = 'text/javascript';
    keen.async = true;
    keen.src = protocol;
    keen.src += 'dc8na2hxrj29i.cloudfront.net';
    keen.src += '/code/keen-2.0.0-min.js';

    var script = document.getElementsByTagName('script');
    script = script[0];
    script.parentNode.insertBefore(keen, script);

Finally, you can configure the `Keen` object with your project token, and push
your page view information to Keen IO.

    Keen.configure('your_project_token');
    Keen.addEvent('pageView', pageView());

You can roll all that JavaScript into a single file and drop it in a `<script>`
tag just before the closing `<body>` tag on your site. Loading all your content
before running analytics makes your more responsive, which helps ensure your
visitors stick around.

[Google Analytics]: https://google.com/analytics/ "Various (Google): Google Analytics Official Website - Web Analytics and Reporting"
[word search game]: http://prolix-app.com/ "Frank Mitchell: Prolix is a word search game that lets you tweet your scores so your friends can play with you."
[Keen IO]: https://keen.io/ "Various (Keen IO): Analytics Backend as a Service"
[agent]: https://developer.mozilla.org/en-US/docs/DOM/window.navigator.userAgent "Various (Mozilla): window.navigator.userAgent - Document Object Model"
[referrer]: https://developer.mozilla.org/en-US/docs/DOM/document.referrer "Various (Mozilla): document.referrer - Document Object Model"
[date]: https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/Date "Various (Mozilla): Date - JavaScript"
[href]: https://developer.mozilla.org/en-US/docs/DOM/window.location "Various (Mozilla): window.location - Document Object Model"
[Sign up]: https://keen.io/signup "Various (Keen IO): Sign up for Keen IO"
[GitHub]: https://github.com/ "Various (GitHub): Social coding"
[great documentation]: https://keen.io/docs/clients/javascript/usage-guide/ "Various (Keen IO): JavaScript SDK Usage Guide"
[Bytes matter on the mobile web]: /2010/09/small-code "Frank Mitchell: Bytes matter on the mobile web"
