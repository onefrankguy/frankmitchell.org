<!--
title: Chaining events in Chef
created: 24 February 2013 - 1:30 pm
updated: 24 February 2013 - 1:30 pm
publish: 26 February 2013
slug: chef-events
tags: coding, chef
-->

Download tarball, unpack contents, execute code is a common pattern when
installing software from source. A little bit of shell scripting and you're
good to go. Here's a bash script for installing version 0.8.20 of [Node.js][].

    #!/bin/bash
    set -ex
    wget http://nodejs.org/dist/v0.8.20/node-v0.8.20.tar.gz
    tar -ozxf node-v0.8.20.tar.gz
    cd node-v0.8.20/
    ./configure --prefix=~/.local
    make
    make install

Easy, right? Sure, until you want to install a different version, or you want to
install it to another location, or you want to dynamically link against the SSL
libraries. As [Sascha Bates points out][], shell scripts are like Gremlins.

With [Chef][], this can be handled with the [remote file][] and [execute][]
resources.

    home = '/home/vagrant'

    tarball = remote_file "#{home}/node-v0.8.20.tar.gz" do
      source 'http://nodejs.org/dist/v0.8.20/node-v0.8.20.tar.gz'
    end

    folder = directory "#{home}/node-v0.8.20" do
      action :remove
      only_if do
        tarball.updated_by_last_action?
      end
    end

    execute 'tar -ozxf node-v0.8.20.tar.gz' do
      cwd home
      only_if do
        !::File.exists?(folder.name) ||
        tarball.updated_by_last_action?
      end
    end


[gremlins]: http://blog.brattyredhead.com/blog/2012/12/13/shell-scripts-are-like-gremlins/ "Sascha Bates (Bratty Redhead): Shell Scripts Are Like Gremlins"
[Chef]: http://opscode.com/chef "Various (Opscode): Chef is an open-source automation platform built to address the hardest infrastructure challenges on the planet."
[remote file]: http://docs.opscode.com/chef/resources.html#remote-file "Various (Opscode): The remote_file resource is used to transfer a file from a remote location."
[execute ]: http://docs.opscode.com/chef/resources.html#execute "Various (Opscode): The remote_file resource is used to transfer a file from a remote location."
