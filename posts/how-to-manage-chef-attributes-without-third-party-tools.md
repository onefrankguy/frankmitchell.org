<!--
title: How to manage Chef attributes without third-party tools
created: 27 July 2014 - 4:32 pm
updated: 28 July 2014 - 6:39 am
publish: 27 July 2014
slug: chef-attributes
tags: coding, chef
-->

Your phone alarm just went off at 3:00 am. Nagios is reporting out of memory
errors in the JVM your application's running on. Tired fingers poke your laptop
to wake it up. A blank zsh terminal with a Git prompt reflects your blinking
eyes.

    cd chef/cookbooks
    git checkout master
    git fetch --all
    git merge origin/master

You are pretty sure the JVM memory settings are in `app.jvm.heap_size`. But
you're not sure where to put that. Does it goe in the environment? In one of
the cookbooks? What precedence should you use? A quick trip to Google digs up
the Chef attribute precedence chart.

<table style="text-align: center; background: #fff; border: 1px solid #ccc; text-align: center; border-collapse: collapse">
<tr>
  <th></th>
  <th style="padding: 0 0 0.5em 0.125em"><span style="background: #7c858c; color: #fff; font-weight: normal; padding: 0.25em 0.5em">Attribute Files</span></th>
  <th style="padding: 0 0 0.5em 0.125em"><span style="background: #7c858c; color: #fff; font-weight: normal; padding: 0.25em 0.5em">Node / Recipe</span></th>
  <th style="padding: 0 0 0.5em 0.125em"><span style="background: #7c858c; color: #fff; font-weight: normal; padding: 0.25em 0.5em">Environment</span></th>
  <th style="padding: 0 0 0.5em 0.125em"><span style="background: #7c858c; color: #fff; font-weight: normal; padding: 0.25em 0.5em">Role</span></th>
</tr>
<tr>
  <th style="border-bottom: 0.0625em solid #dee0e2; padding: 0 0.5em 0 0"><span style="background: #b5bec6; color: #fff; text-align: right; font-weight: normal; display: inline-block; width: 100%; margin: 0; padding: 0 0.5em 0 0">default</span></th>
  <td style="border-bottom: 0.0625em solid #dee0e2; padding: 0.25em 0"><span style="background: #61a0cc; color: #fff; padding: 0.25em 0.5em">1</span></td>
  <td style="border-bottom: 0.0625em solid #dee0e2; padding: 0.25em 0"><span style="background: #61a0cc; color: #fff; padding: 0.25em 0.5em">2</span></td>
  <td style="border-bottom: 0.0625em solid #dee0e2; padding: 0.25em 0"><span style="background: #61a0cc; color: #fff; padding: 0.25em 0.5em">3</span></td>
  <td style="border-bottom: 0.0625em solid #dee0e2; padding: 0.25em 0"><span style="background: #61a0cc; color: #fff; padding: 0.25em 0.5em">4</span></td>
</tr>
<tr>
  <th style="border-bottom: 0.0625em solid #dee0e2; padding: 0 0.5em 0 0"><span style="background: #b5bec6; color: #fff; text-align: right; font-weight: normal; display: inline-block; width: 100%; margin: 0; padding: 0 0.5em 0 0">force_default</span></th>
  <td style="border-bottom: 0.0625em solid #dee0e2; padding: 0.25em 0"><span style="background: #61a0cc; color: #fff; padding: 0.25em 0.5em">5</span></td>
  <td style="border-bottom: 0.0625em solid #dee0e2; padding: 0.25em 0"><span style="background: #61a0cc; color: #fff; padding: 0.25em 0.5em">6</span></td>
  <td style="border-bottom: 0.0625em solid #dee0e2"></td>
  <td style="border-bottom: 0.0625em solid #dee0e2"></td>
