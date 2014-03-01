DefaultEffect = require './defaultEffect'

class RecoilEffect extends DefaultEffect
  recoil: (damage, pokemon) ->
    switch @id
      when 49 then Math.round(damage / 4)
      when 199, 254, 263 then Math.round(damage / 3)
      when 270 then Math.round(damage / 2)
      else 0

  buildMultiplier: ->
    switch @id
      when 49, 199, 254, 263 then 0.85
      when 270 then 0.5
  
  battleMultiplier: (attacker, defender, damage, kill) ->
    return 1 - this.recoil(damage, attacker) / attacker.hp / 1.5
  
  afterDamage: (attacker, defender, damage, log) ->
    recoil = Math.min (this.recoil damage, attacker), attacker.hp
    
    attacker.hp -= recoil
    log.message attacker.trainerAndName() + " is hurt " +  recoil + " HP (" + Math.round(recoil / attacker.maxHp * 100) + "%) by recoil!"


module.exports = RecoilEffect
