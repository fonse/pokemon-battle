Pokemon Battle
==============

This is an automatic pokemon battle simulator born as a fun script for [Hubot](http://hubot.github.com/).

Given 2 teams of pokemon, the simulator will choose a build of 4 moves for each pokemon and then simulate a battle with an elementary AI.

The pokemon and moves are up to date to Gen VI thanks to the amazing database from https://github.com/veekun/pokedex.

## Online Version
Check out an online version here:  
https://pokemon-battle.herokuapp.com/


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
The foe's Jolteon fainted!

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
Blue's Pidgeot used U-turn!
Red's Pikachu is hit for 103 HP (49%)
Blue took out Rhydon.

Red's Pikachu used Volt Tackle!
It doesn't affect Blue's Rhydon...


Red's Pikachu used Grass Knot!
It's super effective!
Blue's Rhydon is hit for 348 HP (99%)

Blue's Rhydon used Hammer Arm!
Red's Pikachu is hit for 108 HP (51%)
Red's Pikachu fainted!
Blue's Rhydon's Speed rose!
Red took out Blastoise.


Blue withdrew Rhydon.
Blue took out Exeggutor.
Red's Blastoise used Surf!
It's not very effective...
Blue's Exeggutor is hit for 75 HP (23%)


Red's Blastoise used Ice Beam!
It's a critical hit!
It's super effective!
Blue's Exeggutor is hit for 256 HP (77%)
Blue's Exeggutor fainted!
Blue took out Gyarados.


Blue's Gyarados used Earthquake!
Red's Blastoise is hit for 97 HP (32%)

Red's Blastoise used Ice Beam!
Blue's Gyarados is hit for 66 HP (20%)


Blue's Gyarados used Earthquake!
Red's Blastoise is hit for 106 HP (35%)

Red's Blastoise used Ice Beam!
Blue's Gyarados is hit for 70 HP (21%)


Blue's Gyarados used Earthquake!
Red's Blastoise is hit for 96 HP (32%)
Red's Blastoise fainted!
Red took out Snorlax.


Blue's Gyarados used Aqua Tail!
Red's Snorlax is hit for 188 HP (41%)

Red's Snorlax used Double-Edge!
Blue's Gyarados is hit for 195 HP (59%)
Blue's Gyarados fainted!
Red's Snorlax is hurt 65 HP (14%) by recoil!
Blue took out Alakazam.


Blue's Alakazam used Focus Blast!
It's super effective!
Red's Snorlax is hit for 208 HP (45%)
Red's Snorlax fainted!
Red took out Espeon.


Blue's Alakazam used Shadow Ball!
It's super effective!
Red's Espeon is hit for 187 HP (69%)

Red's Espeon used Shadow Ball!
It's super effective!
Blue's Alakazam is hit for 175 HP (70%)


Blue's Alakazam used Shadow Ball!
It's super effective!
Red's Espeon is hit for 84 HP (31%)
Red's Espeon fainted!
Red took out Charizard.


Blue's Alakazam used Psychic!
Red's Charizard is hit for 179 HP (60%)

Red's Charizard used Earthquake!
Blue's Alakazam is hit for 76 HP (30%)
Blue's Alakazam fainted!
Blue took out Rhydon.


Red's Charizard used Air Slash!
It's not very effective...
Blue's Rhydon is hit for 3 HP (1%)
Blue's Rhydon fainted!
Blue took out Arcanine.


Red's Charizard used Earthquake!
It's super effective!
Blue's Arcanine is hit for 161 HP (50%)

Blue's Arcanine used Wild Charge!
It's super effective!
Red's Charizard is hit for 118 HP (40%)
Red's Charizard fainted!
Blue's Arcanine is hurt 30 HP (9%) by recoil!
Red took out Venusaur.


Blue's Arcanine used Flare Blitz!
It's a critical hit!
It's super effective!
Red's Venusaur is hit for 301 HP (100%)
Red's Venusaur fainted!
Blue's Arcanine is hurt 100 HP (31%) by recoil!


Blue defeated Red!
Pidgeot: 307 HP (100%) left.
Alakazam: 0 HP (0%) left.
Rhydon: 0 HP (0%) left.
Gyarados: 0 HP (0%) left.
Exeggutor: 0 HP (0%) left.
Arcanine: 30 HP (9%) left.
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
Your Sawsbuck fainted!


The winner is the foe's Audino with 82 HP (24%) remaining!
```

For the first move, both pokemon went in guns blazing with the moves that would deal the most damage.

However, for the second move Sawsbuck at nearly half HP favored the healing move Horn Leech over the recoil move Double-Edge, while Audino prefered Ice Beam over Fire Blast because, while both moves would have killed the opponent, Ice Beam had a higher accuracy.

Note that since the implementation of Jump Kick, Sawsbuck will use this move against Audino. I'll leave this example, however, because it showcases several of the many situations that can arise during a battle.

## Future Development
The following elements are still unsopported, but I'd like to include them in future versions.

- Non-damaging moves
- Abilities
- Held items
- EVs
 
There are also many damaging moves which were not implemented due to having complex restrictions or side effects, such as Transform, Hidden Power, Synchronoise, Flying Press and multi-turn moves like Fly or Hyper Beam

For a full list of these effects and their level of support, see the [list of move effects](https://github.com/fonse/pokemon-battle/blob/master/docs/effects.md).
