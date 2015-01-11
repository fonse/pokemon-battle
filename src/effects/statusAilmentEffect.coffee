DefaultEffect = require './defaultEffect'
BurnStatusAilment = require '../ailments/burnStatusAilment'

class StatusAilmentEffect extends DefaultEffect
  ailment: () ->
    switch @id
      when 5 then new BurnStatusAilment()

  buildMultiplier: (attacker) ->
    9999
  
  battleMultiplier: (attacker, defender, damage, lethal) ->
    9999
  
  afterDamage: (attacker, defender, damage, log) ->
    # Ailments cannot be overwritten
    return if defender.ailment? or not defender.isAlive()

    ailment = this.ailment()
    defender.ailment = ailment

    ailment.whenInflicted(defender, log)

module.exports = StatusAilmentEffect
