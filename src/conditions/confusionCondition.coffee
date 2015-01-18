Condition = require './condition'
DamageCalculator = require '../damageCalculator'

class ConfusionCondition extends Condition
  whenInflicted: (pokemon, log) ->
    @turnsLeft = Math.ceil(Math.random() * 4)

  canAttack: (pokemon, log) ->
    if @turnsLeft == 0
      log.message pokemon.trainerAndName() + " snapped out its confusion!"
      this.heal pokemon

    else
      log.message pokemon.trainerAndName() + " is confused!"
      @turnsLeft--
      
      if Math.random() < 0.5
        damageCalculator = new DamageCalculator
        damage = damageCalculator.confusionDamage(pokemon)

        pokemon.takeDamage damage, "It hurn itself %(damage) in its confusion!", log
        return false

    return true

  buildMultiplier: (attacker, chance) -> 1 + 0.4 * chance / 100
  battleMultiplier: (attacker, defender, chance) ->
    this.buildMultiplier attacker, chance

module.exports = ConfusionCondition