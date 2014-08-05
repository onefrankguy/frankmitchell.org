<!--
title: How to do one time setup with Chef
created: 5 August 2014 - 7:44 am
updated: 5 August 2014 - 6:29 pm
publish: 5 August 2014
slug: chef-initdb
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

The canonical bash solution for "Run this command once" is to test for the
existance of a lock file, and if it doesn't exist create it and run the command.
That code usually looks something like this.

    #!/bin/bash

    if [ ! -f lockfile ];
    then
      touch lockfile
      initdb -D data
    fi;


    execute 'initdb' do
      command 'touch lockfile && initdb -D data'
      not_if 'test -f lockfile'
    end


    execute 'initdb' do
      command 'touch lockfile && initdb -D data'
      not_if { ::File.exists? 'lockfile' }
    end


    file 'lockfile' do
      action :create_if_missing
      notifies :run, 'execute[initdb]', :immediately
    end

    execute 'initdb' do
      command 'initdb -D data'
      action :nothing
    end


[PostgreSQL]: http://www.postgresql.org/docs/9.3/static/app-initdb.html "PostgreSQL: initdb - create a new PostgreSQL database cluster"
