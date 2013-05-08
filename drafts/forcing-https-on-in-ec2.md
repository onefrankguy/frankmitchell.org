<!--
title: Forcing HTTPS on in Amazon's EC2
created: 7 May 2013 - 9:52 pm
updated: 7 May 2013 - 10:11 pm
publish: 7 May 2013
slug: https-elb
tags: coding, aws
-->

It's pretty common these days to see HTTP connections redirected to HTTPS. If
you're running servers in Amazon's EC2, you can configure an Elastic Load
Balancer to hanlde the SSL termination. But to handle the redirect, you need
a proxy. Here are configurations for three popular ones.

These setups assume your ELB is configured to handle HTTP traffic on port 80,
handle HTTPS traffic on port 443, and forward HTTP traffic on to your web server
on port 80.

## HAProxy ##

HAProxy won't handle serving up your web site, but it will handle routing your
traffic. The key is that Amazon's ELB will set the X-Forwarded-Proto header
based on the originating connection. If it's "http" then you know you need to
redirect is to use its flexible [acl definitions][] to

    acl is_http hdr(X-Forwarded-Proto) http
    redirect proxy https://my.domain.com if is_http

## Nginx ##

## Apache ##
