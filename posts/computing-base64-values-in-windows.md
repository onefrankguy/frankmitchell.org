<!--
title: Base64 encoding in Ruby
created: 30 April 2013 - 8:10 pm
updated: 30 April 2013 - 8:33 pm
publish: 30 April 2013
slug: base64-ruby
tags: coding, ruby
-->

When you're signing [Amazon Web Service][] REST requests, one of the steps in
the process is to [Base64][] encode the signature. On Linux you can do this with
the `base64` command. Since I haven't found a Windows command line tool for
computing Base64 values, I rolled my own in Ruby.

    require 'base64'

    data = ARGV[0]
    if File.exists? data
      data = open(data, 'rb') { |io| io.read }
    end
    puts Base64.encode64(data)

Usage looks like:

    ruby ~/base64.rb path/to/file

Like [my tool for computing SHA-256 checksums][chef-checksums] it's got no help,
no options, and no error handling. And I use it all the time.


[Amazon Web Service]: http://aws.amazon.com/ "Various (Amazon): Amazon Web Services"
[Base64]: http://en.wikipedia.org/wiki/Base64 "Various (Wikipedia): Base64"
[chef-checksums]: /2013/02/chef-checksums "Frank Mitchell: Computing Chef checksums in Ruby"
