<!--
title: Automatic link checking
created: 30 December 2004 - 9:48 am
updated: 31 December 2004 - 9:15 am
slug: check-links
tags: elimossinary
-->

## Why there's a need ##

Link rot is one of those terrible curses of the Internet. You link to a page and
two months later it's gone. But you, as the author of your website, don't know
this. Only your visitors who click that link know. And most of them probably
won't bother to send you an email to tell you the link is broken.

But what if things weren't like that? What if broken links never got displayed
on your pages in the first place?

Well this first attempt here doesn't do quite that much. Instead, it simply
replaces bad links with their [Google cache][] equivalents.

## Notes ##

The code below was designed to work with [PHP-Markdown][]; indeed, parts of it
were blatantly lifted from Michel Fortin's code. Why reinvent the wheel when you
can steal someone's car? It also requires that you have `curl` installed in
order for it to work. To use, simply call Linkcheck() on your text before you
call Markdown().

[Google cache]: http://www.google.com/help/features.html#cached "Google (Google's help): Google Web Search Features - Cached Links"
[PHP-Markdown]: http://www.michelf.com/projects/php-markdown/ "Michel Fortin: PHP-Markdown - a PHP port of John Gruber's Markdown"

## Code ##

    <?php
    
    #
    # Linkcheck  -  A link checking tool for Markdown
    #
    # Copyright (c) 2004 Frank Mitchell
    # <http://frankmitchell.org/2004/12/check-links>
    #
    # Based on Michel Fortin's port of John Gruber's Markdown.
    # Those projects are copyright to their respective owners
    # and can be found at the URLs below.
    #
    # PHP port of Markdown by Michel Fortin
    # <http://www.michelf.com/projects/php-markdown/>
    #
    # Markdown by John Gruber
    # <http://daringfireball.net/projects/markdown>
    #
    
    function Linkcheck($text)
    {
      # This is the same as Michel Fortin's PHP code for Markdown.
      # Likewise, the link matching code was simply lifted from there.
      $md_nested_brackets_depth = 6;
      $md_nested_brackets =
        str_repeat('(?>[^\[\]]+|\[', $md_nested_brackets_depth).
        str_repeat('\])*', $md_nested_brackets_depth);
      $md_tab_width = 4;
      $less_than_tab = $md_tab_width - 1;
      
      # Grep the text for a list of links to check.
      # We need to handle inline links and reference links.
      
      # Get all the inline links.
      preg_match_all("{
        (                          # wrap whole match in $1
          \\[
            ($md_nested_brackets)  # link text = $2
          \\]
          \\(                      # literal paren
            [ \\t]*
            <?(.*?)>?              # href = $3
            [ \\t]*
            (                      # $4
              (['\"])              # quote char = $5
              (.*?)                # Title = $6
              \\5                  # matching quote
            )?                     # title is optional
          \\)
        )
        }xs", $text, $inline);
      
      # Get all the reference links.
      preg_match_all('{
        ^[ ]{0,'.$less_than_tab.'}\[(.+)\]:  # id = $1
          [ \t]*
          \n?                                # maybe *one* newline
          [ \t]*
        <?(\S+?)>?                           # url = $2
          [ \t]*
          \n?                                # maybe one newline
          [ \t]*
        (?:
          (?<=\s)                            # lookbehind for whitespace
          ["(]
          (.+?)                              # title = $3
          [")]
          [ \t]*
        )?                                   # title is optional
        (?:\n+|\Z)
        }xm', $text, $reference);
      
      # Merge our two lists of links into one array,
      # sort it, and remove dupliates.
      $links = array_merge($inline[3], $reference[2]);
      $links = array_unique($links);
      sort($links);
      
      # Build or curl command to check links.
      $command = 'curl -I';
      
      # We're not going to bother checking internal links now.
      # Let's just check external ones.
      for($i = 0; $i < count($links); $i++)
      {
        $link = $links[$i];
        if(substr($link, 0, 7) == 'http://')
        {
          $command .= ' '.$link;
          $checked_links[] = $link;
        }
      }
      
      # Run curl to check for bad links.
      exec($command, $output);
      
      # Process our results. The first line is going to be the status.
      # Blank lines will separate status calls.
      
      # What's our first result?
      $link_ptr = 0;
      if(strpos($output[0], '200') === false)
      {
        $bad_links[] = $checked_links[$link_ptr];
      }
      $link_ptr++;
      
      # Continue getting the rest of our results.
      for($i = 1; $i < count($output); $i++)
      {
        if($output[$i] == '')
        {
          if(strpos($output[$i + 1], '200') === false)
          {
            $bad_links[] = $checked_links[$link_ptr];
          }
          $link_ptr++;
        }
      }
      
      # Replace any bad links we found with Google's cached copies.
      $google_links = str_replace(
        'http://',
        'http://google.com/search?q=cache:',
        $bad_links);
      $text = str_replace($bad_links, $google_links, $text);
      
      # Return our modified text.
      return $text;
    }
    
    ?>
