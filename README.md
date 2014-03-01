Pokemon Battle
==============

This is an automatic pokemon battle simulator born as a fun script for [Hubot](http://hubot.github.com/).

Given 2 pokemon, the simulator will choose a build of 4 moves for each pokemon and then simulate a battle with an elementary AI.

The pokemon and moves are up to date to Gen VI thanks to the amazing database from https://github.com/veekun/pokedex.


## Instalation
You can install using Node Package Manager (npm):

```
npm install pokemon-battle
```

## Usage
Simply provide 2 pokemon referenced by their National Pokedex number.

```coffee
pokemon = require 'pokemon-battle'

console.log pokemon.battle 59, 135
```

The code above will output the result of the battle:
```
The foe's Jolteon used Thunderbolt!
It's a critical hit!
Your Arcanine is hit for 210 HP (65%)

Your Arcanine used Flare Blitz!
The foe's Jolteon is hit for 260 HP (96%)
Your Arcanine is hurt 87 HP (27%) by recoil!


Your Arcanine used Extreme Speed!
The foe's Jolteon is hit for 11 HP (4%)
The foe's Jolteon fained!


The winner is your Arcanine with 24 HP (7%) remaining!
```

You can also check which moves the simulator chose for a given pokemon.
```coffee
pokemon = require 'pokemon-battle'

console.log pokemon.build 9
```

Will show Blastoise's moves:
```
Surf (Water - 90 power - 100 accuracy)
Earthquake (Ground - 100 power - 100 accuracy)
Ice Beam (Ice - 90 power - 100 accuracy)
Focus Blast (Fighting - 120 power - 70 accuracy)
```



## About the AI
When choosing a move, the AI will consider its base power, as well as accuracy, type and governing stat.

For example, Hydro Pump has a power of 100, but its 80% accuracy makes it a worse choice than Surf, with 90 power and 100% accuracy. However, Gyarados will prefer Aqua Tail (90 power and 90% accuracy) over both because it's a physical move and its attack stat is much higher than its special attack.

Some move side-effects will also affect the decision. For example, a pokemon with low HP will favor a healing move like Giga Drain and shun moves with recoil like Double-Edge. Also, if a pokemon thinks a high priority move like Quick Attack or Extreme Speed will finish off the opponent, it will chose it over standard-priority moves.

Let's analyze the following battle:

```
Your Sawsbuck used Double-Edge!
The foe's Audino is hit for 158 HP (46%)
Your Sawsbuck is hurt 53 HP (18%) by recoil!

The foe's Audino used Fire Blast!
It's super effective!
Your Sawsbuck is hit for 170 HP (56%)


Your Sawsbuck used Horn Leech!
The foe's Audino is hit for 107 HP (31%)
Your Sawsbuck healed 54 HP (18%)!

The foe's Audino used Ice Beam!
It's super effective!
Your Sawsbuck is hit for 132 HP (44%)
Your Sawsbuck fained!


The winner is the foe's Audino with 82 HP (24%) remaining!
```

For the first move, both pokemon went in guns blazing with the moves that would deal the most damage.
However, for the second move Sawsbuck at nearly half HP favored the healing move Horn Leech over the recoil move Double-Edge, while Audino prefered Ice Beam over Fire Blast because, while both moves would have killed the opponent, Ice Beam had a higher accuracy.

## Future Development
The following elements are still unsopported, but I'd like to include them in future versions.

- Pokemon teams for 3v3 or 6v6 battles
- Non-damaging moves
- Stat levels (boosts and nerfs)
- Status ailments
- Abilities
- Held items
- EVs
 
There are also many damaging moves which were not implemented due to having complex restrictions or side effects. For example, Transform, Hidden Power, Synchronoise, Flying Press and multi-turn moves like Fly or Hyper Beam to name a few.

If they are too situational they probably won't be implemented, but the more useful effects have already been implemented (such as Grass Knot, Acrobatics and multi-hit moves like Pin Missile) or will be (such as High Jump Kick and high critical rate moves like Shadow Claw).
