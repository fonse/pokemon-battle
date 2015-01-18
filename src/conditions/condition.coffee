class StatusAilment
  inflict: (pokemon, log) ->
    key = @constructor.name
    pokemon.conditions[key] = this
    this.whenInflicted pokemon, log

  isInflicted: (pokemon) ->
    key = @constructor.name
    return pokemon.conditions[key]?

  heal: (pokemon) ->
    key = @constructor.name
    delete pokemon.conditions[key]

  whenInflicted: (pokemon, log) ->
  canAttack: (pokemon, log) -> true
  endTurn: (pokemon, log) ->

  buildMultiplier: (attacker, chance) -> 1
  battleMultiplier: (attacker, defender, chance) -> 1

module.exports = StatusAilment