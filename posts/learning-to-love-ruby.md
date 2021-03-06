<!--
title: Learning to love Ruby
created: 6 January 2005 - 9:55 am
updated: 12 September 2005 - 8:56 pm
slug: next-language
tags: ruby
-->

### Bit by the language bug ###

I've been itching to learn another computer language for a while now. Mostly, I've wanted something that I could just sit down and go from idea to application in as short a time as possible. None of the languages I know now will let me do that. C and C++ require lots of hand holding so they compile correctly. Prolog can't do math. PHP can't interface closely enough with the operating system. AppleScript isn't general purpose enough.

[Lisp][] seems too buried in the realm of the geek for it to be remotely usable. [Python][] seems promising; it's got a good track record and an emphasis on being teachable to non-programmers. But I ran into problems getting to to work on my Mac, so the snake is a no-go. [Java][] has a huge following, and it's defiantly getting fast enough to be usable, but from what I've seen, it's still too high level for me.

So where do you find a loosely typed, fast, powerful, object-oriented, cross-platform language that doesn't make you do stupid things like put semicolons at the end of every line?

### Answers in gemstones ###

I first stumbled across Ruby while reading [a post][] by bsag. Since then, I haven't given it much thought. It wasn't until I discovered that [Basecamp][] (a project I've admired quite a bit for its GTD style approach to project management) was written in Ruby, and that it's got an excellent framework (called [Rails][]) for building web applications, that I decided to give [this tiny Japanese language][Ruby] a second glance.

So I did a little searching and came across the following quote from [an interview][] with Yukihiro Matsumoto, Ruby's creator:

> "But in fact we need to focus on humans, on how humans care about doing programming or operating the application of the machines."

A light bulb went off in my mind. Here's somebody who doesn't think within the traditional geek paradigm. Computers are tools. We need to start using them as such. They're fast enough, powerful enough, and good enough at recognizing patterns that our computer shouldn't need semicolons at the end of every instruction. It shouldn't care what order we tell it to do things in as long as the semantics are the same each way. It should get out of our way and let us go from idea to application as quickly as possible.

Ruby makes that possible.

### Practical demonstrations ###

Having decide that Ruby was going to be my next language, I wasted no time getting started. Download Ruby, install Rails, start looking for a project. The obvious answer was something for Al's research, like finding all the repeti-grams in a set of text files.

Side note: A repeti-gram is a m-gram where each letter is the same. So "aaa" is a three letter repeti-gram, or a repeti-3-gram.

I'd already written something similar in C++ to find all the m-grams in a set of files, and it'd taken me an hour or so of coding before all the bugs were worked out. I guessed that modifying it to find repeti-grams (and count them) would be about thirty minutes of work.

Instead, I spent those thirty minutes writing a Ruby program to do the exact same thing. The code appears at the end of this essay for those that care. It's 80 lines, with comments. My C++ program that does the same thing is 300+ lines. If I knew more about regular expressions, no doubt I could have done it (the Ruby version) in fewer lines.

It's amazing how much having the right tool for the job makes things that much easier. C++ wasn't designed with text manipulation in mind (I'm not sure it was designed with _anything_ specific in mind), yet here I'd been using it as a text manipulation tool for the past year simply because I didn't know of anything better.

Ruby is better, at least, in this instance.

### What I love about Ruby ###

It gets out of my way and lets me code. Ruby supports both `if` and `unless` (a kind of negative `if`), so if it's easier to think in negative terms I can just code it as I'm thinking about it. Likewise, I don't have to think about _how_ to do things like file IO. All the day-to-day repetitive issues have already been coded for me.

For me, that's how computers (and our interaction with them) should be, transparent. I shouldn't have to think; the computer should just act as an extension of my brain. As for as programing goes, Ruby comes the closest to letting me do just that.

### Code ###

	#!/usr/bin/env ruby

	# Print some helpful text if all the correct parameters aren't passed in.
	unless ARGV[0]
		print "
	usage: ruby count.rb [size] [input]
	
	This program requires that you pass it two arguments:
	
	1. The size of the repeti-grams you want counted. Just an integer here.
	2. A list of the text files you want to count repeti-grams in.
	
	Here's an example to get you started. Suppose you wanted to count all the
	3-grams that did the repeti thing (all the same letter) in the text files in
	the directory above this one. You'd just type the following:
	
	ruby count.rb 3 ../*.txt
	
	Simple, huh?
	
	"
	# On to more interesting matters, like counting repeti-grams.
	else
	
		# Deal with our command line arguments.
		size = ARGV[0].to_i
		files = ARGV[1...ARGV.length]
	
		# Create an array to store our found repeti-grams.
		mgrams = Array.new
	
		# Create a hash to store our counted repeti-grams.
		counted = Hash.new
	
		# How many m-grams total did we count?
		mgram_total = 0
	
		# Process each of our input files in turn.
		files.each do |file|
	
			# Make sure we've got a valid file.
			# Thanks to Aaron Brown for spotting this.
			if File.file? (file)
			
				# Convert everything to lowercase and strip what's not alphabetic.
				text = File::read(file).downcase.delete "^abcdefghijklmnopqrstuvwxyz"
	
				# Get all the repeti-grams in our file.
				mgram = text[0,1]
				text.each_byte do |ch|
					if mgram.length >= size
						mgram = mgram[1, size]
						mgram += ch.chr
						for i in 0..size
							break unless mgram[i] == ch
						end
						mgrams.push(mgram) if i == size
						mgram_total += 1
					else
						mgram += ch.chr
					end
				end
			end
		end
	
		# Convert our found repeti-grams to a hash so we can count them.
		mgrams.each do |mgram|
			unless counted[mgram] == nil
				counted[mgram] += 1
			else
				counted[mgram] = 1
			end
		end
	
		# Print out our counted repeti-grams and the count of each.
		print "\n"
		counted.each do |mgram, count|
			print "#{mgram}: #{count}\n"
		end
		print "\n"
	
		# Print our total number of m-grams / repeti-grams seen, and we're done.
		print "m-gram total: #{mgram_total}\n"
		print "repeti-gram total: #{mgrams.length}\n\n"
	end



[Lisp]: http://slashdot.org/article.pl?sid=01/11/03/1726251 "timothy (Slashdot): Kent M. Pitman Answers on Lisp and Much More"

[Python]: http://www.linuxjournal.com/article/5028 "Phil Hughes (Linux Journal): An Interview with Guido van Rossum"

[Java]: http://www.computerworld.com/softwaretopics/software/appdev/story/0,10801,69760,00.html "Carol Sliwa (Computerworld): Q&A Part III: Java creator Gosling on Java tools, his move to Mac"

[a post]: http://www.rousette.org.uk/blog/archives/2004/09/08/ruby-tuesday/ "bsag (but she's a girl...): Ruby Tuesday"

[Basecamp]: http://basecamphq.com/ "Basecamp (37signals): Project management software"

[Rails]: http://rubyonrails.org/ "David Heinemeier Hansson (Ruby on Rails): Develop web-applications with sustainable productivity"

[Ruby]: http://www.ruby-lang.org/en/ "Ruby: Programmer's best friend"

[an interview]: http://www.artima.com/intv/ruby4.html "Bill Venners (Artima Developer): The Philosophy of Ruby"
