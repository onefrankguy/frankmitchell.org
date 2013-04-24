<!--
title: Trimming Chef's memory use
created: 24 April 2013 - 5:43 am
updated: 24 April 2013 - 6:28 am
publish: 23 April 2013
slug: small-chef
tags: coding, chef
-->

Leave [Chef][] running long enough, and you'll probably run into an out of
memory error. The error message that shows up in the stack trace can be a bit
cryptic. Usually it's something about an inability to spawn an external process.

Poor logic in one of your cookbooks is the root cause, and there are two things
you can do to help mitigate the problem while you track down its source.

First, make sure you're running Chef with [Ruby 1.9][]. Version 1.8
[has been sunsetted][], and won't be accepting new fixes after June. If you're
on Ubuntu, you can run `apt-get` to get it installed.

    apt-get install build-essential
    apt-get install ruby1.9.1-full

Second, have Chef fork a new process when it makes a run. Passing the "--fork"
flag to the [chef-client][] keeps recipe convergence contained in a secondary
process with dedicated RAM. When the run finishes, the memory will be returned
to the OS. Forking child processes was added in Chef 10.14. You can run `gem` to
get the latest 10.x version installed.

    gem install chef --version '> 10.0'

Running an up to date version of Ruby and having Chef fork a child process
will get your memory usage back down. After that, you just have to track down
the cookbook that's causing the leak.


[Chef]: http://opscode.com/chef "Various (Opscode): Chef is an open-source automation platform built to address the hardest infrastructure challenges on the planet."
[Ruby 1.9]: http://ruby-lang.org/ "Various (Ruby): Ruby is a  programmer's best friend"
[has been sunsetted]: http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-dev/47201 "Urabe Shyouhei (ruby-dev): Conclusion of 1.8.7 to be expected this June"
[chef-client]: http://docs.opscode.com/chef_client.html "Various (Opscode): A chef-client is an agent that runs locally on every node that is registered with the Chef Server."
