<!--
title: Who else wants unified mechanics in RPGs?
created: 10 November 2019 - 9:05 am
updated: 10 November 2019 - 6:51 pm
publish: 10 November 2019
slug: roll-under
tags: coding, gaming, rpg
-->

I'm thinking about running a [_Beyond the Wall and Other Adventures_][btw] game,
so I sat down and read through the rules. Everything felt very familiar.
Characters can be one of three types: warriors, rogues, or mages. Levels range
from 1<sup>st</sup> (a bit above ordinay) to 10<sup>th</sup> (heroes of the
land). Ability scores range from 1 to 19, and each character has six abilities:
strength, dexterity, constitution, intelligence, wisdom, and charisma.

I use abilities by rolling a twenty sided dice (1d20) and trying to get less
than or equal to my ability score. So if want to jump over a stream, and my
dexterity is 16, rolling a 19 means I fall in the water.

I also get to use abilities in combat. Ability scores map to bonuses. I attack
by rolling a twenty sided dice, adding my bonuses, and trying to get greater
than or equal to my opponent's armor. So if I want to shoot a bow at a
cockatrice (14 armor), and I'm a 1<sup>st</sup> level rogue (+0 bonus)
whose dexterity is 16 (+2 bonus), rolling a 19 means my I hit the cockatrice.

Wait, what? Rolling a 19 when shooting a bow is a success, but rolling a 19 when
jumping is a failure. I find that confusing. I kind of expect that when I'm
rolling a twenty sided dice, 1 is going to be a failure and 20 is going to
be a success, and the stuff in the middle is going to be a probability curve
with bigger numbers meaning "more likely to be a success".

New player experiences matter. I was teaching a friend [Gloomhaven][gh], and we
talked about how lowest initiative goes first, and they said, "That doesn't make
any sense. If I have more initiative, I should go first." They where right. I've
played Gloomhaven so much that I've internalized the "lower initiative goes
first" rule, so I didn't bother to question it.

But I haven't played _Beyond the Wall_, yet. So I'm going to question these
"roll low for ability checks; roll high for combat" rules, and see how I might
change them.

<hr />

What does it mean, mathematically, for my character to have a dexterity of 16?
It means that I'm going to succeed at 80% of my dexterity checks, because 16
divided by 20 is 0.8. So the probability of any ability check succeeding is the
value of that check divided by 20.

<p class="math">P(A) =
<span class="fraction">
<span class="fup">A</span>
<span class="bar"></span>
<span class="fdn">20</span>
</p>

Here's a table of ability scores, from 1 to 19, as a percentage success rate.

<table>
<thead>
  <tr><th>Ability Score</th><th>Success Rate</th></tr>
</thead>
<tbody>
  <tr><td>1</td><td>5%</td></tr>
  <tr><td>2</td><td>10%</td></tr>
  <tr><td>3</td><td>15%</td></tr>
  <tr><td>4</td><td>20%</td></tr>
  <tr><td>5</td><td>25%</td></tr>
  <tr><td>6</td><td>30%</td></tr>
  <tr><td>7</td><td>35%</td></tr>
  <tr><td>8</td><td>40%</td></tr>
  <tr><td>9</td><td>45%</td></tr>
  <tr><td>10</td><td>50%</td></tr>
  <tr><td>11</td><td>55%</td></tr>
  <tr><td>12</td><td>60%</td></tr>
  <tr><td>13</td><td>65%</td></tr>
  <tr><td>14</td><td>70%</td></tr>
  <tr><td>15</td><td>75%</td></tr>
  <tr><td>16</td><td>80%</td></tr>
  <tr><td>17</td><td>85%</td></tr>
  <tr><td>18</td><td>90%</td></tr>
  <tr><td>19</td><td>95%</td></tr>
</tbody>
</table>

If I want to change the math for ability scores, I can't break this table.
Having a dexterity of 16 should always mean I have an 80% chance of success on
a dexterity ability check.

