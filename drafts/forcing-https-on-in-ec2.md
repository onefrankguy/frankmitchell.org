<!--
title: Forcing HTTPS on in Amazon's EC2
created: 7 May 2013 - 9:52 pm
updated: 9 May 2013 - 7:49 am
publish: 7 May 2013
slug: https-elb
tags: coding, aws
-->

It's pretty common these days to see HTTP connections redirected to HTTPS. If
you're running servers in Amazon's EC2, you can configure an
[Elastic Load Balancer][] to hanlde the SSL termination. But to handle the
redirect, you need a proxy. Here are configurations for three popular ones.

## HAProxy ##

[HAProxy][] won't handle serving up your web site, but it will handle routing
your traffic. Confiure your ELB to pass both HTTP and HTTPS traffic on to your
web server as HTTP traffic on port 80. Amazon's ELB will set the
`X-Forwarded-Proto` header based on the original connection, so you can use an
[acl definition][] and [redirect directive][] to handle the redirect.

    acl is_http hdr(X-Forwarded-Proto) http
    redirect proxy https://domain.com 301 if is_http

Passing the `proxy` flag to the redirect command keeps the path and query
arguments on the URL intact. Specifying a 301 return code tells visitors
this is a permanent redirect.

## Nginx ##

When it comes to setting up [Nginx][], [`if` is evil][]. Skip the
`X-Forwarded-Proto` header check, and instead configure your ELB to pass HTTP
traffic to your web server on port 80 and HTTPS traffic to your web server on
port 443. You can then configure Nginx to listen on both ports and redirect
traffic on port 80.

    server {
      listen 80;
      return 301 https://domain.com/$request_uri;
    }

    server {
      listen 443;
    }

The `$request_uri` variable keeps the path and query arguments on the URL
intact.

## Apache ##
