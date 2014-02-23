RecoilEffect = require './recoilEffect'

class StruggleEffect extends RecoilEffect
  recoil: (damage, pokemon) -> pokemon.maxHp / 4
  
  effectiveness: (attacker, defender) -> 1

module.exports = StruggleEffect
