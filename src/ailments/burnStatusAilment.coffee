StatusAilment = require './statusAilment'

class BurnStatusAilment extends StatusAilment
  whenInflicted: (pokemon, log) ->
    log.message pokemon.trainerAndName() + " was burned!" if pokemon.hp > 0

  endTurn: (pokemon, log) ->
    #TODO Deal damage
    log.message pokemon.trainerAndName() + " was hurt by its burn!" if pokemon.hp > 0

module.exports = BurnStatusAilment