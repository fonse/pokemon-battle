fs = require 'fs'
Type = require './type'

class Move
  @DAMAGE_NONE = 'non-damaging'
  @DAMAGE_PHYSICAL = 'physical'
  @DAMAGE_SPECIAL = 'special'
  
  this.movedex = JSON.parse fs.readFileSync(__dirname + '/../data/moves.json').toString()
  
  this.Struggle = new this(165)
  
  constructor: (id) ->
    move = @constructor.movedex[id]
    throw new Error("Move not found: " + id) unless move?
    
    @id = move.id
    @name = move.name
    @type = new Type move.type
    @power = move.power
    @accuracy = move.accuracy ? 100
    @priority = move.priority
    @effect = move.effect
    @damageClass = move.damage_class
  
  blacklisted: -> 
    blacklist = [8, 9, 27, 28, 39, 40, 76, 81, 105, 136, 146, 149, 152, 156, 159, 160, 171, 183, 191, 205, 230, 247, 249, 256, 257, 273, 293, 298, 312, 332, 333, 46]
    return @damageClass == @constructor.DAMAGE_NONE or @effect in blacklist or @power < 2
  
  scoreModifier: ->
    base = switch @effect
      # Heal
      when 4 then 1.25
      
      # Recoil
      when 49, 199, 254, 263 then 0.85
      when 270 then 0.5
      
      # Multi-hit
      when 30 then 3.166
      when 45, 78 then 2
      
      else 1
    
    base *= 1.33 if @priority > 0
    base *= 0.9 if @priority < 0
    
    return base
  
  chooseModifier: (attacker, defender, damage) ->
    kill = damage >= defender.hp
  
    base = @accuracy / 100
    base *= 1 - this.recoil(damage) / attacker.hp / 1.5
    
    if attacker.hp < attacker.maxHp
      base *= 1 + this.heal(damage) / (attacker.maxHp - attacker.hp) / 1.5
    
    if @priority > 0 and kill
      base *= 5
    
    if not kill  
      switch @effect
        # Multi-hit
        when 30 then base *= 3.166
        when 45, 78 then base *= 2
    
    return base
  
  recoil: (damage) ->
    switch @effect
      when 49 then damage / 4
      when 199, 254, 263 then damage / 3
      when 270 then damage / 2
      else 0
      
  heal: (damage) ->
    if @effect == 4 then damage / 2 else 0
    
  hits: (damage) ->
    switch @effect
      when 30 then [2,2,3,3,4,5][Math.floor(Math.random() * 6)]
      when 45, 78 then 2
      else 1
  
  afterDamage: (attacker, defender, damage, messages) ->
    switch @effect
      when 4 then selfHeal = this.heal damage
      when 49, 199, 254, 263, 270 then selfDamage = this.recoil damage
      when 255 then selfDamage = attacker.maxHp / 4
    
    if selfHeal? and attacker.hp < attacker.maxHp
      selfHeal = Math.min(Math.round(selfHeal), attacker.maxHp - attacker.hp)
      attacker.hp += selfHeal
      messages.push(attacker.trainerAndName() + " healed " +  selfHeal + " HP (" + Math.round(selfHeal / attacker.maxHp * 100) + "%)!")
    
    if selfDamage?
      selfDamage = Math.round(selfDamage)
      attacker.hp -= selfDamage
      messages.push(attacker.trainerAndName() + " is hurt " +  selfDamage + " HP (" + Math.round(selfDamage / attacker.maxHp * 100) + "%) by recoil!")

  toString: ->
    return @name + " (" + @type.name + " - " + @power + " power - " + @accuracy + " accuracy)"


module.exports = Move