</tr>
<tr>
  <th style="border-bottom: 0.0625em solid #dee0e2; padding: 0 0.5em 0 0"><span style="background: #b5bec6; color: #fff; text-align: right; font-weight: normal; display: inline-block; width: 100%; margin: 0; padding: 0 0.5em 0 0">normal</span></th>
  <td style="border-bottom: 0.0625em solid #dee0e2; padding: 0.25em 0"><span style="background: #61a0cc; color: #fff; padding: 0.25em 0.5em">7</span></td>
  <td style="border-bottom: 0.0625em solid #dee0e2; padding: 0.25em 0"><span style="background: #61a0cc; color: #fff; padding: 0.25em 0.5em">8</span></td>
  <td style="border-bottom: 0.0625em solid #dee0e2"></td>
  <td style="border-bottom: 0.0625em solid #dee0e2"></td>
</tr>
<tr>
  <th style="border-bottom: 0.0625em solid #dee0e2; padding: 0 0.5em 0 0"><span style="background: #b5bec6; color: #fff; text-align: right; font-weight: normal; display: inline-block; width: 100%; margin: 0; padding: 0 0.5em 0 0">override</span></th>
  <td style="border-bottom: 0.0625em solid #dee0e2; padding: 0.25em 0"><span style="background: #61a0cc; color: #fff; padding: 0.25em 0.5em">9</span></td>
  <td style="border-bottom: 0.0625em solid #dee0e2; padding: 0.25em 0"><span style="background: #61a0cc; color: #fff; padding: 0.25em">10</span></td>
  <td style="border-bottom: 0.0625em solid #dee0e2; padding: 0.25em 0"><span style="background: #61a0cc; color: #fff; padding: 0.25em">11</span></td>
  <td style="border-bottom: 0.0625em solid #dee0e2; padding: 0.25em 0"><span style="background: #61a0cc; color: #fff; padding: 0.25em">12</span></td>
</tr>
<tr>
  <th style="border-bottom: 0.0625em solid #dee0e2; padding: 0 0.5em 0 0"><span style="background: #b5bec6; color: #fff; text-align: right; font-weight: normal; display: inline-block; width: 100%; margin: 0; padding: 0 0.5em 0 0">force_override</span></th>
  <td style="border-bottom: 0.0625em solid #dee0e2; padding: 0.25em 0"><span style="background: #61a0cc; color: #fff; padding: 0.25em">13</span></td>
  <td style="border-bottom: 0.0625em solid #dee0e2; padding: 0.25em 0"><span style="background: #61a0cc; color: #fff; padding: 0.25em">14</span></td>
  <td style="border-bottom: 0.0625em solid #dee0e2"></td>
  <td style="border-bottom: 0.0625em solid #dee0e2"></td>
</tr>
<tr>
  <th style="border-bottom: 0.0625em solid #dee0e2; padding: 0 0.5em 0 0"><span style="background: #b5bec6; color: #fff; text-align: right; font-weight: normal; display: inline-block; width: 100%; margin: 0; padding: 0 0.5em 0 0">automatic</span></th>
  <td style="border-bottom: 0.0625em solid #dee0e2; padding: 0.25em 0" colspan="4"><span style="background: #61a0cc; color: #fff; padding: 0.25em">15</span></td>
</tr>
</table>

You blink. There are fifteen different places you can set the heap size. It's
3:10 am. You are way too tired to figure this out. So you punch speed dial on
your phone and escalate the issue.

## Attribute precedence is confusing ##

Spend any amount of time with Chef and you'll eventually run into attribute
precedence problems. As Clinton Wolfe points out in ["Our Experiences with Chef:
Cookbook and Attribute Design"][omniti], attributes are hard to track down.

> "Most frustrations I hear from both developers and operations engineers
> concern the difficulty of tracing an attribute...what we want to know is...
> which files are overwriting - or overriding - the value?"


[omniti]: http://omniti.com/seeds/seeds-our-experiences-with-chef-cookbook-and-attribute-design "Clinton Wolfe (OmniTI): Our Experiences with Chef - Cookbook and Attribute Design"
