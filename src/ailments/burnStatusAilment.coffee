StatusAilment = require './statusAilment'

class BurnStatusAilment extends StatusAilment
  whenInflicted: (pokemon, log) ->
    log.message pokemon.trainerAndName() + " was burned!"

  statMultiplier: (stat) ->
    switch stat
      when 'attack' then 0.5
      else 1

  endTurn: (pokemon, log) ->
    damage = pokemon.takeDamage Math.round(pokemon.maxHp / 8)
    log.message pokemon.trainerAndName() + " was hurt " +  damage + " HP (" + Math.round(damage / pokemon.maxHp * 100) + "%) by its burn!"

module.exports = BurnStatusAilment