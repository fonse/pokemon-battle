DefaultEffect = require './defaultEffect'

class RecoilEffect extends DefaultEffect
  recoil: (damage, pokemon) ->
    switch @id
      when 49 then Math.round(damage / 4)
      when 199, 254, 263 then Math.round(damage / 3)
      when 270 then Math.round(damage / 2)
      else 0

  buildMultiplier: (attacker) ->
    switch @id
      when 49, 199, 254, 263 then 0.85
      when 270 then 0.5
  
  battleMultiplier: (attacker, defender, damage, lethal) ->
    return 1 - this.recoil(damage, attacker) / attacker.hp / 1.5
  
  afterDamage: (attacker, defender, damage, log) ->
    recoil = attacker.takeDamage(this.recoil damage, attacker)
    log.message attacker.trainerAndName() + " was hurt " +  recoil + " HP (" + Math.round(recoil / attacker.maxHp * 100) + "%) by recoil!"

  fullSupport: -> @id not in [254, 263]
  
  
module.exports = RecoilEffect
