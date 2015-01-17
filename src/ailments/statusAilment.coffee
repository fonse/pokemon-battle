class StatusAilment
  affects: (pokemon) -> true
  
  whenInflicted: (pokemon, log) ->
  whenSwitchedOut: (pokemon) ->
  
  canAttack: (pokemon, log) -> true
  endTurn: (pokemon, log) ->

  statMultiplier: (stat) -> 1
  battleMultiplier: (chance) -> 1

module.exports = StatusAilment