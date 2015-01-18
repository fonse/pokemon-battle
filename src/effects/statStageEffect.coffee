DefaultEffect = require './defaultEffect'

class StatStageEffect extends DefaultEffect
  target: (attacker, defender) ->
    switch @id
      when 139, 140, 141, 205, 219, 230, 277, 296, 335 then attacker
      when 21, 69, 70, 71, 72, 73, 272, 297, 331 then defender
    
  stats: ->
    switch  @id
      when 69 then { attack: -1 }
      when 70 then { defense: -1 }
      when 72 then { spattack: -1 }
      when 73 then { spdefense: -1 }
      when 21, 71, 331 then { speed: -1 }
      
      when 140 then { attack: 1 }
      when 139 then { defense: 1 }
      when 277 then { spattack: 1 }
      when 219, 296 then { speed: 1 }
      
      when 205 then { spattack: -2 }
      when 272, 297 then { spdefense: -2 }
      when 230 then { defense: -1, spdefense: -1 }
      when 335 then { defense: -1, spdefense: -1, speed: -1 }
      when 141 then { attack: 1, defense: 1, spattack: 1, spdefense: 1, speed: 1 }
    
  buildMultiplier: (attacker) ->
    totalChanges = (change for stat, change of this.stats()).reduce (x,y) -> x+y
    if this.target true, false
      # If targets self
      return 1 + 0.25 * totalChanges * @chance / 100
    else
      # If targets enemy
      return 1 - 0.25 * totalChanges * @chance / 100
      
  battleMultiplier: (attacker, defender, damage, lethal) -> this.buildMultiplier attacker
  
  afterDamage: (attacker, defender, damage, log) ->
    target = this.target attacker, defender
    if Math.random() * 100 < @chance and target.isAlive()
      for stat, change of this.stats()
        target.modifyStatStage stat, change, log

  
module.exports = StatStageEffect
