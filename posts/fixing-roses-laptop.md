<!--
title: Fixing Rose's laptop
created: 21 December 2005 - 10:16 am
updated: 21 December 2005 - 11:27 am
slug: speed-up
tags: windows
-->

The Rose complains that her laptop is slow. I sit down to take a look.

1. Boot machine. Ten minutes later, Windows is done loading. Slowness confirmed.
2. Run msconfig. Removed useless startup items. (qttask, rundll32, ituneshelper) Reboot. Still slow.
3. Run regedit. Search for "run". Remove more useless startup items. Reboot. iTunes crashes with a Chinese error message.
4. Uninstall iTunes. Run regedit again. msniu.exe is back at startup. Delete it. Watch it add itself back. Virus.
5. Contemplate installing a real OS ([Unbuntu][]). Decide against it.
6. Get USB key with anti-virus software ([AVG][]) on it.
7. Install AVG. Watch it kill msniu.exe.
8. Install Microsoft's anti-spyware program. Girlfriend says it's best. Watch spyware die.
9. Reboot. Still slow. Look at installed programs. Lots of Norton anti-virus, internet helper, and popup blocker software there. Delete it all. Reboot. Slowness gone.
10. Contemplate installing a real web browser ([Firefox][]). Decide against it.
11. Reinstall English language version of iTunes.
12. Try to schedule disk defrag and cleanup to run semi-regularly. Access denied error. Curse CompUSA techs who "restored machine to factory settings".
13. Girlfriend helps. Access denied error gone. Defrag, cleanup, anti-virus, and spyware killer should all be automated now.
14. Reboot. Network connection slow to initialize. Really slow. Why?
15. Run HP online diagnostic. Install lots of ActiveX controls. Watch remote scripts take over machine and "test" hardware. Scary.
16. Only problems found are with HP software. Let it all autoupdate itself. No problems found. Reboot.
17. Network connection slightly faster. Decide that's good enough for now. Shut down computer.
18. Go play with SSH on my Mac.

[Unbuntu]: http://ubuntulinux.org/ "Unbuntu: A Linux distro that's usable by human beings"
[AVG]: http://free.grisoft.com/ "AVG (Grisoft): Free anti-virus software"
[Firefox]: http://www.mozilla.com/firefox/ "Firfox (Mozilla): A better web browser"
