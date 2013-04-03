<!--
title: Building rebuildable build machines
created: 21 March 2013 - 5:50 pm
updated: 21 March 2013 - 5:50 pm
publish: 2 April 2013
slug: reproducable-builds
tags: coding, ruby
-->

Ship enough software, and you'll come across the question "How do we
rebuild it?" This usually happens right after the DVD's gone gold master,
when the build machine crashes, and QA finds a really nasty bug that requires
you get a fix out as soon as possible.

Getting the source back at the version that went out usually isn't too bad.
Stamping the commit identifier into a text file that gets injected into the
installer is a pretty simple process. Dropping a tag in source control with
the version number when it's built is a one line command. Either one works.

But what do you do when the build machine crashes? How do you recover all the
tools and versions and license files and custom bits of code that wind up
there over the course of a project?

You keep your code in source control. Why not keep your build files there
as well?

I know, you're doing this already. You've got your Visual Studio project checked
in there. Plus those third party libraries you use. But what about Visual Studio
itself? You're still on the 2010 version right? Plus there's that series of
knowledge base patches you had to apply to get it to work with your graphics
card drivers. And IncrediBuild, and Visual Assist X, you've got some custom
MSBuild tasks that use those too.

Fortunately, you can get around most of this uncertainty with Chef and GitHub.

Chef Solo has the ability to install a set of cookbooks from a tarball hosted
on a remote URL. GitHub has the ability to serve up a repo as a tarball. Put
those two together, and you can version and track your build environment with
every copy of your software that ships.

The first step is to move all your Chef cookbooks to their own GitHub repo. I
know, you've got them mixed in with the JSON files for your roles and
environments. Split those out and give the cookbooks their own repository.

This second step is to run Chef Solo at the start of every build. Create a
JSON file that lists out all the cookbooks you need to run to set up a build
environment.

    {
      "run_list": [
        "visual-studio",
        "kb-patch-1",
        "kb-patch-2",
        "incredibuild",
        "visual-assist-x"
      ]
    }

Pass the "-j" flag to Chef Solo to feed it the JSON file. The "-r" flag
will tell it where on GitHub to find your cookbooks.

    chef-solo -j build.josn -r https://github.com/repo/tarball/master
