<!--
title: How to do one time setup with Chef
created: 5 August 2014 - 7:44 am
updated: 5 August 2014 - 9:00 pm
publish: 5 August 2014
slug: chef-runonce
tags: coding, chef
-->

Some applications require running special commands when you're first configuring
them. For example, [PostgreSQL][] requires you run `initdb` to create the
initial database. When you wrap things up in configuration management software
like Chef, it can be tricky to get one time setup stuff correct. You want it
to run the first time the application's installed, but never again after that.

Before you start writing recipe code, it's helpful to step back and ask yourself
"How would I solve this without Chef?" There's a whole lot of acumulated
sysadmin lore built out of bash scripts and best practices. Solve your problem
without Chef first, and you'll end up with a better solution when you translate
it into a Chef recipe.

The canonical bash solution for "Run this command once and only once" is to test
for the existance of a lock file, and if it doesn't exist create it and run the
command. That code usually looks something like this:

    #!/bin/bash

    if [ ! -f lockfile ];
    then
      touch lockfile
      initdb -D data
    fi;

Looking at the code, it's obvious the end goal is the execution of `initdb`.
Chef provides an [execute resource][] that's a nice abstraction on top of the
idea of running a command. The usual way to guard against an execute resource
running more than once is with the `not_if` and `only_if` attributes.
Translating that bash script into a Chef recipe makes it look like this:

    execute 'initdb' do
      command 'touch lockfile && initdb -D data'
      not_if 'test -f lockfile'
    end

Unfortunately, there's one potential flaw with that Chef recipe. What if the
`touch` and `test` executables don't exist? "But this is Liunx, of course they
exist!" you cry. Well, it's Linux right now. What if it's Windows later? Chef
works best when you do as much as possible in Chef. Don't worry about OS
specific details. Let Chef handle those for you.

The `touch` and `test` commands are really just a way to create a file if it
doesn't already exist. Chef has a [file resource][] that can do that. You also
want to trigger the execution of the `initdb` commmand if the file gets created.
Chef has notification events that can handle that. Incorporating those ideas
into the recipe makes it look like this:

    file 'lockfile' do
      action :create_if_missing
      notifies :run, 'execute[initdb]', :immediately
    end

    execute 'initdb' do
      command 'initdb -D data'
      action :nothing
    end

Setting the `action :nothing` attribute on the execute resource ensure it only
runs when the notification triggers it. Setting the `action :create_if_missing`
attribute on the file resource ensures it only runs if the file doesn't exist.
The end result is a one time setup command in Chef.

If you find yourself using this pattern a lot, especially if you're triggering
multiple things off the same lock file, you may find that [switching away from
notification events][chain] makes your code easier to read and reason about.


[PostgreSQL]: http://www.postgresql.org/docs/9.3/static/app-initdb.html "PostgreSQL: initdb - create a new PostgreSQL database cluster"
[execute resource]: http://docs.getchef.com/resource_execute.html "Chef Software: Use the execute resource to execute a command"
[file resource]:http://docs.getchef.com/resource_file.html "Chef Software: Use the file resource to manage files that are present on a node"
[chain]: /2013/02/chain-events "Frank Mitchell: Three ways to chain events in Chef"
