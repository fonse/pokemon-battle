DefaultEffect = require './defaultEffect'

class HealEffect extends DefaultEffect
  heal: (damage) ->
    switch @id
      when 4, 348 then Math.round(damage * 0.5)
      when 353 then Math.round(damage * 0.75)

  buildMultiplier: (attacker) ->
    switch @id
      when 4, 348 then 1.25
      when 353 then 1.5
  
  battleMultiplier: (attacker, defender, damage, lethal) ->
    if attacker.hp < attacker.maxHp
        return 1 + this.heal(damage) / (attacker.maxHp - attacker.hp) / 1.5
    else
        return 1
  
  afterDamage: (attacker, defender, damage, log) ->
    heal = Math.min((this.heal damage), attacker.maxHp - attacker.hp)
    return if heal == 0
    
    attacker.hp += heal
    log.message attacker.trainerAndName() + " healed " +  heal + " HP (" + Math.round(heal / attacker.maxHp * 100) + "%)!"


module.exports = HealEffect
