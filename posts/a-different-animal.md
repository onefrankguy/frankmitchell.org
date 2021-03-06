<!--
title: A different animal
created: 29 October 2004 - 8:20 pm
updated: 14 November 2004 - 8:11 am
slug: blog-engine
tags: elimossinary
-->

## Because it came up in conversation ##

Andrew and I were chatting via IM the other day, and he asked me why I wrote my
own blogging software instead of using my [LiveJournal][] account. Well, there
are a couple of reasons. First and foremost is that I wanted something that was
easy to use. Personally, I think web interfaces are total crap when it comes to
writing stuff for the web. They don't do spell checking (not that
[SubEthaEdit][] does either, mind you), but there's also no note taking
features, no link management, no automagical expansion of accronyms, etc.

My text editor should abstract all that stuff away from me so I can concentrate
on what I do best, write. That's why Elimossinary files are written in
[Markdown][], so that it becomes super easy to read and edit them.

## Features other tools don't have ##

Part of the inspiration behind Elimossinary was [NewsFire][]. NewsFire is, as
its name implies, a dynamic RSS reader for Mac OS X. As new news items appear,
they bubble up your lists of feeds, so the most recently updated items are
always at the top. At the moment, the [index page][ccs] on Can't Count Sheep
does something similar.

You can sort posts by either their creation or modification dates, and you can
specify the number of posts you want to see. Clicking [here][ccscreated] sorts
post be creation date. Clicking [here][cssmodified] sorts posts by modification
date. Appending a number onto either of those URLs shows you that many posts
i.e. [#!/ccs/index/created/4][numberdemo]. Appending 'all' shows you all posts.

Eventually, I'd like to do the same thing for the RSS feed and the archive
page(s) once I get them up and running.

## Seeing beyond the horizon ##

Elimossinary has the very nice feature of being able to expand acronyms
automagically. For example, when I type 'PHP' in this file, Elimossinary knows
to wrap that string in an `<acronym>` tag and give it the `title` attribute of
'PHP Hypertext Preprocessor'. It's just a little trick that makes my life a
little easier.

One goal I've got in mind, is to expand that functionality to work on hyperlinks
as well. [del.icio.us][] is a very nice piece of bookmark management software
that lets me get an XML list of all my bookmarks (and thier metadata) via a URL.
If I feed that list to Elimossinary, it should be able to keep the `alt`
attribute on all my links consistant, as well as provide me with backlinks to
posts that reference a particular link.

## Falling into the pit of despair ##

Of course, this isn't all sunshine and roses. Elimossinary has to rebuild
metadata about a file every time that file changes. That chews up CPU cycles.
Fortunately, they're chewed up on my PowerBook rather than on the [Modwest][]
server that hosts Can't Count Sheep. Still, it's a little bit of a hassel and
the process could definately be streamlined.

But that's a future goal. Right now, this is what you get, and behind the scenes
I'm going to be working on getting some of my older stuff into the new system.

## 14 November 2004 ##

> "Just wanted to let you know that [SubEthaEdit][]'s spell checking can be
> enabled in Edit/Spelling/. That's were Mac OS X applications typically have
> the spell checking options."
>
> [Martin Pittenauer][]

[LiveJournal]: http://livejournal.com/ "A simple-to-use personal publishing ("blogging") tool that's focused on community."
[SubEthaEdit]: http://www.codingmonkeys.de/subethaedit/ "Collaborative text editing. Share and Enjoy."
[Markdown]: http://daringfireball.net/projects/markdown/ "A text-to-HTML converstion tool for web writers"
[NewsFire]: http://www.newsfirerss.com/ "Mac RSS with Style."
[ccs]: #!/ccs/index "CCS: Index."
[ccscreated]: #!/ccs/index/created "CCS: Sort posts by creation date."
[cssmodified]: #!/ccs/index/modified "CCS: Sort posts by modification date."
[numberdemo]: #!/ccs/index/created/4 "CCS: Show the last four created posts."
[del.icio.us]: http://del.icio.us/ "Social bookmarking software"
[Modwest]: http://modwest.com/ "The best web hosting company in the business"
[Martin Pittenauer]: http://codingmonkeys.de/map/log/ "Martin Pittenauer (co-founder of TheCodingMonkeys): 0x2a"
