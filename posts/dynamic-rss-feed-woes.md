<!--
title: Dynamic RSS feed woes
created: 28 October 2004 - 6:02 am
updated: 31 October 2004 - 8:06 am
slug: rss-feed
tags: elimossinary
-->


### PHP can be tricky ###

When you want something to be bleading edge, you'll occasionally get cut. My RSS feed for Can't Count Sheep is dynamically generated. At the moment, this is being accomplished with a PHP script that graps the lastest six entries (based on file creation time) and builds an XML file out of them.

That seems to work all fine and dandy, except for the fact that PHP inserts a newline and return character (`\n\r`) at the begining of every page it generates. HTML still [validates][validhtml], since it's forgiving of that sort of thing. But the anal retentive RSS specs mean my feed [doesn't][validrss].


### Embrace Postel's Law ###

Postel's Law, states that you should "be conservative in what you do, and liberal in what you accept from others". It's a [principle][postel] Mark Pilgrim kept in mind when he designed his [feed parser][mpfeedparser]. Let's hope that other news readers have done the same.

So, if you can (or can't) read [my RSS feed][ccsrss], leave a [comment][comemail] that lets me know what news reader you're using. I'd like to know whether or not this bug is actually affecting anyone, so I can determine if it's worth my time to hunt down a solution.


### Problem solved ###

Well, thanks to a bit of PHP trickery, my problem's been solvoed. I added the line `echo '<?xml version="1.0">';` to the top of the file that controls display stuff and it works. All my HTML code validates as XHTML 1.0 Strict, and my RSS feed validates as RSS 2.0. Can't Count Sheep works in [PulpFiction][] and [NewsFire][], so I'm happy. Still working on some metadata stuff with regards to created vs. modified dates, but those bugs should be squashed shortly.



[validhtml]: http://validator.w3.org/check?uri=referer "Valid XHTML 1.0"

[validrss]: http://feedvalidator.org/check.cgi?url=http://thiefsystems.org/ccs/feed/rss "Valid RSS 2.0"

[postel]: http://diveintomark.org/archives/2004/01/08/postels-law "There are no exceptions to Postel's Law"

[mpfeedparser]: http://feedparser.org/ "A "universal" feed parser, written in Phython, that'll read just about everything."

[ccsrss]: /ccs/feed/rss "The default RSS feed for Can't Count Sheep"

[comemail]: mailto:lmno@thiefsystems.org?subject=http://thiefsystems.org/ccs/dynamicrssfeedwoes "Comment on "Dynamic RSS feed woes""

[PulpFiction]: http://freshlysqueezedsoftware.com/products/pulpfiction/ "All the news that's fit to squeeze"

[NewsFire]: http://www.newsfirerss.com/ "Mac RSS with style"
