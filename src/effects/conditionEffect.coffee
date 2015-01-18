DefaultEffect = require './defaultEffect'
FlinchCondition = require '../conditions/flinchCondition'
ConfusionCondition = require '../conditions/confusionCondition'

class ConditionEffect extends DefaultEffect
  condition: () ->
    switch @id
      when 32, 147, 151, 274, 275, 276 then new FlinchCondition
      when 77, 268, 338 then new ConfusionCondition

  buildMultiplier: (attacker) ->
    condition = this.condition()
    return condition.buildMultiplier attacker, @chance 
  
  battleMultiplier: (attacker, defender, damage, lethal) ->
    condition = this.condition()
    unless condition.isInflicted(defender)
      return condition.battleMultiplier attacker, defender, @chance
    else
      return 1
  
  afterDamage: (attacker, defender, damage, log) ->
    return unless defender.isAlive()

    condition = this.condition()
    if not condition.isInflicted(defender) and Math.random() * 100 < @chance
      condition.inflict defender

module.exports = ConditionEffect
