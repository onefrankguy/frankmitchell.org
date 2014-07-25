<!--
title: The quick, easy way to version Chef roles
created: 25 July 2014 - 5:14 am
updated: 25 July 2014 - 6:49 am
publish: 25 July 2014
slug: chef-roles
tags: coding, chef
-->

[Chef][] starts out with this nice clean mental model. Cookbooks are for
applications. Roles are for servers. Environments are for workflows.
Data bags are for storage. But after a while that model starts to fall
apart.

The first thing to fail is roles. Here's a typical role for a web server.

    {
      "name": "web-server"
      "description": "For hosting web sites",
      "run_list": [
        "recipe[base]",
        "recipe[apache]"
      ],
      "default_attributes": {
        "apache": {
          "port": 80
        }
      },
      "json_class": "Chef::Role",
      "chef_type": "role"
    }

Suppose you've decided Apache's too much of a resource hog. You want to move
to Nginx instead. So keep Apache in production and roll out Nginx to staging.
How are you going to do that?

You can try adding `env_run_lists` to your role. At first glance, this looks
like a simple way to set up different run lists for different environments.

    {
      "name": "web-server"
      "description": "For hosting web sites",
      "run_list": [],
      "env_run_lists": {
        "staging": [
          "recipe[base]",
          "recipe[nginx]"
        ],
        "production": [
          "recipe[base]",
          "recipe[apache]"
        ]
      },
      "default_attributes": {
        "nginx": {
          "port": 80
        },
        "apache": {
          "port": 80
        }
      },
      "json_class": "Chef::Role",
      "chef_type": "role"
    }

Of course, it doesn't scale. Throw in development, build, and testing
environments and you end up with an unweildy JSON monster. Wouldn't
it be nice if you could version your roles and promote them between
environments like you do with cookbooks? Well it turns out you can.

## Build role cookbooks ##

You're going to turn your web server role into a cookbook. First, create
a cookbook named after your role. Prefix its name with the word "role" and a
hyphen.

    mkdir cookbooks/role-web-server

Next, create a default recipe that mimics your JSON role. Set default attributes
before you include recipes. That way attribute precidence will be preserved and
your role's attributes will override the cookbook's attributes. Put this code
in a "recipes/default.rb" file in the "role-web-server" folder.

    node.default['apache']['port'] = 80

    include_recipe 'base'
    include_recipe 'apache'

Because this is a cookbook, you can set a version number in its metadata. Put
this code in a "metadata.rb" file in the "role-web-server" folder.

    name 'role-web-server'
    version '1.0.0'

    depends 'base'
    depends 'apache'

You don't want to break existing nodes that use the web server role. So change
the JSON role to run the new cookbook.

    {
      "name": "web-server"
      "description": "For hosting web sites",
      "run_list": [
        "recipe[role-web-server]"
      ],
      "json_class": "Chef::Role",
      "chef_type": "role"
    }

You now have a versioned role that can be promoted between environments.

## Fix search in existing cookbooks ##

There are two reasons for naming your role cookbooks with a "role-" prefix. The
first is so that they are all grouped together. This makes them easy to find
when listing cookbooks. The second is to make it easy to fix search in your
existing recipes.

Chances are you have search code in your recipes that relies on looking up
roles by name. It probably looks like this.

    role = 'web-server'
    servers = search("roles:#{role}")

That code works because the web server role is running the new cookbook.
Eventually you'll want to migrate away from roles entirely and just use
cookbooks. So you'll need to change the search to look for recipes instead.

    role = 'web-server'
    servers = search("recipes:role-#{role}")

Notice how the only thing that changed was the query string? That was
intentional. Minimal changes means easier testing.


[Chef]: http://www.getchef.com/ "Various (Chef): Automation for Web-Scale IT"
