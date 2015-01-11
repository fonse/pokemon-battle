DefaultEffect = require './defaultEffect'

class DoublePowerEffect extends DefaultEffect
  buildMultiplier: (attacker) -> 2
  battleMultiplier: (attacker, defender, damage, lethal) -> 1
  
  power: (base, attacker, defender) -> base * 2

module.exports = DoublePowerEffect
