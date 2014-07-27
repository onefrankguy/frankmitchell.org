<!--
title: The quick, easy way to version Chef roles
created: 25 July 2014 - 5:14 am
updated: 27 July 2014 - 1:01 pm
publish: 25 July 2014
slug: chef-roles
tags: coding, chef
-->

[Chef 11][chef] starts out with this nice clean mental model. Cookbooks are for
applications. Roles are for servers. Environments are for workflows.
Data bags are for storage. But after a while that model starts to fall
apart.

The first thing to fail is roles. Here's a typical role for a web server.

    {
      "name": "web-server"
      "description": "For hosting web sites",
      "run_list": [
        "recipe[apt]",
        "recipe[apache]"
      ],
      "default_attributes": {
        "apache": {
          "listen_ports": 443
        }
      },
      "json_class": "Chef::Role",
      "chef_type": "role"
    }

Suppose you've decided you want to terminate SSL connections at your load
balancer instead of your web server. You're pretty sure this is a no-brainer
operation, but you decide to run it through your testing environment just to
be safe. So you configure the load balancer in your testing environment and
change the port number Apache listens on.

    {
      "name": "web-server"
      "description": "For hosting web sites",
      "run_list": [
        "recipe[apt]",
        "recipe[apache]"
      ],
      "default_attributes": {
        "apache": {
          "listen_ports": 80
        }
      },
      "json_class": "Chef::Role",
      "chef_type": "role"
    }

Then alarms start going off. Production is down! You revert your changes and
things go back to normal. What went wrong?

## Your mental model is broken ##

The flaw is that Chef's model of reality doesn't map to yours. In the typical
operations worldview, things have a precedence that looks like this:

1. Applications
2. Services
3. Environments
4. Servers

An application (Apache) can have its configuration overwritten by a service
(web site) that's defined by an environment (production) and ultimately
controlled by the server (EC2 instance) the application's running on.

It's pretty easy to see where Chef's cookbooks fit in. They're applications.
Likewise, environments are, well, environments. And nodes are servers. But what
about services? The only thing left is roles, so those must be services.

1. Cookbooks
2. Roles
3. Environments
4. Nodes

This mental model makes a whole lot of sense. Roles contain run lists of
cookbooks, just like services are made of up applications. Nodes belong to an
environment, just like servers belong to an environment. Conceptually it holds
together.

Base on this, you should be able to change something in a role and not have it
change in every environment. But that's not how roles work. Looking at [the
documentation][role] a role is defined as:

> "A role is a way to define certain patterns and processes that exist across
> nodes in an organization as belonging to a single job function."

The key phrase there is "across nodes in an organization". Notice how it's not
"across nodes in an environment". That's because role attribute precedence takes
priority over environment attribute precedence. So if you change something in
a role, you're changing it for your entire company.

## Role cookbooks to the rescue ##

Roles hold data at the organizational level. You need something that holds data
at the service level. Something that sits between cookbooks and environments in
terms of attribute precedence. And it needs to be able to enforce a run list.

What about another cookbook?

Cookbooks can depend on other cookbooks. They can overwrite attributes of
those they depend on to customize their behavior. This puts them between
cookbooks and environments in terms of attribute precedence. They can also
include recipes from their dependents, effectively functioning as a run list.

The Chef community refers to these as "role cookbooks". Here's how you turn your
JSON web server role into one. First, create a new cookbook named after your
role. Prefix its name with the word "role" and a hyphen.

    mkdir cookbooks/role-web-server

Next, create a default recipe that mimics your JSON role. Set default attributes
in the recipe context before you include recipes. That way the role's attributes
will take precedence over the cookbook's attributes, and the environment's
attributes will take precedence over the role's attributes.

    # role-web-server/recipes/default.rb
    node.default['apache']['listen_ports'] = 443

    include_recipe 'apt'
    include_recipe 'apache'

Because this is a cookbook, you can set a version number in its metadata.
Explicit versioning facilitates tracking changes between environments. Version
one can run Apache on port 443 and version two can run it on port 80.

    # role-web-server/metadata.rb
    name 'role-web-server'
    version '1.0.0'

    depends 'apt'
    depends 'apache'

