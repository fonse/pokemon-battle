DefaultEffect = require './defaultEffect'

class RecoilOnMissEffect extends DefaultEffect
  buildMultiplier: (attacker) -> 0.9
  
  battleMultiplier: (attacker, defender, damage, lethal) -> 0.9
  
  afterMiss: (attacker, defender, log) ->
    recoil = Math.min Math.floor(attacker.maxHp / 2), attacker.hp
    
    attacker.hp -= recoil
    log.message attacker.trainerAndName() + " kept going and crashed for " + recoil + " HP (" + Math.round(recoil / attacker.maxHp * 100) + "%)!"


module.exports = RecoilOnMissEffect
