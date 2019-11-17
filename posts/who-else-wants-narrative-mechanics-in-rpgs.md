<!--
title: Who else wants narrative mechanics in RPGs?
created: 17 November 2019 - 9:21 am
updated: 17 November 2019 - 2:26 pm
publish: 17 November 2019
slug: roll-over
tags: coding, gaming, rpg
-->

In [_Beyond the Wall and Other Adventures_][btw], there are three types of
tests: ability checks, saving throws, and combat rolls. My previous post was
about how you can [change the mechanics of ability checks][ru] so they use the
same "roll a twenty sided dice, add bonuses, and compare with a target value"
as the other two types of tests.

My reason for wanting unified dice mechancis is that it makes the game less
confusing. I got confused while reading the rules, and I figured if I was
confused, anyone I was playing with was going to get confused as well. Reading
through the rules again, I'm realizing that part of my confusion comes from
the language used to ask for tests.

Ability checks, as a test of player skill, use this kind of language.

> Player: "I try to jump across the stream."<br />
> Gamemaster: "Roll to check dexterity."<br />

So rolling the dice is a test to determine something about the player's skill.
Am I skilled enough to jump across the stream or do I fall in the water? It's
a test every player that wants to jump the stream must pass on their own. We
can't use a group skill check, because my stream jumping skill won't help
you.

But ability checks can also be thought of as a test to determine something
about the environment. Those ability checks use this kind of language.

> Player: "I try to jump across the stream."<br />
> Gamemaster: "Roll to see how slippery the bank is."<br />

This opens up interesting possibilities. Say I've got a dexterity of
16 and I roll an 18. The stream bank is more slippery than my dexterity can
overcome, so I land in the water. Other players can decide they're going to
jump over a different part of the stream, make their own ability checks, and
hopefully find a less slippery spot. Of if I roll a 7, the other players may
decide to follow me, since the bank isn't very slippery there.

This feels like a colaboration, where everyone's rolling to figure stuff out
about the world we're playing in. It's also not going to break the game, since
I'm not changing how ability checks are used or how they map to bonuses.
Rolling under for ability checks now feels like a natural thing. I know what
my character's ability score is and what they can do. I'm rolling for the
unknown, to see what the environment does.

<hr />

Saving throws have a similar linguistic duality to ability checks. Suppose a
mage casts entanglement on some vines near the player. As a test of plyaer
skill, the saving throw for that spell uses this kind of language.

> Player: "I try to escape the vines. "<br />
> Gamemaster: "Roll to save versus spell." <br />

As a test to determine something about the environment, that same saving throw
uses this kind of language.

> Player: "I try to escape the vines."<br />
> Gmaemaster: "Roll to see how quickly the vines grow."<br />

If the player is a level 2 rouge, their save versus spell is 15. So they try
to roll greater than or equal to 15 on a twenty side dice. If they succeed,
the vines grow slowly and they may be able to escape. But if they fail, the
vines grow quickly and they become entangled.

I like this idea of ability checks and saving throws fleshing out details about
the world. It'd be nice to keep the mechanics consistent with the language. If
I'm more resistant to spells, my save versus spell value should be higher.
Fortunately, that's an easy thing to change by rewriting the saving throw
tables for each of class.

When rolling a twenty sided dice, there are six rolls that succeed with a save
versus spell of 15. So rolling under on a 6 is equivalent to rolling over on a
15. Here's the complete conversion table from 1 to 20.

<table class="stats">
<thead>
  <tr>
    <th>Roll Over</th>
    <th>Roll Under</th>
  </tr>
</thead>
<tbody>
  <tr><td>1</td><td>20</td></tr>
  <tr><td>2</td><td>19</td></tr>
  <tr><td>3</td><td>18</td></tr>
  <tr><td>4</td><td>17</td></tr>
  <tr><td>5</td><td>16</td></tr>
  <tr><td>6</td><td>15</td></tr>
  <tr><td>7</td><td>14</td></tr>
  <tr><td>8</td><td>13</td></tr>
  <tr><td>9</td><td>12</td></tr>
  <tr><td>10</td><td>11</td></tr>
  <tr><td>11</td><td>10</td></tr>
  <tr><td>12</td><td>9</td></tr>
  <tr><td>13</td><td>8</td></tr>
  <tr><td>14</td><td>7</td></tr>
  <tr><td>15</td><td>6</td></tr>
  <tr><td>16</td><td>5</td></tr>
  <tr><td>17</td><td>4</td></tr>
  <tr><td>18</td><td>3</td></tr>
  <tr><td>19</td><td>2</td></tr>
  <tr><td>20</td><td>1</td></tr>
</tbody>
</table>

I did those conversions for the warrior, rogue, and mage, and came up with new
tables. My copy of _Beyond the Wall_ shows the rogue's polymorph save going
from 12 to 13 between levels 2 and 3. I assume that's a misprint, so I've
corrected it in the table below.

