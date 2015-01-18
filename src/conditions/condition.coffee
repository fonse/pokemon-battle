class StatusAilment
  inflict: (pokemon, log) ->
    key = @constructor.name
    pokemon.conditions[key] = this

  isInflicted: (pokemon) ->
    key = @constructor.name
    return pokemon.conditions[key]?

  heal: (pokemon) ->
    key = @constructor.name
    delete pokemon.conditions[key]

  canAttack: (pokemon, log) -> true
  endTurn: (pokemon, log) ->

  buildMultiplier: (attacker, chance) -> 1
  battleMultiplier: (attacker, defender, chance) -> 1

module.exports = StatusAilment