<!--
title: PHP regex spider
date: 26 December 2004
-->

    #!/usr/bin/php
    <?php
    // PHP Regex Spider v. 2.0
    // Copyright 2004 Frank Mitchell. All rights reserved.
    // http://thiefsystems.org/ccs/phpregexspider
    echo("\n");

    // Where should we start searching from?
    $start = 'http://thiefsystems.org/ccs/';

    // What should we be looking for?
    $search = '~<em>(.*?)<\/em>~';

    // Do you want to follow query links?
    $follow_queries = true;

    // Do you want to convert 'http://www.' to 'http://' ?
    $convert_www = true;

    // Do you want to convert HTML entries?
    // Setting this to true may cause the spider to seg. fault when it
    // encounters pages with malformed HTML code.
    $convert_html = false;

    // What kinds of files and schemes should we avoid?
    $dont_follow = array('jpg', 'gif', 'png', 'ico', 'zip', 'rar', 'tar', 'gz',
    'c|', 'c', 'pl', 'py', 'js', 'jar', 'reg', 'orig', 'exe', 'java', 'class',
    'css', 'xml', 'txt', 'dvi', 'ps', 'lot', 'doc', 'ppt', 'pdf', 'lit', 'mp3',
    'wav', 'ra', 'pm', 'mpg', 'mpeg', 'mso', 'psd', 'swf', 'img', 'vhdl', 'dat',
    'cpp', 'cls', 'tex', 'clq', 'mailto', 'javascript', 'news', 'feed', 'file');

    // Build information about the site we're going to search.
    if($url = parse_url($start))
    {
      if(isset($url['scheme'], $url['host']))
      {
        $b_scheme = $url['scheme'];
        $b_host = $url['host'];
      }
    }
    else
    {
      echo("\nError!\n");
      echo('Description: Unable to parse starting URL. ');
      echo("Please enter a different URL to start from.\n");
      echo("Starting URL: " .$start. "\n\n");
      exit;
    }

    // Initialize our array of links.
    $links = array($start => 0);

    // Initialize our array of search results.
    $gold = array();

    // Keep crawling until we run out of links.
    while($p_link = array_search(0, $links))
    {

      // Mark this link as having been seen.
      $links[$p_link] = 1;

      // Get the contents of the link we're currently looking at.
      // If we fail this, there's no point in going further.
      // Remove the @ symbol if you want to see all warnings for pages that
      // could not be retreived.
      if(@ $contents = file_get_contents($p_link))
      {

        // Convert any HTML characters we find, including quotes.
        if($convert_html)
        {
          $contents = html_entity_decode($contents, ENT_QUOTES);
        }

        // What link are we following?
        echo('Following link: '.$p_link."\n");

        // Build information about the link we're currently looking at.
        unset($url, $p_url, $p_scheme, $p_host, $p_path);
        if($url = parse_url($p_link))
        {
          $p_url = $p_link;
          if(isset($url['scheme']))
          {
            $p_scheme = $url['scheme'];
            $p_url = $p_scheme.'://';
          }
          if(isset($url['host']))
          {
            $p_host = $url['host'];
            $p_url .= $p_host;
          }
          if(isset($url['path']))
          {
            $p_path = dirname($url['path']);
            $p_url .= $p_path;

            // Remove leading and trailing slashes from our path.
            $p_path_end = strlen($p_path);
            if($p_path_end > 0)
            {
              $p_path_end--;
              if($p_path{0} == '/')
              {
                $p_path{0} = '';
              }
              if($p_path{$p_path_end} == '/')
              {
                $p_path{$p_path_end} = '';
              }
            }
          }

          // Add a trailing slash to our URL if one doesn't exist.
          if($p_url{strlen($p_url) - 1} != '/')
          {
            $p_url .= '/';
          }
        }

        // Extract all the search matches from the current page.
        preg_match_all($search, $contents, $search_results);

        // Put the search results into our pot of gold.
        for($i = 0; $i < count($search_results[1]); $i++)
        {
          $result = $search_results[1][$i];
          if(array_search($result, $gold) === false)
          {
            $gold[] = $result;
          }
        }

        // Extract the links from the current page.
        preg_match_all('~href *= *(\'|")(.*?)\1~i', $contents, $link_results);

        // Loop through our extracted links and manipulate them.
        for($i = 0; $i < count($link_results[2]); $i++)
        {

          // Get an extracted link from our list.
          $c_link = $link_results[2][$i];

          // Decode the link in case it's been encoded.
          $c_link = urldecode($c_link);

          // Trim any whitespace that might be on our link.
          $c_link = trim($c_link);

          // Build information about our extracted link.
          // If we can't parse the URL, don't continue.
          unset($url);
          if($url = parse_url($c_link))
          {
            // Get the extension for this particular link.
            $c_ext = substr(strrchr($c_link, '.'), 1);
            $c_ext = strtolower($c_ext);

            // Skip links to files on our don't follow list.
            if($c_ext != '' && in_array($c_ext, $dont_follow))
            {
              $c_link = '';
            }

            // If this link is external, we don't want to follow it.
            elseif(isset($url['scheme']))
            {
              if(isset($url['host']) && strpos($url['host'], $b_host) === false)
              {
                $c_link = '';
              }
              elseif(in_array(strtolower($url['scheme']), $dont_follow))
              {
                $c_link = '';
              }
            }

            // Remove fragments from the end of a link.
            if($c_link != '' && isset($url['fragment']))
            {
              $c_link = str_replace('#'.$url['fragment'], '', $c_link);
            }

            // Remove queries from the end of a link.
            if(!$follow_queries && $c_link != '' && isset($url['query']))
            {
              $c_link = str_replace('?'.$url['query'], '', $c_link);
            }
          }
          else
          {
            // If we won't be able to follow it, mark it as bad.
            $c_link = '';
          }

          // If our link's made it this far, it's good, so let's keep it.
          if($c_link != '')
          {

            // We can skip any absolute links we've still got.
            if(strpos($c_link, 'http:') === false)
            {

              // Case 1: The URL is of the form: /directory/file
              if($c_link{0} == '/')
              {
                $c_link = $b_scheme.'://'.$b_host.$c_link;
              }

              // Case 2: The URL is of the form: ../directory/file
              elseif($count = substr_count($c_link, '../'))
              {
                // Remove the relative bits from our link.
                $c_link = str_replace('../', '', $c_link);  

                // Backtrack the required number of directories.
                $path_array = explode('/', $p_path);
                $new_path = '';
                for($j = $count; $j > 0; $j--)
                {
                  array_pop($path_array);
                }
                for($j = 0; $j < count($path_array); $j++)
                {
                  $new_path = $new_path.$path_array[$j].'/';
                }
                $new_path .= $c_link;

                // Assemble the correct path for our link.
                $c_link = $p_scheme.'://'.$p_host.'/'.$new_path;
              }

              // Case 3: The URL is of the form: ./directory/file
              elseif(strpos($c_link, './') !== false)
              {
                $c_link = str_replace('./', '', $c_link);
                $c_link = $p_url.$c_link;
              }

              // Case 4: The URL is of the form: file 
              else
              {
                $c_link = $p_url.$c_link;
              }
            }

            // Remove any www. stuff from the start of our link.
            if($convert_www)
            {
              $c_link = str_replace('http://www.', 'http://', $c_link);
            }

            // Add our extracted list to our list of links to look at.
            if(!array_key_exists($c_link, $links))
            {
              $links[$c_link] = 0;
            }
          }
        }
      }
      else
      {
        // Mark this link as being unretrievable.
        $links[$p_link] = -1;
      }
    }

    // How many links did we end up finding vs. searching?
    $count = array_count_values($links);
    if(!isset($count[-1]))
    {
      $count[-1] = 0;
    }
    $count[2] = $count[1] + $count[-1];

    echo("\nTotal number of links found was ".$count[2].".");
    echo("\nTotal number of links searched was ".$count[1].".");
    echo("\nTotal number of bad links was ".$count[-1].".\n\n");

    // What kind of search results did we get?
    $count = count($gold);

    echo("\nSearch results: \n\n");
    for($i = 0; $i < $count; $i++)
    {
      echo($gold[$i]. "\n");
    }
    echo("\nTotal number of search results found was ".$count.".\n\n");
    ?>
