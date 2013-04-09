<!--
title: Pairing an Apple keyboard with a Raspberry Pi
created: 5 March 2013 - 7:21 am
updated: 9 April 2013 - 8:22 am
publish: 2 April 2013
slug: apple-pi
tags: coding, hardware
-->

## Set up your hardware ##

You'll want to plug your bluetooth adapter directly into your Raspberry Pi.
That will give you with a more reliable connection then running it off a powered
USB hub.

If your Apple keyboard's already paired with something, unpair it. Once it's
unpaired, you can turn it on and see the LED flash three times in succession.
That means your keyboard's in discovery mode and can be seen by your Pi.

Finally, you'll need to have a USB keyboard plugged into your Pi so you can
type stuff in at the command prompt.

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

    Scanning ...
    92:83:1D:BD:A9:07 Apple Wireless Keyboard

The six digit hexidecimal number that shows up is the ID for your keyboard.
Write it down, since you'll need it for the pairing process.

## Pair your keyboard ##

The `bluez-simple-agent` tool can be used to pair your Apple keyboard with your
Raspberry Pi. Give it the ID of your keyboard as an argument.

    bluez-simple-agent 92:83:1D:BD:A9:07

When you're prompted to enter a pin number, type a 4 digit numeric code into
your USB keyboard and press return. The PIN code you enter doesn't matter, so
pick something like 1234. Then type the same PIN code into your Apple keyboard
and press return.

You want your Pi to remember that your keyboard's paired with it so it will
connect to that keyboard when it boots. You can tell your Pi to trust your
keyboard with the `bluez-test-device` command.

    bluez-test-device trusted 92:83:1D:BD:A9:07

Finally, you'll need to connect your keyboard to your Pi so that it responds to
key presses. Use the `bluez-test-input` command for that.

    bluez-test-input connect 92:83:1D:BD:A9:07

Once you've got your Apple keyboard paired, trusted, and conneted, you can
unplug your USB keyboard and reboot your Pi. If your Pi doesn't immediately
pick up your Apple keyboard on boot, you can prompt it to connect my pressing
any key. The LED will flash once, and then you can type normally.
