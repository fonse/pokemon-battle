class StatusAilment
  affects: (pokemon) -> true
  whenInflicted: (pokemon, log) ->
  endTurn: (pokemon, log) ->

  statMultiplier: (stat) -> 1
  battleMultiplier: (chance) -> 1

module.exports = StatusAilment