### The Warrior ###

<table class="stats">
<thead>
  <tr>
    <th>Level</th>
    <th>Poison</th>
    <th>Breath Weapon</th>
    <th>Polymorth</th>
    <th>Spell</th>
    <th>Magic Item</th>
  </tr>
</thead>
<tbody>
  <tr><th>1</th></td><td>7</td><td>4</td><td>6</td><td>4</td><td>5</td></tr>
  <tr><th>2</th></td><td>7</td><td>4</td><td>6</td><td>4</td><td>5</td></tr>
  <tr><th>3</th></td><td>8</td><td>5</td><td>7</td><td>7</td><td>6</td></tr>
  <tr><th>4</th></td><td>8</td><td>5</td><td>7</td><td>7</td><td>6</td></tr>
  <tr><th>5</th></td><td>10</td><td>7</td><td>9</td><td>9</td><td>8</td></tr>
  <tr><th>6</th></td><td>10</td><td>7</td><td>9</td><td>9</td><td>8</td></tr>
  <tr><th>7</th></td><td>11</td><td>8</td><td>10</td><td>10</td><td>9</td></tr>
  <tr><th>8</th></td><td>11</td><td>8</td><td>10</td><td>10</td><td>9</td></tr>
  <tr><th>9</th></td><td>13</td><td>10</td><td>12</td><td>12</td><td>11</td></tr>
  <tr><th>10</th></td><td>13</td><td>10</td><td>12</td><td>12</td><td>11</td></tr>
</tbody>
</table>

### The Rogue ###

<table class="stats">
<thead>
  <tr>
    <th>Level</th>
    <th>Poison</th>
    <th>Breath Weapon</th>
    <th>Polymorth</th>
    <th>Spell</th>
    <th>Magic Item</th>
  </tr>
</thead>
<tbody>
  <tr><th>1</th></td><td>8</td><td>5</td><td>8</td><td>6</td><td>7</td></tr>
  <tr><th>2</th></td><td>8</td><td>5</td><td>8</td><td>6</td><td>7</td></tr>
  <tr><th>3</th></td><td>8</td><td>5</td><td>9</td><td>6</td><td>7</td></tr>
  <tr><th>4</th></td><td>8</td><td>5</td><td>9</td><td>6</td><td>7</td></tr>
  <tr><th>5</th></td><td>9</td><td>6</td><td>10</td><td>8</td><td>9</td></tr>
  <tr><th>6</th></td><td>9</td><td>6</td><td>10</td><td>8</td><td>9</td></tr>
  <tr><th>7</th></td><td>9</td><td>6</td><td>10</td><td>8</td><td>9</td></tr>
  <tr><th>8</th></td><td>9</td><td>6</td><td>10</td><td>8</td><td>9</td></tr>
  <tr><th>9</th></td><td>10</td><td>7</td><td>12</td><td>10</td><td>11</td></tr>
  <tr><th>10</th></td><td>10</td><td>7</td><td>12</td><td>10</td><td>11</td></tr>
</tbody>
</table>

### The Mage###

<table class="stats">
<thead>
  <tr>
    <th>Level</th>
    <th>Poison</th>
    <th>Breath Weapon</th>
    <th>Polymorth</th>
    <th>Spell</th>
    <th>Magic Item</th>
  </tr>
</thead>
<tbody>
  <tr><th>1</th></td><td>7</td><td>6</td><td>8</td><td>9</td><td>10</td></tr>
  <tr><th>2</th></td><td>7</td><td>6</td><td>8</td><td>9</td><td>10</td></tr>
  <tr><th>3</th></td><td>7</td><td>6</td><td>8</td><td>9</td><td>10</td></tr>
  <tr><th>4</th></td><td>7</td><td>6</td><td>8</td><td>9</td><td>10</td></tr>
  <tr><th>5</th></td><td>7</td><td>6</td><td>8</td><td>9</td><td>10</td></tr>
  <tr><th>6</th></td><td>8</td><td>8</td><td>10</td><td>11</td><td>12</td></tr>
  <tr><th>7</th></td><td>8</td><td>8</td><td>10</td><td>11</td><td>12</td></tr>
  <tr><th>8</th></td><td>8</td><td>8</td><td>10</td><td>11</td><td>12</td></tr>
  <tr><th>9</th></td><td>8</td><td>8</td><td>10</td><td>11</td><td>12</td></tr>
  <tr><th>10</th></td><td>8</td><td>8</td><td>10</td><td>11</td><td>12</td></tr>
</tbody>
</table>

[btw]: https://www.flatlandgames.com/btw/ "Flatland Games: Beyond the Wall and Other Adventures"
[ru]: /2019/11/roll-under "Frank Mitchell: Who else wants unified mechanics in RPGs?"
