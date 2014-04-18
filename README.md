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
### One on One Battle
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

You defeated the foe!
Arcanine: 24 HP (7%) left.
```


### Team Battles
By providing lists of pokemon, you can simulate a battle between 2 teams. For example:

```coffee
pokemon = require 'pokemon-battle'

console.log pokemon.battle [25, 196, 143, 3, 6, 9], [18, 65, 112, 130, 103, 56]
```

You can also name the trainers, instead the default "you" and "the foe", by using an object:

```coffee
pokemon = require 'pokemon-battle'

console.log pokemon.battle {trainer: "Red",  pokemon: [25, 196, 143, 3, 6, 9]},
                           {trainer: "Blue", pokemon: [18, 65, 112, 130, 103, 56]}
```

Output:

```
Blue withdrew Pidgeot.
Blue took out Rhydon.
Red's Pikachu used Volt Tackle!
It doesn't affect Blue's Rhydon...


Red's Pikachu used Grass Knot!
It's super effective!
Blue's Rhydon is hit for 351 HP (100%)
Blue's Rhydon fained!
Blue took out Exeggutor.


Red's Pikachu used Volt Tackle!
It's not very effective...
Blue's Exeggutor is hit for 50 HP (15%)
Red's Pikachu is hurt 17 HP (8%) by recoil!

Blue's Exeggutor used Psychic!
Red's Pikachu is hit for 194 HP (92%)
Red's Pikachu fained!
Red took out Charizard.


Blue withdrew Exeggutor.
Blue took out Gyarados.
Red's Charizard used Air Slash!
Blue's Gyarados is hit for 106 HP (32%)


Red's Charizard used Air Slash!
Blue's Gyarados is hit for 108 HP (33%)

Blue's Gyarados flinched and couldn't move!


Red's Charizard used Air Slash!
Blue's Gyarados is hit for 107 HP (32%)

Blue's Gyarados used Aqua Tail!
It's super effective!
Red's Charizard is hit for 297 HP (100%)
Red's Charizard fained!
Red took out Snorlax.


Blue's Gyarados used Aqua Tail!
Red's Snorlax is hit for 178 HP (39%)

Red's Snorlax used Rock Tomb!
It's a critical hit!
It's super effective!
Blue's Gyarados is hit for 10 HP (3%)
Blue's Gyarados fained!
Blue's Gyarados's Speed fell!
Blue took out Mankey.


Red withdrew Snorlax.
Red took out Espeon.
Blue's Mankey used Cross Chop!
It's not very effective...
Red's Espeon is hit for 74 HP (27%)


Blue withdrew Mankey.
Blue took out Pidgeot.
Red's Espeon used Psychic!
Blue's Pidgeot is hit for 174 HP (57%)


Red's Espeon used Psychic!
Blue's Pidgeot is hit for 133 HP (43%)
Blue's Pidgeot fained!
Blue took out Alakazam.


Blue's Alakazam used Energy Ball!
Red's Espeon is hit for 103 HP (38%)

Red's Espeon used Shadow Ball!
It's super effective!
Blue's Alakazam is hit for 177 HP (71%)


Blue's Alakazam used Energy Ball!
Red's Espeon is hit for 94 HP (35%)
Red's Espeon fained!
Red took out Blastoise.


Blue's Alakazam used Energy Ball!
It's super effective!
Red's Blastoise is hit for 177 HP (59%)

Red's Blastoise used Surf!
It's a critical hit!
Blue's Alakazam is hit for 74 HP (29%)
Blue's Alakazam fained!
Blue took out Exeggutor.


Red's Blastoise used Ice Beam!
It's super effective!
Blue's Exeggutor is hit for 184 HP (56%)

Blue's Exeggutor used Giga Drain!
It's super effective!
Red's Blastoise is hit for 122 HP (41%)
Red's Blastoise fained!
Blue's Exeggutor healed 61 HP (18%)!
Red took out Snorlax.


Blue's Exeggutor used Psychic!
Red's Snorlax is hit for 119 HP (26%)

Red's Snorlax used Double-Edge!
Blue's Exeggutor is hit for 158 HP (48%)
Blue's Exeggutor fained!
Red's Snorlax is hurt 53 HP (11%) by recoil!
Blue took out Mankey.


Red withdrew Snorlax.
Red took out Venusaur.
Blue's Mankey used Acrobatics!
It's super effective!
Red's Venusaur is hit for 176 HP (58%)


Red's Venusaur used Giga Drain!
Blue's Mankey is hit for 172 HP (78%)
Red's Venusaur healed 86 HP (29%)!

Blue's Mankey used Acrobatics!
It's super effective!
Red's Venusaur is hit for 183 HP (61%)


Red's Venusaur used Giga Drain!
Blue's Mankey is hit for 49 HP (22%)
Blue's Mankey fained!
Red's Venusaur healed 25 HP (8%)!


Red defeated Blue!
Pikachu: 0 HP (0%) left.
Espeon: 0 HP (0%) left.
Snorlax: 111 HP (24%) left.
Venusaur: 53 HP (18%) left.
Charizard: 0 HP (0%) left.
Blastoise: 0 HP (0%) left.
```


### Checking a Pokemon's Moves
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

### Looking Up a Pokemon Number by Name
The `lookup` function allows you to obtain the National Pokedex number of a pokemon by its name.

```coffee
pokemon = require 'pokemon-battle'

pokemon.lookup 'Blastoise' #Returns 9
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

Note that since the implementation of Jump Kick, Sawsbuck will use this move against Audino. I'll leave this example, however, because it showcases several of the many situations that can arise during a battle.

## Future Development
The following elements are still unsopported, but I'd like to include them in future versions.

- Non-damaging moves
- Stat levels (boosts and nerfs)
- Status ailments
- Abilities
- Held items
- EVs
 
There are also many damaging moves which were not implemented due to having complex restrictions or side effects, such as Transform, Hidden Power, Synchronoise, Flying Press and multi-turn moves like Fly or Hyper Beam

For a full list of these effects and their level of support, see the [list of move effects](https://github.com/fonse/pokemon-battle/blob/master/docs/effects.md).
