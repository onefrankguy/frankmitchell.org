<!--
title: Comment spam dies with nofollow
created: 18 January 2005 - 6:17 pm
updated: 18 January 2005 - 6:38 pm
slug: nofollow-links
tags: searching
-->

In what amounts to a fantastic move towards killing comment spam, [Google][],
[Yahoo][], [Six Apart][], and [MSN][] now all support the `rel="nofollow"`
attribute on hyperlinks. Other blog software providers, like [WordPress][], will
no doubt follow shortly.

Basically, if a search engine spider comes across the `rel="nofollow"` attribute
on one of your hyperlinks, it won't follow that link. So if your blogging
software automatically adds that attribute to all the links it accepts as input,
comment spam doesn't get followed (and thus doesn't go into the search engine).

Of course, non-spam links won't get followed either, so we're still going to
need some sort of [filter][] to separate good links from bad ones. Or we could
just let services like [Technorati][] and [Pingback][] / [TrackBack][] do that
for us.

Hat tip to [Russell Bettie][] for the info.


[Google]: http://google.com/googleblog/2005/01/preventing-comment-spam.html "Matt Cutts and Jason Shellen (Google Blog): Preventing comment spam"
[Yahoo]: http://ysearchblog.com/archives/000069.html "Jeremy Zawodny (Yahoo! Search Blog): A Defense Against Comment Spam"
[Six Apart]: http://sixapart.com/log/2005/01/support_for_nof.shtml "Ben (Six Log): Support for nofollow"
[MSN]: http://blogs.msdn.com/msnsearch/archive/2005/01/18/nofollow_tags.aspx "Ken Moss (msnsearch's Weblog): Working Together Against Blog Spam"
[WordPress]: http://wordpress.org/ "Unknown (WordPress): a state-of-the-art semantic personal publishing platform with a focus on aesthetics, web standards, and usability"
[filter]: #!/ccs/killingreferrerspam "Frank Mitchell (Can't Count Sheep): Killing referrer spam"
[Technorati]: http://technorati.com/ "Unknown (Technorati): What's happening on the Web right now"
[Pingback]: http://hixie.ch/specs/pingback/pingback "Stuart Langridge and Ian Hickson (Pingback): The Pingback specification"
[TrackBack]: http://movabletype.org/trackback/ "Unknown (Moveable Type): TrackBack Development"
[Russell Bettie]: http://russellbeattie.com/notebook/1008253.html 'Russell Bettie (Russell Bettie Notebook): rel="nofollow"'
