DefaultEffect = require './defaultEffect'
FlinchCondition = require '../conditions/flinchCondition'

class ConditionEffect extends DefaultEffect
  condition: () ->
    switch @id
      when 32, 147, 151, 274, 275, 276 then new FlinchCondition

  buildMultiplier: (attacker) ->
    condition = this.condition()
    return condition.buildMultiplier attacker, @chance 
  
  battleMultiplier: (attacker, defender, damage, lethal) ->
    condition = this.condition()
    return condition.battleMultiplier attacker, defender, @chance
  
  afterDamage: (attacker, defender, damage, log) ->
    return unless defender.isAlive()

    condition = this.condition()
    if not condition.isInflicted(defender) and Math.random() * 100 < @chance
      condition.inflict defender

module.exports = ConditionEffect
