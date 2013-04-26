<!--
title: Care and feeding of a Raspberry Pi
created: 25 April 2013 - 8:57 pm
updated: 25 April 2013 - 9:16 pm
publish: 2 April 2013
slug: healthy-pi
tags: coding, pi
-->

Out of the box, a [Raspberry Pi][] can feel a little daunting, especially if
you're new to Linux. Here's what you need to know to keep your Pi happy and
healthy.

## Keep your software up to date ##

There are two schools of thought about keeping Linux distros up to date.

1. Install updates as you need them.
2. Update everything all the time.

The second option tends to be a easier, since you can automate it. Since
Raspbian is a Debian distro, you can use `apt-get` to update it. Fire up
a command prompt and run the following commands to trigger a manual update
of all the software on your Pi.

    sudo apt-get update
    sudo apt-get upgrade

## Turn off services you're not using ##

The `rcconf` tool will give you a peek at all the services running on your
Raspberry Pi. Install it with `apt-get` and then start it up.

    sudo apt-get install rcconf
    sudo rcconf

Use the arrow keys to navigate the list and the space bar to toggle services on
and off. When you're happy with your changes, tab over to "Ok" and press return.
You might see some warnings about run level arguments not matching up. Feel free
to ignore those. They just mean the syntax in the service's configuration is a
little behind the times.

Turning off `avahi-daemon`, `cups`, `nfs-common`, `rpcbind`, `rsync`, and
`triggerhappy` is a good starting point.
