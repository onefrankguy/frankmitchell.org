<!--
title: Picking resolutions on a Raspberry Pi
created: 14 April 2013 - 4:59 pm
updated: 16 April 2013 - 7:31 pm
publish: 16 April 2013
slug: hdmi-pi
tags: coding, pi
-->

Dig through your Raspberry Pi's boot configuration, and you'll find the
`hdmi_group` and `hdmi_mode` variables that control the screen resolution.
Setting these to a value your TV doesn't support causes your Pi to revert
to a default VGA resolution. So short of trying every possible combination,
how do you figure out which values work for your TV?

Fire up a GUI with `startx` and you find the "Monitor Settings" tool under
"Preferences" on the menu. If all you get back is an "Unable to find monitor
information!" error message, you'll have to resort to the command line.

Running `tvservice` with the "-d" flag  will spit out a binary file with
information about your TV. You can pipe that file through the `edidparser`
to get something human readable.

    /opt/vc/bin/tvservice -d edid.dat
    /opt/vc/bin/edidparser edid.dat > edid.txt

There's a lot of information there about your TV. The interesting lines contain
the word "score", and describe the mode, resolution, refresh rate, and pixel
clock rates your TV supports. You can `grep` the output to figure out if your TV
supports a particular resolution, like 1080p.

    cat edid.txt | grep score | grep 1080p

    CEA mode (32) 1920x1080p @ 24 Hz...
    CEA mode (34) 1920x1080p @ 30 Hz...

Pick the CEA mode by setting the `hdmi_mode` variable to "1" in your Pi's
`/boot/config.txt` file. Setting it to "2" will pick the DMT mode. The
`hdmi_group` variable can be set to the number in parenthesis that matches
the resolution you want. In CEA mode, 32 and 34 are both 1080p resolutions.

Once you've mode the changes, reboot your Pi to see if they work. Don't worry
if you mess things up. Your Pi will default back to a 640x480 VGA resolution if
you pick values your TV doesn't support.
