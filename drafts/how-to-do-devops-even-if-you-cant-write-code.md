<!--
title: How to do DevOps even if you can't write code
created: 12 July 2014 - 8:12 am
updated: 27 July 2014 - 6:13 pm
publish: 29 July 2014
slug: water-cooler
tags: coding, chef
-->

Getting started with DevOps is easy. It doesn't matter if you're on the dev
side, the ops side, or the boss stuck in the middle. Here are three scenarios
that walk you through what to say step by step.

## If you're a dev... ##

Dev: "Hey, what are you working on?"

Ops: "I'm writing a cron job to automatically clear out old Kibana logs."

Dev: "Cool. Have you seen ElasticSearch's new TTL feature?"

Ops: "No. Let me look into that. Might save me some work. Thanks."

## If you're in ops... ##

Ops: "So, what have you been working on lately?"

Dev: "I'm recording HTTP requests so this unit test can run locally."

Ops: "Nice. Have you seen WireMock? It's a sweet HTTP mocking framework."

Dev: "No. I'll check that out. Might save me some code. Thanks."

## If you're the boss... ##

Boss: "I need some help. We need to restart all our servers at 4:00 am."

Ops: "Use a cron job."

Boss: "But I don't know if 4:00 am's right. We might want to change it later."

Dev: "Do you have an agent on the box?"

Boss: "Well, Chef's on all the servers."

Ops: "So put the time in a data bag."

Dev: "And have Chef write it to the cron job."

Boss: "Nice. That will work. Thank you."

## What about code, tools, process? ##

DevOps is about one thing: communication. Specifically, it's about communication
that reduces the amount of work someone other than yourself has to do. In order
to do that, you have to know what the other person is working on. You have to
understand the problem they're solving so you can offer useful suggestions. And
you have to [speak in their terms][worldviews] so you can offer help that won't
be rejected.

In the beginning this is messy and complicated. Devs are going to talk about
"services" as applications running on the JVM. Ops are going to talk about
"services" as processes running on Linux machines. Bosses are going to talk
about "services" as functional units being provided to a customer. Everyone
will be right and everyone will be wrong at the same time. It's complicated.

Eventually you'll figure it out. You'll learn how objects work in Scala, and
when it's appropriate to cat files to /dev/null, and how sometimes the needs
of the business come before the needs of the customer. You'll start writing
this stuff down, in wikis, and chats, and blogs. You'll share it with new hires.
You'll build your own code and tools and process around the patterns that work
for your company. You'll find your company is always learning new things.

Now you're doing DevOps.


[worldviews]: http://unicornfree.com/samples/30x500%20Freeview%20-%20Worldviews!.pdf "Amy How (30x500): Why You Should Ditch Niches &amp; Embrace Worldviews"
