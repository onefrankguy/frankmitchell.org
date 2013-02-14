<!--
title: Computing Chef checksums in Ruby
created: 14 February 2013 - 5:23 pm
updated: 14 February 2013 - 5:44 pm
publish: 18 February 2013
slug: chef-checksums
tags: coding, chef
-->

When dealing with [remote files][], [Chef][] uses [SHA-256][] checksums to
avoid redownloading files that haven't changed. Since I haven't found a Windows
command line tool for computing SHA-256 checksums, I rolled my own in Ruby.

    require 'digest'

    path = ARGV[0]
    if File.exists? path
      puts Digest::SHA256.file(path).hexdigest
    end

Usage looks like:

    ruby ~/sha256.rb path/to/file

No help, no options, no error handling. I use it all the time.


[remote files]: http://docs.opscode.com/chef/resources.html#remote-file "Various (Opscode): The remote_file resource is used to transfer a file from a remote location."
[Chef]: http://opscode.com/chef "Various (Opscode): Chef is an open-source automation platform built to address the hardest infrastructure challenges on the planet."
[SHA-256]: http://en.wikipedia.org/wiki/SHA-2 "Various (Wikipedia): SHA-2"