Finally, you don't want to break existing nodes that use the web server role. So
change the JSON role to run the new cookbook.

    {
      "name": "web-server"
      "description": "For hosting web sites",
      "run_list": [
        "recipe[role-web-server]"
      ],
      "json_class": "Chef::Role",
      "chef_type": "role"
    }

You now have a versioned Chef role.

## Why this is better ##

At first glance you haven't gained a whole lot. A few more lines of Ruby.
A few less lines of JSON. But look back at the [the documentation on
managing roles][role] you'll find this warning:

> "The canonical source of a role's data is stored on the Chef server, which
> means that keeping role data in version source control can be challenging."

Cookbooks have no such limitations. Because they can have explicit versions and
be frozen when promoted between environments, their source of truth is always
what's in source control.

More importantly, you've now mapped your own mental model of how attribute
precedence should work onto Chef. So when you change the role-web-server
cookbook to run Apache on port 80 and promote that change to testing, the only
things that will change are the things you expect to change.

You're not entirely done though. There's still the problem of all the other
cookbooks. The ones that expect that JSON web server role to exist.

## Searching for role cookbooks ##

Chances are you have search code in your recipes that relies on looking up
roles by name. It probably looks like this.

    role = 'web-server'
    servers = search(:node, "roles:#{role}")

That code still works because the JSON role is running the new cookbook. Ideally
you wouldn't have to maintain both a role and a cookbook. But as Julian Dunn
points out in ["Chef Roles Aren't Evil"][stop], if you migrate away from roles
entirely, you're going to lose out on search.

> "Another reason why roles are still valuable: Chef Server has a index for
> roles, so you can dynamically discover other machines based on their role
> (function)...If you don't use roles at all, you don't get to do this."

Fortunately, Chef's search is amazingly powerful. In addition to maintaining
an index on roles, the Chef Server also maintains an index on recipes. You can
change your search to look for "recipes" instead of "roles".

    role = 'web-server'
    servers = search(:node, "recipes:role-#{role}")

Searching for "recipes" on the node (as opposed to "recipe") means Chef will
look in the expanded run list. This means it will find nodes that are running
both the old role and the new cookbook. So you can push this change out and then
go back and remove the old role from your environment.

Being able to fix search easily like this is the primary motivating factor for
naming role cookbooks with a "role-" prefix. There's a secondary benefit as
well. When you list cookbooks, all the role ones are grouped together, making
them easier to find.

## How I got this way ##

I first encountered role cookbooks in early 2013, after Peter Donald wrote about
["Role Cookbooks and Wrapper Cookbooks"][donald]. I wound up there after falling
victim to the story above, wanting to turn off SSL in testing and then realizing
I'd accidentally turned it off for every server in the entire company.

Some "Oh my gosh, we can't do that again!" followed by "You mean I'm going to
have to change how search works on every cookbook?" led to the design described
above. It works for me. It may not work for you. Take the bits you find useful.

I didn't make the connection that it was my mental model that was broken until
about a year later when I read Julian Dunn's article, ["Chef Roles Aren't
Evil"][stop]. The thought that came to mind was, "Wait, roles override
environments? That is so wrong!" It is a poor carpenter that blames his tools.

Chef is the only configuration management tool I know of that does not ask you
to change. Bring Chef into your company and you can keep your existing
workflows. You can keep your existing policies. You can keep your existing
knowledge. Chef only asks that you understand what you do, how you do it, and
why it happens.

With that understanding you can shape it into something magical.


[chef]: http://www.getchef.com/ "Chef: Automation for Web-Scale IT"
[role]: http://docs.opscode.com/essentials_roles.html "Chef: About Roles"
[book]: http://docs.opscode.com/essentials_cookbook_versions.html "Chef: About Versions"
[stop]: http://www.getchef.com/blog/2013/11/19/chef-roles-arent-evil/ "Julian Dunn (Chef): Chef Roles Aren't Evil"
[donald]: http://realityforge.org/code/2012/11/19/role-cookbooks-and-wrapper-cookbooks.html "Peter Donald (RealityForge): Role Cookbooks and Wrapper Cookbooks"
