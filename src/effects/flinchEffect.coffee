DefaultEffect = require './defaultEffect'

class FlinchEffect extends DefaultEffect
  buildMultiplier: (attacker) ->
    if attacker.stats.speed >= 80
      return 1 + 0.2 * @chance / 30
    else
      return 1
  
  battleMultiplier: (attacker, defender, damage, lethal) ->
    if attacker.speed() > defender.speed()
      return 1 + 0.2 * @chance / 30
    else
      return 1
  
  afterDamage: (attacker, defender, damage, log) ->
    if Math.random() * 100 < @chance
      defender.flinch = true

  fullSupport: -> @id not in [274, 275, 276]

module.exports = FlinchEffect
