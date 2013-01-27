<!--
title: If Garrett wrote code
created: 2 January 2005 - 10:20 pm
updated: 4 January 2005 - 7:47 am
slug: master-programmer
tags: thief
-->

## PHP ##

    function easy_job()
    {
      $bag = array();
      $loot = array('gold plate', 'gold cup', 'jeweled scepter');

      foreach($loot as $swag)
      {
        if(size($swag) > 0)
        {
          $bag[] = $swag;
        }
      }

    return $bag;
  }

## SQL ##

    SELECT loot FROM manor WHERE rich_noble IS "Bafford";

## C++ ##

    void deal_with_guard(human guard, human garrett)
    {
      if(guard.name == "Benny")
      {
        sneak_past_guard(guard, garrett);
      }
      else
      {
        if(guard.alertness == 0)
        {
          sneak_past_guard(guard, garrett);
        }
        if(guard.alertness == 1 || guard.alertness == 2)
        {
          hide_in_shadows(garrett);
          garrett.weapon = "Blackjack";
          garrett.movement = "Lean forward";
          if(in_range(guard, garrett))
          {
            garrett.attack = true;
          }
        }
        if(guard.alertness == 3)
        {
          garrett.weapon = "Flashbomb";
          if(in_range(guard, garrett))
          {
            garrett.attack = true;
          }
          garrett.weapon = "Blackjack";
          if(in_range(guard, garrett))
          {
            garrett.attack = true;
          }
        }
      }
    }

## Conversation ##

> "[Y]ou're lovely and brilliant. Thanks for making me smile. My friend (and
> fellow TTLG member) Sarah, in New Zealand said, 'Oh god that's geeky.'"

> [Lindsey Pope][]

It _is_ geeky, which is kind of odd for me, since I'm usually not such an overt
geek. I like the SQL statement best ('cause non-programmers can understand it
too), and that was the idea that sparked the rest of the them.


[Lindsey Pope]: http://livejournal.com/users/kit_whiskers/ "Lindsey Pope (Livejournal): Claws and teeth and whiskers oh my!"
