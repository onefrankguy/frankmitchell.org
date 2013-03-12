<!--
title: Templates vs. cookbook files in Chef
created: 12 March 2013 - 6:12 pm
updated: 12 March 2013 - 7:37 pm
publish: 12 March 2013
slug: chef-templates
tags: coding, chef
-->

Once of the questions I ask myself when writing [Chef][] code is,
"Should I use a [template resource][] here, or a [cookbook file][]?"

My first thought was to use the resource like it was intended. If I needed to
modify the file's contents, I'd use a template. If the contents where static,
I'd use a cookbook file. So anything in the /etc/rsyslog.d/ folder was a
template, while the /etc/rsyslog.conf file itself was a cookbook file.

This worked for a little while, like three months and ten cookbooks. Six months
and 40 cookbooks later, things started getting out of hand. I found I was having
to convert cookbook files over to templates as I found new parts that needed
customizing. Plus, it got hard to remember if a particular default setting was
in a cookbook file or a template.

For now, I've settled on a simple rule of thumb. If it's ASCII, it's a template.
If it's binary, it's a cookbook file. This keeps everything text together where
I can reference it, and simplifies making changes when that need arrises.


[Chef]: http://opscode.com/chef "Various (Opscode): Chef is an open-source automation platform built to address the hardest infrastructure challenges on the planet."
[template resource]: http://docs.opscode.com/chef/resources.html#template  "Various (Opscode): The template resource is used to manage file contents with an embedded Ruby (erb) template."
[cookbook file]: http://docs.opscode.com/chef/resources.html#cookbook-file "Various (Opscode): The cookbook_file resource is used to transfer files from a sub-directory to a specified path on the host."
