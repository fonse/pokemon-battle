StatusAilment = require './statusAilment'

class FreezeStatusAilment extends StatusAilment
  whenInflicted: (pokemon, log) ->
    log.message pokemon.trainerAndName() + " was frozen solid!"

  canAttack: (pokemon, log) ->
    if Math.random() < 0.20
      log.message pokemon.trainerAndName() + " thawed out!"
      pokemon.ailment = null
      return true
      
    else
      log.message pokemon.trainerAndName() + " is frozen solid!"
      return false

  battleMultiplier: (chance) -> 1 + 0.5 * chance / 100

module.exports = FreezeStatusAilment