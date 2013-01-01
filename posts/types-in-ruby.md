<!--
title: Types in Ruby
created: 1 April 2007 - 10:13 am
updated: 1 April 2007 - 10:13 am
slug: ruby-types
tags: ruby, unfinished
-->

## Conversations at work ##

A couple of months ago, I wrote a [greedy bin packing algorithm][knapsack] for
work. The other day, Chris decided he a needed a simpler packing algorithm, and
asked me to explain how my solution worked.

"What type is files?" Chris asked as we stepped through the code.

    files.each do |file|
      name = file[0]
      size = file[1]
      # Bin packing algorithm...
    end

"It's most likely a hash or a two-dimensional array," I said. "Probably a hash;
though, I'm not really sure."

Chris gave me a look that said, "How can you look at code you wrote and not even
know what types of variables you used?"

Well, Ruby doesn't really have types.

## Duck typing ##

A Ruby variable holds a reference to an object of a certain type if it behaves
like that type. This is commonly called duck typing, i.e. "If it walks like a
duck, and it quacks like a duck, it must be a duck."

When people are first learning Ruby, they tend to think that type and class are
intertwined. If `files.class` returns `Hash`, then `files` must be a hash. But
consider this:

    class Files
      def class
        Hash
      end
    end
    
    files = Files.new
    
    if files.class == Hash
      files['ruby.txt'] = 3
    end

Even though `files.class` returns `Hash`, `files` doesn't have a reference to a
`Hash`, it has a reference to a `Files` object. Okay, so what about using the
`instance_of?` method?

    class Files
      def instance_of?(type)
        type == Hash
      end
    end
    
    files = Files.new
    
    if files.instance_of?(Hash)
      files['ruby.txt'] = 3
    end

That doesn't work. `instance_of?` suffers from the same problem as `class`. When
the code is executed, it throws a error saying the `[]=` method is missing. So
what about asking the...

[knapsack]: http://en.wikipedia.org/wiki/Knapsack_problem "Various (Wikipedia): Knapsack problem"

<http://alek.xspaces.org/2005/02/27/ruby-type-explosion>

<http://gian.expdev.net/blog/?p=6>

<http://www.stefanroock.de/weblog/2005/09/ruby-vs-java.html>
