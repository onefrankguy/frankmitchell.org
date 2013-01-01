<!--
title: Filtering tagged spaces
created: 28 December 2004 - 10:40 am
updated: 31 December 2004 - 5:24 pm
slug: tag-ui
tags: searching
-->

## Word to the hurried ##

If you don't want to read this entire essay to figure out what I was thinking,
just play with the menu on your right. Click a few things, and watch the
tool-tips that pop up when you hover over a word.

The implementation should explain itself.

## Buried in a sea of tags ##

As applications like [Furl][], [Flickr][], and [del.icio.us][] become more
popular, so does the concept of tagging information. But problems arise when we
have too many tags. I've only been using del.icio.us for a short while, but I've
already got 50+ different tags for [my bookmarks][]. Mr. Vander Wal's been using
it longer, and [he's got 250+ tags][]. That's way too many tags to be useful.

So what do we do about it?

Well, we really have three solutions:

1. account for human error
2. reduce tags to their most basic morphemes
3. equate like tags

First, I think we need to account for the fact that no one's perfect and people
are going to misspell stuff when they tag it. So our software has to be aware
that "folkonomy" and "folksonomy" are the same word. A fuzzy search, like
`agrep`, would probably work. However, a [livesearch][] option might work
better. If tags were auto-completed for us as we typed, it would reduce the
possibility of misspelled tags.

Second, we need to shorten our tags so they just convey the concept we want
conveyed and nothing else. The word "cat" is one morpheme. The word "cats" is
two: "cat" and 's'. The 's' denotes plurality, but do we really need plurality
when we're searching a tagged space? Do we really care if we see one cat or
multiple cats? Probably not. It doesn't matter whether we choose to use "cat" or
"cats", so long as we're consistent within our personal information space.

Finally, our software needs to understand that "km" and "knowledge management"
are the same tag. One is just an abbreviation for the other. Likewise, "ny" is
"new york" and "newyork".

The beauty of these three solutions is that they can each be represented the
same way in code.

	folkonomy = folksonomy
	cat = cats
	km = "knowledge management"

It's a solution that both humans and computers can immediately understand, and
more importantly, that humans can easily interact with and change as needed.

## Shrinking the number of tags viewable ##

But even if we account for misspellings, redundant tags, and acronyms, we're
going to be overwhelmed by the sheer volume of tags available. So what if we
filtered the number of tags shown?

Let the user pick a tag they want to use as a filter. Now the only tags
available to them should be ones that relate to the tag they just picked. They
shouldn't be able to select the tags "writing" and "deserts" if there are no
items in the system that match that combination.

We only need to show the user the information that's useful to them, and we can
guess what that information's going to be based on the user's previous actions.

## Ninety-percent is good enough ##

But what do we do about the first tag picked? We obviously don't want to show
the user every possible tag. Having to pick from a list of 100+ tags is going to
drive them nuts.

Instead, let's filter tags based on their percent contribution to the
information space.

If a tag has been applied to a certain percentage of items, it's obviously
significant. What that percentage is, of course, depends on the system and the
content. But because it will scale as the system grows and the number of items
in it increases, the initial tag list should always reflect the most "popular"
tags and thus the majority of the items available.

Because there will be an overlapping of tags between items, we're almost
guaranteed that there will be a path from a starting tag to any item in our
system. Of course, our algorithm could be refined to ensure that was the case.
Something along the lines of: "pick the smallest number of tags that include all
items in the information space".

Either way you cut it, the user still sees a large piece of the pie without
being overwhelmed by the fact that there are fifty different ingredients in it.

## A real world example ##

The menu on the right implements the kind of system described above. Go ahed and
play with it. Clicking a tag selects it as a filter. Clicking that same tag
again deselects it. Once a tag(s) has been clicked, the only tags that are
clickable are the ones that relate to the selected tag(s).

And of course, the initial list of tags is based on percent contribution. If a
tag's been applied to more than 5% of the writings on this site, than it's
considered significant enough to be on that initial menu.

It ends up being a lot easier to use than it is to explain in words, and I'm
pretty sure that's a good thing.

[Furl]: http://furl.net/ "Looksmart's Furl: Your Personal Web"
[Flickr]: http://flickr.com/ "Flickr: Photo Sharing"
[del.icio.us]: http://del.icio.us/ "del.icio.us: social bookmarks"
[my bookmarks]: http://del.icio.us/elimossinary "Frank Mitchell (del.icio.us): elimossinary"
[he's got 250+ tags]: http://del.icio.us/vanderwal "Thomas Vander Wal (del.icio.us): vanderwal"
[livesearch]: http://blog4.bitflux.ch/wiki/LiveSearch "Bitflux Blog Wiki: LiveSearch"
[writing]: #!/ccs/tags/writing "Frank Mitchell (Can't Count Sheep): writing"
