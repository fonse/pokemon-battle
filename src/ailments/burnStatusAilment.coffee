StatusAilment = require './statusAilment'

class BurnStatusAilment extends StatusAilment
  affects: (pokemon) ->
  	return 'Fire' not in (type.name for type in pokemon.types)
  
  whenInflicted: (pokemon, log) ->
    log.message pokemon.trainerAndName() + " was burned!"

  endTurn: (pokemon, log) ->
    pokemon.takeDamage Math.round(pokemon.maxHp / 8), "%(pokemon) was hurt %(damage) by its burn!", log

  statMultiplier: (stat) ->
    switch stat
      when 'attack' then 0.5
      else 1

  battleMultiplier: (chance) -> 1 + 0.5 * chance / 100

module.exports = BurnStatusAilment