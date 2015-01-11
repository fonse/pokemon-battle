RecoilEffect = require './recoilEffect'

class StruggleEffect extends RecoilEffect
  recoil: (damage, pokemon) -> Math.round(pokemon.maxHp / 4)
  
  effectiveness: (effectiveness, attacker, defender) -> 1

module.exports = StruggleEffect
