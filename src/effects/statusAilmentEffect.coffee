DefaultEffect = require './defaultEffect'
BurnStatusAilment = require '../ailments/burnStatusAilment'

class StatusAilmentEffect extends DefaultEffect
  ailment: () ->
    switch @id
      when 5, 254 then new BurnStatusAilment()

  buildMultiplier: (attacker) ->
    ailment = this.ailment()
    return ailment.battleMultiplier(@chance)
  
  battleMultiplier: (attacker, defender, damage, lethal) ->
    ailment = this.ailment()
    if ailment.affects(defender)
      return ailment.battleMultiplier(@chance)
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
