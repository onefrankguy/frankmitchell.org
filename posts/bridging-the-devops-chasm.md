<!--
title: Bridging the DevOps chasm
created: 17 May 2014 - 8:08 am
updated: 17 May 2014 - 8:36 am
publish: 17 May 2014
slug: devops-divide
tags: coding, chef
-->

At this point in my career, I've spent as much time doing traditional
software development (desktop and server) as I have doing operations
(release eningeering and automation). And I often find the two at odds
with each other. This is mostly reflected in code itself, and is best
illustrated with an example.

## A chasm that must be crossed ##

Suppose you have a web application where you want to index articles.
[ElasticSearch][] is a good choice for this. Also suppose you have
[LogStash][] set up to feed the Apache logs from your web servers over
to ElasticSearch so you can monitor them.

Now ask an engineer to write [Chef][] code so that both your application
servers and your LogStash indexers can can discover your ElasticSearch
cluster. What's that code going to look like?

## From the development side ##

The question in the mind of a developer is "How can I write the best
possible code that will be easy to maintain six months from now?" Applying
a little thought to the problem, and maybe digging through the Opscode docs,
they come up with this.

    def find_elasticsearch_servers
      servers = search(:node, 'role:elasticsearch')
      servers.map do |info|
        "#{info['ipaddress']}:#{info['elasticsearch']['port']}"
      end
    end

That's a basic Chef search to find all the nodes with an "elasticsearch" role
and return a list of their IP addresses and ports. I'm intentally ignoring
things like finding all the nodes that are in the same Chef environment, or
handling the case where a node's has public and private IP addresses, or
dealing with multiple ElasticSearch clusters. Leave those to production
cookbooks.

What's important to note here is that the above code is both simple and
reusable. It can be used by both the application server and the LogStash indexer
to find ElasticSearch servers. And it adhears to the "Don't Repeat Yourself"
principle, so when a bug is later found, it can be fixed once and rolled out
everywhere. This is good code.

## From the operations side ##

The question in the mind of an operations engineer is "How can I write the best
possible code that will be easy to fix when it breaks at 3 am?"

## Finding a bridge ##

[ElasticSearch]: http://elasticsearch.org/ "Various (ElasticSearch): "
[LogStash]: http://logstash.org/ ""
[Chef]: http://opscode.org/chef/
