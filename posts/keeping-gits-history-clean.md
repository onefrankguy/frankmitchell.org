<!--
title: Keeping Git's history clean
created: 4 July 2013 - 8:01 am
updated: 4 July 2013 - 9:16 am
publish: 4 July 2013
slug: git-log
tags: coding
-->

My first exposure to [Git][] was though the command line. We kept a bare repo
running on an EC2 server and I worked locally in tmux and vim. Code reviews,
merges, and pushes happened in a terminal. When I finally encountered [Github][]
and its suite of GUI tools, I relaized I'd built my terminal world as a mimicry
of those graphical practices.

Github's GUI allows you to see commits to a repository as a graph. You can get
similar behavior from the command line with by running `git log`. The default
output for an entry looks like this.

    commit 0646b8b5d504177d9ad6c2d7a55529754efdb032
    Author: Frank Mitchell <me@frankmitchell.org>
    Date:   Tue Jun 4 09:24:43 2013 -0400

      Provides slightly more verbosity when building so I know where things are.

That's a bit of a mouthful, especially the really long commit hash. Git has a
`--oneline` option you can use to trim the output. Running `git log --oneline`
makes entries look like this.

    0646b8b Provides slightly more verbosity when building so I know where...

It's helpful to know what branch a commit is on. The `--decorate` option adds
branch names to the output. Running `git log --oneline --decorate` makes entries
look llike this.

    0646b8b (HEAD, master) Provides slightly more verbosity when building so...

If you look back at the original entry, you'll notice we've lost some metadata.
The author and date for a commit no longer show up in the log. We can roll our
own styled output with the `--pretty=tformat` option to get them back. We'll
start by duplicating what we've got. The `%h` option show short commit hashes,
the `%d` option shows branch names, and the `%s` option shows subjects. Running
`git log --pretty=tformat:'%h%d %s'` makes entries look like this.

    0646b8b (HEAD, master) Provides slightly more verbosity when building so...

The `%d` option puts a space before its output, so we don't need a space
between it an the `%h` option. Using `tformat` instead of `format` ensures the
output ends with a new line. We can add the `%aN` formatting option to get the
author's name, and the `%cr` formatting option to get the date relative to now.
Running `git log --pretty=tformat:'%h%d %s (%cr) <%aN>'` makes entries look like
this.

    0646b8b (HEAD, master) Provides slightly more... (4 weeks ago) <Frank>

We still don't have the tree output feature of Github's GUI though. Adding the
`--graph` option to our command gives us a nice ASCII aproximation.  Running
`git log --graph --pretty=tformat:'%h%d %s (%cr) <%aN>'` makes entries look
like this.

    * 0646b8b (HEAD, master) Provides slightly more verbosity when building so I know where things are. (4 weeks ago) <Frank Mitchell>
    * 7327f1c Thoughts on using trophies to motivate instead of trolls. (4 weeks ago) <Frank Mitchell>
    * f46dbed Simplifies my algorithm for finding adjacent posts. (8 weeks ago) <Frank Mitchell>
    * 8bd2f40 Computes adjacent posts instead of related ones. (8 weeks ago) <Frank Mitchell>
    * 81223e6 Provides acronym definitions for HTTP and HTTPS. (8 weeks ago) <Frank Mitchell>
    * 1a98392 Tweaks for readability. (8 weeks ago) <Frank Mitchell>
    * aa41e44 Treats tables as block level elements that flow nicely. (8 weeks ago) <Frank Mitchell>
    * 78c8988 Wraps things up with a conclusion. (8 weeks ago) <Frank Mitchell>
    * 94ba595 Fixes a broken URL. (8 weeks ago) <Frank Mitchell>
    * 5ea0dac Flushes out notes on Apache configuration. (8 weeks ago) <Frank Mitchell>


[Git]: http://git-scm.org/ "Git is a free and open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency."
[Github]: https://github.com/ ""
