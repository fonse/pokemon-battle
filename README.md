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

console.log pokemon.battle [25, 196, 143, 3, 6, 9], [18, 65, 112, 130, 103, 59]
```

You can also name the trainers, instead the default "you" and "the foe", by using an object:

```coffee
pokemon = require 'pokemon-battle'

console.log pokemon.battle {trainer: "Red",  pokemon: [25, 196, 143, 3, 6, 9]},
                           {trainer: "Blue", pokemon: [18, 65, 112, 130, 103, 59]}
```

Output:

```
Blue withdrew Pidgeot.
Blue took out Rhydon.
Red's Pikachu used Volt Tackle!
It doesn't affect Blue's Rhydon...


Red withdrew Pikachu.
Red took out Venusaur.
Blue's Rhydon used Hammer Arm!
It's not very effective...
Red's Venusaur is hit for 62 HP (21%)
Blue's Rhydon's Speed rose!


Red's Venusaur used Giga Drain!
It's super effective!
Blue's Rhydon is hit for 351 HP (100%)
Blue's Rhydon fained!
Red's Venusaur healed 62 HP (21%)!
Blue took out Alakazam.


Red withdrew Venusaur.
Red took out Pikachu.
Blue's Alakazam used Psychic!
Red's Pikachu is hit for 211 HP (100%)
Red's Pikachu fained!
Red took out Blastoise.


Blue's Alakazam used Psychic!
Red's Blastoise is hit for 142 HP (47%)

Red's Blastoise used Earthquake!
Blue's Alakazam is hit for 126 HP (50%)


Blue's Alakazam used Psychic!
Red's Blastoise is hit for 143 HP (48%)

Red's Blastoise used Earthquake!
Blue's Alakazam is hit for 125 HP (50%)
Blue's Alakazam fained!
Blue took out Exeggutor.


Red withdrew Blastoise.
Red took out Charizard.
Blue's Exeggutor used Ancient Power!
It's super effective!
Red's Charizard is hit for 266 HP (90%)


Red's Charizard used Air Slash!
It's super effective!
Blue's Exeggutor is hit for 287 HP (87%)

Blue's Exeggutor used Ancient Power!
It's super effective!
Red's Charizard is hit for 31 HP (10%)
Red's Charizard fained!
Red took out Espeon.


Red's Espeon used Shadow Ball!
It's super effective!
Blue's Exeggutor is hit for 44 HP (13%)
Blue's Exeggutor fained!
Blue's Exeggutor's Special Defense fell!
Blue took out Pidgeot.


Red's Espeon used Psychic!
Blue's Pidgeot is hit for 174 HP (57%)

Blue's Pidgeot used Brave Bird!
Red's Espeon is hit for 197 HP (73%)
Blue's Pidgeot is hurt 66 HP (21%) by recoil!


Red's Espeon used Psychic!
Blue's Pidgeot is hit for 67 HP (22%)
Blue's Pidgeot fained!
Blue took out Arcanine.


Blue's Arcanine used Extreme Speed!
Red's Espeon is hit for 74 HP (27%)
Red's Espeon fained!
Red took out Blastoise.


Blue's Arcanine used Extreme Speed!
Red's Blastoise is hit for 14 HP (5%)
Red's Blastoise fained!
Red took out Snorlax.


Blue's Arcanine used Flare Blitz!
Red's Snorlax is hit for 222 HP (48%)
Blue's Arcanine is hurt 74 HP (23%) by recoil!

Red's Snorlax used Earthquake!
It's super effective!
Blue's Arcanine is hit for 221 HP (69%)


Blue's Arcanine used Extreme Speed!
Red's Snorlax is hit for 100 HP (22%)

Red's Snorlax used Earthquake!
It's super effective!
Blue's Arcanine is hit for 26 HP (8%)
Blue's Arcanine fained!
Blue took out Gyarados.


Blue's Gyarados used Earthquake!
Red's Snorlax is hit for 139 HP (30%)
Red's Snorlax fained!
Red took out Venusaur.


Blue's Gyarados used Earthquake!
Red's Venusaur is hit for 112 HP (37%)

Red's Venusaur used Sludge Bomb!
It's a critical hit!
Blue's Gyarados is hit for 174 HP (53%)


Blue's Gyarados used Earthquake!
Red's Venusaur is hit for 116 HP (39%)

Red's Venusaur used Giga Drain!
Blue's Gyarados is hit for 90 HP (27%)
Red's Venusaur healed 45 HP (15%)!


Blue's Gyarados used Earthquake!
Red's Venusaur is hit for 111 HP (37%)

Red's Venusaur used Giga Drain!
Blue's Gyarados is hit for 67 HP (20%)
Blue's Gyarados fained!
Red's Venusaur healed 34 HP (11%)!


Red defeated Blue!
Pikachu: 0 HP (0%) left.
Espeon: 0 HP (0%) left.
Snorlax: 0 HP (0%) left.
Venusaur: 41 HP (14%) left.
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
