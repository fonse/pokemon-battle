StatusAilment = require './statusAilment'

class ParalysisStatusAilment extends StatusAilment
  affects: (pokemon) ->
    return 'Electric' not in (type.name for type in pokemon.types)
  
  whenInflicted: (pokemon, log) ->
    log.message pokemon.trainerAndName() + " was paralyzed! It may be unable to move!"

  canAttack: (pokemon, log) ->
    if Math.random() < 0.25
      log.message pokemon.trainerAndName() + " is paralyzed! It can't move!"
      return false

  statMultiplier: (stat) ->
    switch stat
      when 'speed' then 0.25
      else 1

  # This makes Discharge slightly worse than Thunderbolt
  battleMultiplier: (chance) -> 1 + 0.5 * chance / 100

module.exports = ParalysisStatusAilment