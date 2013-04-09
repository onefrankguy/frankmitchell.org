<!--
title: Keeping Chef logs quiet
created: 9 April 2013 - 8:52 am
updated: 9 April 2013 - 9:00 am
publish: 9 April 2013
slug: shush-chef
tags: coding, chef
-->

When you run [Chef][] every ten minutes in production, your log files tend to
fill up with a lot of noise. Fortunately, the Chef client has a setting you can
use to keep things quiet. Just stick this line in your client.rb file:

    verbose_logging false

Setting verbose logging to `false` (the default value is `nil`) makes Chef only
show you what's changed on a node. Instead of seeing events like "Processing
service[nginx] start" you'll only see a log entry when the Nginx service changes
to a starting state.

[Chef]: http://opscode.com/chef "Various (Opscode): Chef is an open-source automation platform built to address the hardest infrastructure challenges on the planet."
