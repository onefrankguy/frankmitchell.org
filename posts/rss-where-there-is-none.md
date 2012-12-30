<!--
title: RSS where there is none
date: 30 December 2004
slug: audrey-rss
-->

## How I use RSS feeds ##

I was rereading an old [Zeldman article][] on RSS feeds, and I realized that,
for the most part, I don't actually read things in [my news reader][]. Instead,
I use it to track who and what's updated and then just hit the return key to
open the link in a new [Safari][] window.

Like Zeldman, I think that web media should be viewed in its context. If
someone's taken the time to customize their website in any way, then I really
aught to do them the service of viewing their words the way they designed them
to be seen. Of course, if I don't like a site's design (but I like its content)
I'll just read it in my news reader.

## Hacking deviantART ##

Now Sarah has [her own art / journal site][sparkticus], which she updates on a
fairly frequent basis. Sadly it doesn't come with a RSS feed. So I hacked
together a quick PHP script to pull the contents of her site off the web and
turn it into an RSS feed. Needless to say, there's enough "magic values" in
there that this is only useful on deviantART sites. Plus, the title of the feed
is hard coded since I couldn't find a good way to extract it. Looking back now,
I realize I could have just used the HTML `<title>` tag.

Anyway, it works for me.

## PHP code ##

    <?php
    print '<?xml version="1.0"?>';

    #
    # File: index.php
    # Project: AudreyRSS
    # Author: Frank Mitchell
    # Created: 29 December 2004
    # Copyright: ThiefSystems Inc. 2004
    #
    # Purpose:
    #
    # To build an RSS feed out of sites that don't have one. Specifically,
    # DeviantART journals.
    #

    # Get the file we want to retrieve from the URL.
    $url = $_GET['url'];

    # What type of feed do we want to generate, RSS or Atom?
    $type = 'rss';

    # Did we get a URL passed in?
    if($url != '')
    {
      # Get the contents of the URL that was passed in.
      $html = file_get_contents($url);

      # Split the contents of the URL that we got into sections.
      $data = explode('<div class="journal', $html);

      # Parse each of those sections (except the first and last)
      # as a separate entry.
      $items = '';
      for($i = 1; $i < count($data) - 1; $i++)
      {
        # Get a template for this item.
        $item = file_get_contents('display/'.$type.'_item.xml');

        # Get a title for this item.
        preg_match('~<h2>.*>(.*)</h2>~', $data[$i], $temp);
        :: RSS where there is none = $temp[1];

        # Get the description for this item.
        preg_match('~
          .*<div class="trailing section-block read">
          (.*)
          </div>.*<div class="trailing section-foot">
        ~xs', $data[$i], $temp);
        $description = $temp[1];

        # Get the publication date for this item.
        preg_match('~Journal Entry:.*</span>~', $data[$i], $temp);
        $pubdate = preg_replace('~^.*">~', '', $temp[0]);
        $pubdate = str_replace('</span>', '', $pubdate);
        $pubdate = preg_replace('~, ([0-9][0-9]?):~', ' - \1:', $pubdate);
        $pubdate = date('r', strtotime($pubdate));

        # Get the lastbuilddate.
        if($i == 1)
        {
          $lastbuilddate = $pubdate;
        }

        # Get the permanent link to this item.
        preg_match('~
          <a class="beacon" href="/journal/(.*)">
        ~x', $data[$i], $temp);
        $guid = $link = $url.$temp[1];

        # Replace values in our item template as needed.
        $search = array(
          ':: RSS where there is none',
          '$link',
          '$description',
          '$pubdate',
          '$guid'
        );
        $replace = array(:: RSS where there is none, $link, $description, $pubdate, $guid);
        $item = str_replace($search, $replace, $item);

        # Append this item to our list of items.
        $items .= $item."\n\n";
      }

      # Set our title, link, description, and language for this feed.
      :: RSS where there is none = 'Spark\'s DeviantART Journal';
      $link = $url;
      $description = '';
      $language = 'en-us';

      # Read in our feed template.
      $feed = file_get_contents('display/'.$type.'_feed.xml');

      # Replace values in our feed template as needed.
      $search = array(
        ':: RSS where there is none',
        '$link',
        '$description',
        '$language',
        '$lastbuilddate',
        '$items'
      );
      $replace = array(
        :: RSS where there is none,
        $link,
        $description,
        $language,
        $lastbuilddate,
        $items
      );
      $feed = str_replace($search, $replace, $feed);

      # Output our feed and exit.
      print "\n".$feed;
    }
    ?>
## RSS feed template ##

    <rss version="2.0">
      <channel>
        <title>:: RSS where there is none</title>
        <link>$link</link>
        <description>$description</description>
        <language>$language</language>
        <lastBuildDate>$lastbuilddate</lastBuildDate>
        $items
      </channel>
    </rss>

## RSS item template ##

    <item>
      <title>:: RSS where there is none</title>
      <link>$link</link>
      <description>
        <![CDATA[
        $description
        ]]>
      </description>
      <pubDate>$pubdate</pubDate>
      <guid isPermaLink="true">$guid</guid>
    </item>

[Zeldman article]: http://www.zeldman.com/daily/0403a.shtml#unsyndicate "Jeffrey Zeldman (The Daily Report): Unsyndicate (via John Gruber, Daring Fireball)"
[my news reader]: http://newsfirerss.com/ "David Wantanabe (NewsFire): Mac RSS with style"
[Safari]: http://apple.com/safari/ "Apple (Apple's Website): Safari - The fastest browser on the Mac"
[sparkticus]: http://sparkticus.deviantart.com/ "Sarah Park (deviantART): sparkticus"
