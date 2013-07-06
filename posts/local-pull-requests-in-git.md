<!--
title: Local pull requests in Git
created: 4 July 2013 - 8:01 am
updated: 6 July 2013 - 1:33 pm
publish: 9 July 2013
slug: git-merge
tags: coding
-->

One of [Github's][] nice features are pull requests, annotated merges between
branches that perserve commit history. When you're the only one working in a
local [Git][] repository, you notice their absence. Here's what a local
repository looks like after two commits.

    A---B master

Since you're the only one working in the repository, history marches forward in
a straight line. If you create a branch from B, and commit to it twice, you'll
get a forked history.

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


[Git]: http://git-scm.org/ "Git is a free and open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency."
[Github's]: https://github.com/ "Social coding"
