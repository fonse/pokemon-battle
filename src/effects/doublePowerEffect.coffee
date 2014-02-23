DefaultEffect = require './defaultEffect'

class DoublePowerEffect extends DefaultEffect
  buildMultiplier: -> 2
  battleMultiplier: (attacker, defender, damage, kill) -> 2
  
  power: (base, attacker, defender) -> base * 2

module.exports = DoublePowerEffect
