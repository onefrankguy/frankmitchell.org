<!--
title: Keeping Git's history clean
created: 4 July 2013 - 8:01 am
updated: 6 July 2013 - 12:53 pm
publish: 4 July 2013
slug: git-log
tags: coding
-->

My first exposure to [Git][] was though the command line. We kept a bare repo
running on an EC2 server and I worked locally in tmux and vim. Code reviews,
merges, and pushes happened in a terminal. When I finally encountered [Github][]
and its suite of GUI tools, I relaized I'd built my terminal world as a mimicry
of those graphical practices.


## Faking local pull requests ##

One of Github's nice features are pull requests, annotated merges between
branches that perserve commit history. When you work with local branches in Git,
you'll notice their absence. Here's what a local repository looks like after two
commits.

    A---B master

If you create a branch from B, and commit to it twice, you'll get a forked
history.

          C---D branch
         /
    A---B------ master

When you merge the branch back to master, an optimization takes place. Git
notices no chnanges to master since the branch was created, so it collapses the
history of the branch. This is called a fast forward merge.

    A---B---C---D master

Fast foward merges create the illusion that all the work happened in the master
branch. If you want to perserve the record that work happend in a branch, you
can pass the "--no-ff" flag to the merge command.

          C---D
         /     \
    A---B-------E master

This leaves an additional commit in the history when the branches come back
together. This extra commit is called a "merge commit". When you close a pull
request on Github, it's perserving the record that work happend in a branch by
doing a merge without fast forwarding. To make it easier to remember to add the
"--no-ff" flag when you merge branches, you can alias `git merge --no-ff` to
`git mg`.

    git config --global alias.mg 'merge --no-ff'

The above command adds an alias to your ~/.gitconfig file for the "mg" command.

    [alias]
    mg = merge --no-ff

## Viewing history as a graph ##

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

    * 9fbf727 (HEAD, git-log) Notes on how to make... (4 minutes ago) <Frank>
    * 0646b8b (master) Provides slightly more verbosity... (4 weeks ago) <Frank>


[Git]: http://git-scm.org/ "Git is a free and open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency."
[Github]: https://github.com/ ""
