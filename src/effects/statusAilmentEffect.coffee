DefaultEffect = require './defaultEffect'
BurnStatusAilment = require '../ailments/burnStatusAilment'

class StatusAilmentEffect extends DefaultEffect
  ailment: () ->
    switch @id
      when 5 then new BurnStatusAilment()

  buildMultiplier: (attacker) ->
    9999
  
  battleMultiplier: (attacker, defender, damage, kill) ->
    9999
  
  afterDamage: (attacker, defender, damage, log) ->
    # Ailments cannot be overwritten
    return if defender.ailment?

    ailment = this.ailment()
    defender.ailment = ailment

    ailment.whenInflicted(defender, log)

module.exports = StatusAilmentEffect
