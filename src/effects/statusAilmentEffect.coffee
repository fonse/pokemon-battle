DefaultEffect = require './defaultEffect'
BurnStatusAilment = require '../ailments/burnStatusAilment'
ParalysisStatusAilment = require '../ailments/paralysisStatusAilment'
FreezeStatusAilment = require '../ailments/freezeStatusAilment'
PoisonStatusAilment = require '../ailments/poisonStatusAilment'
BadPoisonStatusAilment = require '../ailments/badPoisonStatusAilment'

class StatusAilmentEffect extends DefaultEffect
  ailment: () ->
    switch @id
      when 3, 78, 210 then new PoisonStatusAilment
      when 5, 201, 254, 274 then new BurnStatusAilment
      when 6, 261, 275 then new FreezeStatusAilment
      when 7, 153, 263, 276 then new ParalysisStatusAilment
      when 203 then new BadPoisonStatusAilment

  buildMultiplier: (attacker) ->
    ailment = this.ailment()
    return ailment.battleMultiplier @chance
  
  battleMultiplier: (attacker, defender, damage, lethal) ->
    ailment = this.ailment()
    if not defender.ailment? and ailment.affects(defender)
      return ailment.battleMultiplier @chance
    else
      return 1
  
  afterDamage: (attacker, defender, damage, log) ->
    # Ailments cannot be overwritten
    return if defender.ailment? or not defender.isAlive()

    ailment = this.ailment()
    if ailment.affects(defender) and Math.random() * 100 < @chance
      defender.ailment = ailment
      ailment.whenInflicted(defender, log)

module.exports = StatusAilmentEffect
