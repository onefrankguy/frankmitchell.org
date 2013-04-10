<!--
title: Keeping Chef logs quiet
created: 9 April 2013 - 8:52 am
updated: 10 April 2013 - 8:12 am
publish: 9 April 2013
slug: shush-chef
tags: coding, chef
-->

When you're looking at [Chef][] logs in production, there are a handful of
things you care about.

1. Which recipes are running?
2. What changed since the last run?
3. Did anything break?
4. How long did the run take?

Chef shows you those things out of the box, but there's a lot of noise mixed
in. When you're running Chef every ten minutes on every server, logs fill up
fast with with information about state that hasn't changed.

Fortunately, the Chef client has a setting you can use to keep things quiet.
Just stick these lines in your client.rb file:

    log_level :info
    verbose_logging false

Keeping the log level at INFO means Chef will still show you the run list for
the node and how long the run took. Plus, you'll see custom messages your
recipes output with the [log resource][].

Setting verbose logging to `false` (the default value is `nil`) means Chef will
only show you what's changed on a node during that run. Instead of seeing events
like "Processing service[nginx] start" you'll only see a log entry when the
Nginx service changes to a starting state.

Trimming your Chef logs down to show you just what's changed on a server also
makes it easier to set up [LogStash][] filters that alert on abnormalities.
Instead of having to [grep][] and [grok][] around the noise, you can cut right
to the chase.

Logs become a lot more useful when they only show you the things you care about.


[Chef]: http://opscode.com/chef "Various (Opscode): Chef is an open-source automation platform built to address the hardest infrastructure challenges on the planet."
[log resource]: http://docs.opscode.com/resource_log.html "Various (Opscode): The log resource is used to create log entries from a recipe."
[LogStash]: http://logstash.net/ "Jordan Sissel (LogStash): LogStash is a tool for managing events and logs."
[grep]: http://logstash.net/docs/1.1.9/filters/grep "Jordan Sissel (LogStash): The grep filter is used to drop events that don't match or add tags to events that pass."
[grok]: http://logstash.net/docs/1.1.9/filters/grok "Jordan Sissel (LogStash): The grok filter lets you parse arbitrary text and structure it."
