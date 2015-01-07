<!--
title: How to manage Chef attributes without third-party tools
created: 27 July 2014 - 4:32 pm
updated: 29 July 2014 - 6:39 am
publish: 12 August 2014
slug: chef-precedence
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

This is not an easy problem. Attributes can be set in cookbooks, reset in
environments, forced in recipes, overwitten in roles, toggled in nodes, and
then obliterated automatically. By the time an attribute gets written out
to a template, it's almost impossible to trace the code path that put it
there. Good luck figuring out what code to edit to change it.

Eventually you end up looking at source control history to figure out who
changeded what when, hoping that gives you a clue about who you need to
go talk to to figure things out. But combing through a change log looking
for commits about JVM memory settings isn't a fun way to spend an afternoon.

Well written READMEs don't help, since they typically only document a
single cookbook. Unless you're anal about writing down everything about your
environment and infrastructure there's not going to be a document that says,
"If you need to set X, edit Y." And documentation's always one of those
things that gets pushed off onto the backlog.

What you really want is a magic piece of documentation that stays up to date
as things change. Kind of like your code does.

## Stop fighting the precedence hierarchy ##

The problem with Chef's attribute precedence is not that there are fifteen
levels of it. The problem is that you're trying to use all fifteen of them.
It's pretty much established that you can hold five, plus or minus two, bits
of information in short term memory. Which is why U.S. phone numbers are seven
digits long. Attribute precedence is confusing because it has more than five
levels. So restrict yourself to just using five levels.

But which five levels? Well the automatic one is a given because you can't get
rid of it. So that leaves you four to pick from. Ignore how Chef models things
for a minute and think about what it is you're trying to configure.

You have an application (HAProxy) that provies a service (load balancing) in an
environment (production) on a server (EC2 instance). That's a pretty simple
four step model.

1. Applications
2. Services
3. Environments
4. Servers


[omniti]: http://omniti.com/seeds/seeds-our-experiences-with-chef-cookbook-and-attribute-design "Clinton Wolfe (OmniTI): Our Experiences with Chef - Cookbook and Attribute Design"
[roles]: /2014/07/chef-roles "Frank Mitchell: The quick, easy way to version Chef roles"
