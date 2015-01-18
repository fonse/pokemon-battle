PoisonStatusAilment = require './poisonStatusAilment'

class BadPoisonStatusAilment extends PoisonStatusAilment
  constructor: ->
    @multiplier = 1/16
  
  whenSwitchedOut: (pokemon) ->
    @multiplier = 1/16

  whenInflicted: (pokemon, log) ->
    log.message pokemon.trainerAndName() + " was badly poisoned!"

  endTurn: (pokemon, log) ->
    super pokemon, log
    @multiplier += 1 / 16

  battleMultiplier: (chance) -> 1 + 0.66 * chance / 100

module.exports = BadPoisonStatusAilment