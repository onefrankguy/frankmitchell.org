<!--
title: What's your definition of done?
created: 21 March 2013 - 8:22 am
updated: 24 March 2013 - 12:21 pm
publish: 26 March 2013
slug: defining-done
tags: coding, writing
-->

My personal definiton of done is that you can use it now, and you won't ask
me questions about it for at least a week.

For client projeccts, this means the interface is intuitive enough to be
self expanatory (a rare case) or that documentation is included with the
product. For server side pieces, it means backup and deployment solutions
are in place so I can easily fix things should something break. In both cases,
it means I've done enough personal QA and stress testing to know what I'm
handing you is a robust piece of engineering.

The second part of the definition, the notion of a week without interruption,
is important. It means that you as a customer have gone beyond the "Is the
something I want?" cursory look at the product and are actively engaging with
it on a day-to-day basis. It means I've gathered enough research and asked
enough questions about what it is that you want, to be able to craft a solution
that brings you joy.

In _The Art of Agile_, James Shore calls this state "[done done][]".

> A story is only complete when on-site customers can use it as they intended.
> In addition to coding and testing, completed stories are designed, refactored,
> and integrated. The build script builds, installs, and migrates data for the
> story. Bugs have been identified and fixed (or formally accepted), and
> customers have reviewed the story and agree it's complete.

In practice, I've found the process of solving a problem represents about 75% of
the effort I put into getting something to done. But it only comprises 25% of
the time it takes to get there. Going the rest of the way, writing the
documentation, integrating customer feedback, working through the testing
matrix, requires a lot more time and a lot less effort.

Looking back at [my commit history for Mentat][], it took me 3 days to get the
game to a playable state, 4 to get it polished enough for the
[js13kGames competition][], and a further 5 before I was comfortable calling it
done. Most of the polish work was around cross browser compatability, code
styling conventions, and fixing spelling mistakes in the documentation. None of
that work stopped me from shipping, and I think that's one of the reasons
projects don't make it to done.

Polish work doesn't hold up the train.


[done done]: http://www.jamesshore.com/Agile-Book/done_done.html "James Shore (The Art of Agile Development): Done Done"
[my commit history for Mentat]: https://github.com/onefrankguy/mentat/commits/master "Frank Mitchell (GitHub): Commit history for mentat"
[js13kGames competition]: http://js13kgames.com/ " Andrzej Mazur (js13kGames): HTML5 and JavaScript game development competition in just 13 kilobytes"
