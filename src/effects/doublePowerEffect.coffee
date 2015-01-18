DefaultEffect = require './defaultEffect'

class DoublePowerEffect extends DefaultEffect
  power: (base, attacker, defender) -> base * 2

module.exports = DoublePowerEffect
