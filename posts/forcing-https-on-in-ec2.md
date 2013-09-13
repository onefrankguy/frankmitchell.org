<!--
title: Forcing HTTPS on in Amazon's EC2
created: 7 May 2013 - 9:52 pm
updated: 13 September 2013 - 7:01 am
publish: 7 May 2013
slug: https-elb
tags: coding, aws
-->

It's pretty common these days to see HTTP connections redirected to HTTPS. If
you're running servers in [Amazon's EC2][ec2], you can configure an
[Elastic Load Balancer][] to hanlde the SSL termination. But to handle the
redirect, you need a proxy. Here are configurations for three popular ones.

## HAProxy ##

[HAProxy][] won't handle serving up your web site, but it will handle routing
your traffic. Confiure your ELB to pass both HTTP and HTTPS traffic on to your
web server as HTTP traffic on port 80.

<table width="100%">
  <tr>
    <td>ELB Protocol</td>
    <td>ELB Port</td>
    <td>Server Protocol</td>
    <td>Server Port</td>
  </tr>
  <tr>
    <td>HTTPS</td><td>443</td>
    <td>HTTP</td><td>80</td>
  </tr>
  <tr>
    <td>HTTP</td><td>80</td>
    <td>HTTP</td><td>80</td>
  </tr>
</table>

Amazon's ELB will set the `X-Forwarded-Proto` header based on the original
connection. The header's value is "http" if the connection came in on port 80,
and "https" if it came in on port 443. You can use an [acl definition][] and
[redirect command][] to detect an incomming HTTP connection and redirect it
to a HTTPS one.

    acl is_http hdr(X-Forwarded-Proto) http
    redirect proxy https://domain.com 301 if is_http

Passing the `proxy` flag to the redirect command keeps the path and query
arguments on the URL intact. Specifying a 301 return code tells visitors
this is a permanent redirect.

## Nginx ##

Denis Klykvin showed me how to use the [`$http_x_forwarded_proto`][http_header]
variable for header testing in [Nginx][].

    if ($header_x_forwarded_proto) {
      rewrite https://domain.com/$request_uri permanent;
    }

However, Nginx thinks [if is evil][]. Instead, take advantage of the default
difference in ports for HTTP and HTTPS traffic. Configure your ELB to pass HTTP
traffic to your web server on port 80 and HTTPS traffic to your web server on
port 443.

<table width="100%">
  <tr>
    <td>ELB Protocol</td>
    <td>ELB Port</td>
    <td>Server Protocol</td>
    <td>Server Port</td>
  </tr>
  <tr>
    <td>HTTPS</td><td>443</td>
    <td>HTTP</td><td>443</td>
  </tr>
  <tr>
    <td>HTTP</td><td>80</td>
    <td>HTTP</td><td>80</td>
  </tr>
</table>

You can use [server blocks][] to listen on both ports. If you get a connection
on port 80, you know it started as a HTTP connection, so you can redirect it to
a HTTPS one.

    server {
      listen 80;
      return 301 https://domain.com/$request_uri;
    }

    server {
      listen 443;
    }

The `$request_uri` variable keeps the path and query arguments on the URL
intact. Specifying a 301 return code tells visitors this is a permanent
redirect.

## Apache ##

[Apache][] can detect the `X-Forwarded-Proto` header the ELB sets and
use it to redirect traffic. Confiure your ELB to pass both HTTP and HTTPS
traffic on to your web server as HTTP traffic on port 80.

<table width="100%">
  <tr>
    <td>ELB Protocol</td>
    <td>ELB Port</td>
    <td>Server Protocol</td>
    <td>Server Port</td>
  </tr>
  <tr>
    <td>HTTPS</td><td>443</td>
    <td>HTTP</td><td>80</td>
  </tr>
  <tr>
    <td>HTTP</td><td>80</td>
    <td>HTTP</td><td>80</td>
  </tr>
</table>

Set up a [mod_rewrite rule][] to check the `X-Forwarded-Proto` header. If it
comes in with a value of "http", you can redirect that traffic to HTTPS.

    <VirutalHost *:80>
      RewriteEngine On
      RewriteCond %{HTTP:X-Forwarded-Proto} http
      RewriteRule https://domain.com%{REQUEST_URI} [L,R=301]
    </VirtualHost>

The `%{REQUEST_URI}` variable keeps the path and query arguments on the URL
intact. Specifying  `R=301` flag causes Apache to return a 301 response
code, which tells visitors this is a permanent redirect.

## Final thoughts ##

There are a host of other ways to configure your web servers as well.
HAProxy and Apache can support Nginx's "listen on two ports" setup, and
Nginx does have if conditions you can use to check headers. How you get your
HTTP traffic redirected to HTTPS does't really matter. What counts is that
you're providing a safer experience for your users.


[ec2]: http://aws.amazon.com/ec2 "Various (Amazon): Amazon Elastic Compute Cloud"
[Elastic Load Balancer]: http://aws.amazon.com/elasticloadbalancing "Various (Amazon): Elastic Load Balancing"
[HAProxy]: http://haproxy.1wt.eu/ "Various (HAProxy): The Reliable, High Performance TCP/HTTP Load Balancer"
[acl definition]: http://code.google.com/p/haproxy-docs/wiki/UsingACLs "Various (haproxy-docs): Using ACLs"
[redirect command]: http://code.google.com/p/haproxy-docs/wiki/redirect "Various (haproxy-docs): redirect"
[Nginx]: http://nginx.org/ "Various (Nginx): Nginx HTTP and Reverse Proxy Server"
[http_header]: http://wiki.nginx.org/HttpCoreModule#2.4http_HEADER "Various (nginx): $http_HEADER variable"
[if is evil]: http://wiki.nginx.org/IfIsEvil "Various (nginx): If is evil"
[server blocks]: http://nginx.org/en/docs/http/nginx_core_module.html#listen "Various (Nginx): listen"
[Apache]: http://httpd.apache.org/ "Various (Apache Foundation): Apache HTTP Server Project"
[mod_rewrite rule]: http://httpd.apache.org/docs/current/mod/mod_rewrite.html "Various (Apache Foundation): mod_rewrite - Apache HTTP Server Project"
