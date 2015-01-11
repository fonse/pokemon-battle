StatusAilment = require './statusAilment'

class BurnStatusAilment extends StatusAilment
  whenInflicted: (pokemon, log) ->
    log.message pokemon.trainerAndName() + " was burned!"

  statMultiplier: (stat) ->
    switch stat
      when 'attack' then 0.5
      else 1

  endTurn: (pokemon, log) ->
    pokemon.takeDamage Math.round(pokemon.maxHp / 8), "%(pokemon) was hurt %(damage) by its burn!", log

module.exports = BurnStatusAilment