<!--
title: Three ways to chain events in Chef
created: 24 February 2013 - 1:30 pm
updated: 27 February 2013 - 3:20 am
publish: 26 February 2013
slug: chef-events
tags: coding, chef
-->

Do X, then do Y. Doing things sequentially is common in configuration
management. You have to install a package before you run a service. You have to
write a configuration file before you start a server. [Chef][] provides a lot of
flexibility when it comes to sequencing events. Here are three ways you can get
the right things to happen in the right order.

## Write it in the order you want it to run ##

Chef executes resources in the order they appear in a recipe. Coming to Chef
from [Puppet][], I found this to be a welcome surprise. Need to install the NTP
daemon and then make sure the service is started? No problem. Just put your
[service resource][] after your [package resource][].

    package 'ntp' do
      action :install
    end

    service 'ntp' do
      action :start
    end

This is the most common way to sequence events. You can tell what the control
flow is just by reading a cookbook from top to bottom.

## Notify resources about changes ##

Chef provides a notification mechanism for signaling when things change. This
lets you do things like restart a service when a configuration file changes.
Want to lay down your own NTP configuration file and bounce the service when
it's updated? Easy. Have your [template resource][] notify your
[service resource][] of the change.

    template '/etc/ntp.conf' do
      notifies :restart, 'service[ntp]'
    end

    service 'ntp' do
      action :start
    end

Something that surprised me when I first started working with Chef, was that
notifications on resources queue, then trigger at the end of the run. So the
recipe above takes the following actions:

1. Updates the template.
2. Queues a restart of the service.
3. Starts the service.
4. Restarts the service.

Sometimes you want a notification to trigger right after something changes,
instead of waiting until the end of the run. In that case, you can use the
`:immediately` flag.

    template '/etc/ntp.conf' do
      notifies :restart, 'service[ntp]', :immediately
    end

    service 'ntp' do
      action :start
    end

## Check if resources have changed ##

Chef resources are first class objects, which means you can ask them about
their state during the run. Every resource has an `updated_by_last_action?`
method which returns `true` if the resource changed. Combining this with
sequential execution lets you build robust cookbooks.

Suppose you want to download and unpack a tarball. If the folder you're
unpacking into exists, you'll want to remove it first. But if the tarball
hasn't changed, you'll want to skip that step. Download the package with
a [remote file resource][] resource, cache the result, and use the `only_if`
modifier on a [directory resource][] to skip the removal if the tarball's
unchanged.

    tarball = remote_file '~/node-v0.8.20.tar.gz' do
      source 'http://nodejs.org/dist/v0.8.20/node-v0.8.20.tar.gz'
    end

    folder = directory '~/node-v0.8.20' do
      action :remove
      only_if { tarball.updated_by_last_action? }
    end

This lets you keep the linear flow of your cookbooks, while letting future
resource take action based on what's happened in the past.


[Chef]: http://opscode.com/chef "Various (Opscode): Chef is an open-source automation platform built to address the hardest infrastructure challenges on the planet."
[Puppet]: https://puppetlabs.com/puppet/what-is-puppet/ "Various (Puppet Labs): Puppet is IT automation software that helps system administrators manage infrastructure throughout its lifecycle."
[service resource]: http://docs.opscode.com/chef/resources.html#service "Various (Opscode): The service resource is used to manage a service."
[package resource]: http://docs.opscode.com/chef/resources.html#package "Various (Opscode): The package resource is used to manage packages."
[template resource]: http://docs.opscode.com/chef/resources.html#template "Various (Opscode): The is used to manage file contents with an embedded Ruby (erb) template."
[remote file resource]: http://docs.opscode.com/chef/resources.html#remote-file "Various (Opscode): The remote_file resource is used to transfer a file from a remote location."
[directory resource]: http://docs.opscode.com/chef/resources.html#directory "Various (Opscode): The directory resource is used to manage a directory, which is a hierarchy of folders that comprises all of the information stored on a computer."