I want ability checks to feel simlar to combat rolls. I roll a twenty sided
dice, add my ability score, and check if the total is greater than or equal to
a target number. If it is, I succeed; otherwise, I fail.

<p class="math">1d20 + A &ge; ?</p>

What should that target number be? The design notes in Ben Milton's game
[_Knave_][knave], have some clues.

> Requiring saves to exceed 15 means that new PCs have around a 25% chance of
> success, while level 10 characters have around a 75% chance of success, since
> ability bonuses can get up to +10 by level 10. This reflects the general
> pattern found in the save mechanics of early D&D.

Ability bonuses in _Knave_ range from 0 to 6. Characters make saving throws by
rolling a twenty sided dice, adding their ability bonus, and checking to see if
the total is greater than 15. If it is, they succeed; otherwise, they fail.
That's pretty much what I want, so I need some way to map the ability scores in
_Beyond the Wall_ to the ability bonuses in _Knave_.

The character playbooks in _Beyond the Wall_ start most ability scores at 8, a
40% success rate. So I can subtract 8 from an ability score to get something
that fits in the smaller range of the _Knave_ system.

<p class="math">1d20 + A - 8 &gt; ?</p>

Witht this formula, a target value of 15 gives a new character a 25% success
rate. The success rate is the number of ways to roll a twenty sided dice and
get greater than the target value. Mathematically, that's 20 minus the target
value, divided by 20.

<p class="math">S =
<span class="fraction">
<span class="fup">20 - T</span>
<span class="bar"></span>
<span class="fdn">20</span>
</p>

Because I don't want to break _Beyond the Wall_, I need to find a target value
that keeps the success rate for new characters stays at 40%.

<p class="math">0.4 =
<span class="fraction">
<span class="fup">20 - T</span>
<span class="bar"></span>
<span class="fdn">20</span>
</p>
<p class="math">20 &times; 0.4 = 20 - T</p>
<p class="math">8 = 20 - T</p>
<p class="math">8 + T = 20</p>
<p class="math">T = 20 - 8</p>
<p class="math">T = 12</p>

I can use a target value of 12 for ability chceks. Since I subtracted 8 to move
ability scores into a _Knave_ range, I can add 8 to move them back to a
_Beyond the Wall_ range. Finally, I can change "greater than" to "greater than
or equal", so ability checks follow the same "my character wins ties" rule as
combat rolls.

<p class="math">1d20 + A - 8 &gt; 12</p>
<p class="math">1d20 + A &gt; 12 + 8</p>
<p class="math">1d20 + A &gt; 20</p>
<p class="math">1d20 + A &ge; 21</p>

So I can use abilities in _Beyond the Wall_ by rolling a twenty sided dice,
adding my ability score, and trying to get greater than or equal to 21.

Does the success rate math still work? If I've got a dexterity of 16, that
should be an 80% success rate. If I roll a 5 or more, I'll pass the skill check.
There are sixteen ways to do that with a twenty sided dice, and 16 divided by
20 is 0.8. It works!

<hr />

I'm not the first person to figure this out. As Saelorn points out in [an En
World thread about dice mechanics][thread]

> If you already have the concept of DCs [difficulty checks] in place for things
> like attack rolls and saving throws, then you could use a mechanic of d20 +
> stat score against a constant DC 21, and it would give the exact same
> distribution.

Now all my checks can use a unified mechanic: roll a twenty sided dice, add
bonuses, and compare with a target value. An unmodified roll of 20 is always
a success, while a 1 is always a failure.

[btw]: https://www.flatlandgames.com/btw/ "Flatland Games: Beyond the Wall and Other Adventures"
[gh]: https://boardgamegeek.com/boardgame/174430/gloomhaven "Various (Board Game Geek): Gloomhaven"
[knave]: https://www.drivethrurpg.com/product/250888/Knave "Ben Milton (DriveThruRPG): Knave"
[thread]: https://www.enworld.org/threads/pre-3e-mechanics-vs-d20-system-mechanics.646646/#post-7446673
