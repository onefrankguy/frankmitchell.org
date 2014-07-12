<!--
title: How to do DevOps even if you can't write code
created: 12 July 2014 - 8:12 am
updated: 12 July 2014 - 8:12 am
publish: 14 July 2014
slug: water-cooler
tags: coding, chef
-->

Getting started with DevOps is easy. It doesn't matter if you're on the dev
side, the ops side, or the boss stuck in the middle. Here are three scenarios
that walk you through what to say step by step.

## If you're a dev&hellip;##

Dev: "Hey, what are you working on?"

Ops: "I'm writing a cron job to automatically clear out old Kibana logs."

Dev: "Cool. Have you seen ElasticSearch's new TTL feature?"

Ops: "No. Let me look into that. Might save me some work. Thanks."

## If you're in ops&hellip;##

Ops: "So, what have you been working on lately?"

Dev: "I'm recording HTTP requests so this unit test can run locally."

Ops: "Nice. Have you seen WireMock? It's a sweeet HTTP mocking framework."

Dev: "No. I'll check that out. Might save me some code. Thanks."

## If you're the boss&hellip; ##

Boss: "I need some help. We need to restart all our servers at 4:00 am."

Ops: "Use a cron job."

Boss: "But I don't know if 4:00 am's right. We might want to change it later."

Dev: "Do you have an agent on the box?"

Boss: "Well, Chef's on all the servers."

Ops: "So put the time in a data bag."

Dev: "And have Chef write it to the cron job."

Boss: "Nice. That will work. Thank you."

## But where's the code, and the tools, and the process? ##

DevOps is about one thing. Communication. All the code and tools and process in
the world mean squat if you don't have good communication. What's good
communication? It has two parts.

1 Being genuinely interested in the work other people are doing.
2.Wanting to help other people solve their problems.

That's it.
