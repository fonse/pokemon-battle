RecoilEffect = require './recoilEffect'

class AbsoluteRecoilEffect extends RecoilEffect
  recoil: (damage, pokemon) -> pokemon.hp / 4

module.exports = AbsoluteRecoilEffect
