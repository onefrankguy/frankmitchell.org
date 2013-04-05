<!--
title: Pairing an Apple keyboard with a Raspberry Pi
created: 5 March 2013 - 7:21 am
updated: 5 April 2013 - 8:04 am
publish: 2 April 2013
slug: apple-pi
tags: coding, hardware
-->

## Get your adapter working ##

You want to make sure the bluetooth package is installed and up to date. You'll
also need the bluez-utils package, since it provides some convenient command
line tools. Raspbian, the Raspberry Pi's OS, is Debian based, sod you can do all
this with `apt-get`.

    apt-get update
    apt-get install bluetooth
    apt-get install bluez-utils

It takes a while for the bluetooth package to install, since it's got a lot of
recommended packages. Feel free to use the "--no-install-recommends" flag with
it if you want to speed up the process. You can also install the blueman package
if you like having GUI tools to manage your devices.

    apt-get install blueman

Once everything's installed, run the `lsusb` command to make sure your bluetooh
adapter's found. If you're using a Cirago adapter, you'll see a line about a
"Cambridge Silicon Radio" device.

    lsusb | grep -i bluetooth

    Bus 001 Device 007: ID 0a12:0001
    Cambridge Silicon Radio, Ltd Bluetooth Dongle (HCI Mode)

Finally, use the `hcitool` command to search for your Apple keyboard.

    hcitool scan
