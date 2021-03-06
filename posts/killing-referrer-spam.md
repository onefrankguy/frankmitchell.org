<!--
title: Killing referrer spam
created: 16 January 2005 - 11:12 am
updated: 16 January 2005 - 12:08 am
slug: filter-links
tags: spam
-->

Personally, I don't find [referrer spam][rs] to be a problem. But then, I don't
look at my referrer logs either. Still, there should be an easy and elegant
solution to these sort of things. After all, it's your website; spammers have no
right to litter it with their filth.

A solution that Russell Bettie proposes, is to

> "...add the referrer spam URLs to a big table as I find them and ban future
> queries with that referrer."

He then goes on to point out that the table would grow, and page view time would
slow down as a check would have to be made with every request. That's not ideal.
Mr. Bettie also talks about simply using the table as a filter to exclude spam
URLs when searching for new referrers. But the referrers still fill up his raw
text logs, so that's not a perfect solution either.

But what if spam referrers never made it to that log file in the first place?

> "...sometimes I get caught and click through on referrer spam links, and 99%
> of the time they aren't _valid_ URLs any more. But I still keep seeing that
> link come through my logs for weeks afterwards..."

In the same way that we [automatically filter for bad links][alc] we could also
automatically filter for bad referrers. Simply ban any queries whose referrer is
an invalid link or is aimed at an invalid link. Or set up a script to scan your
log files, remove invalid links, and ban them. That way the whole solution is
automated.


[rs]: http://www.russellbeattie.com/notebook/1008250.html "Russell Beattie (Russell Bettie's Notebook): Referrer Spam"
[alc]: /2004/12/check-links "Frank Mitchell (Can't Count Sheep): Automatic link checking"
