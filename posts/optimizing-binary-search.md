<!--
title: Optimizing binary search
created: 13 April 2006 - 8:49 am
updated: 14 January 2007 - 7:54 pm
slug: binary-search
tags: coding
-->

An engineer comes in to work one day and finds that his boss has left him a
little piece of Ruby code.

    n = 16384
    f = Array.new(n) { |i| i += 1 }
    0.upto(n) do
      k = rand(2 * n)
      # TODO: Impliment a binay search for k
    end

"Hmm," says the engineer. "Binary search. Haven't done one of those since
college." But, because he understands the princple of stealing cars before
reinventing wheels, the engineer looks up a binary search algorithm on Google.
Soon he has code to replace his boss's comment.

    x = 0
    y = n - 1
    while x <= y do
      m = (x + y) / 2
      if k == f[m]
        x = m
        break
      else
        if k < f[m]
          y = m - 1
        else
          x = m + 1
        end
      end
    end
    found = f[x] == k

Being a good engineer, he decides to bechmark his code. It clocks in at 2.4
seconds. "Not bad," says the engineer. "But I wonder if I can do better?" He
digs out an old book from college, _Programming in the 1990s_, and thumbs
through it until he finds the section on binary searching. There it is, the
theoretically optimal solution.

    x = -1
    y = n
    while y != x + 1 do
      m = (x + y) / 2
      if f[m] <= k
        x = m
      end
      if f[m] > k
        y = m
      end
    end
    found = false
    found = f[x] == k if 0 <= x

The engineer benchmarks this code, and finds it runs in 2.41 seconds.
"That's 0.01 seconds slower than my previous version," says the engineer.
"I wonder why?" Thinking for a bit, the engineer realizes that the new code
doesn't break out of the loop when it finds the correct solution. So he
optimizes it.

    x = -1
    y = n
    while y != x + 1 do
      m = (x + y) / 2
      if f[m] < k
        x = m
      end
      if f[m] == k
        x = m
        break
      end
      if f[m] > k
        y = m
      end
    end
    found = false
    found = f[x] == k if 0 <= x

This snippet has an average time of 2.8 seconds, and now the engineer is
becoming slightly concerned. Things look to be going from bad to worse. Thinking
some more, the engineer finds another optimization. "I know. I need to be using
'else' statements."

    x = -1
    y = n
    while y != x + 1 do
      m = (x + y) / 2
      if f[m] < k
        x = m
      else
        if f[m] > k
          y = m
        else
          if f[m] == k
            x = m
            break
          end
        end
      end
    end
    found = false
    found = f[x] == k if 0 <= x

This code is better. Lots better. Its benchmark times comes in at 2.02 seconds.
Pleased with himself, the engineer decides to get a peer review on his code
before checking it in to the source tree. He calls one of his colleagues over to
take a look.

"That's some pretty hairy logic. Maybe you could simplify it," the colleague
says. "And you should be caching that lookup value."

Back to the drawing board the engineer goes. He does what his colleague
suggests, simplifying the logic and caching the value that's looked up in the
array. "Okay," he says. "Now I've got a really optimized binary search."

    x = -1
    y = n
    while y != x + 1 do
      m = (x + y) / 2
      t = f[m]
      if t > k
        y = m
      else
        x = m
        if t == k
          break
        end
      end
    end
    found = false
    found = f[x] == k if 0 <= x

But the benchmarks tell another story. This code has an average time of 2.22
seconds. It's 0.2 seconds slower than his previous version, and only 7.5% faster
than his original version! "This can't be right," the engineer says. "What am I
missing here?"

Pulling out some scratch paper, he starts doodling little pictures of binary
trees and walking through the steps to search them. Then it clicks. Fifty
percent of a binary tree's nodes are at its leaves. That means for half the
nodes in the tree, his premature termination of the loop doesn't save him
anything. For a quarter of the nodes, it only saves him one loop. For an eighth
of the nodes, it saves him two loops. The engineer breaks out his graphing
calculator and does a quick summation. He's only saving an average of the one
iteration by prematurely terminating the loop. The break statement must go.

"Well if the break statement goes," the engineer says, "then I don't have to
cache the lookup in the array, since I'm only doing it once." Again he rewrites
the code.

    x = -1
    y = n
    while y != x + 1 do
      m = (x + y) / 2
      if f[m] <= k
        x = m
      else
        y = m
      end
    end
    found = false
    found = f[x] == k if 0 <= x

Anxiously, the engineer waits for the benchmarks to come in. 1.91 seconds! It's
20.4% faster than his original version. Elated, the engineer takes the code
straight to his boss.

"Nice job," the boss says when the engineer explains the story of the binary
search to him. "There's one engineer who'll be getting a raise," he adds, as the
engineer heads out the door.

Three hours later, one of the testers walks over to the engineer's office.

"There's a [bug][] in your code," the tester tells him. The egineer stares at
her aghast.

"What bug?" he asks.

"If x and y are really large, then x plus y overflows and m becomes negative,"
she says.

"I never thought about that," the engineer admits. "But wait, doesn't Ruby's
[Bignum][] class handle that?"

"Obviously not, since it broke," she replies. "So fix it."

Thinking for a minute, the engineer comes up with a one line fix.

    m = x + ((y - x) / 2)

"I wonder how many other people know about that?" the engineer thinks to himself
as he checks his patch into source control.

[bug]: http://googleresearch.blogspot.com/2006/06/extra-extra-read-all-about-it-nearly.html "Peter Norvig (Google): Extra, Extra - Read All About It: Nearly All Binary Searches and Mergesorts are Broken"
[Bignum]: http://ruby-doc.org/core/classes/Bignum.html "Unknown (Ruby-Doc.org): Bignum"
