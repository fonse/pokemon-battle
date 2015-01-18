fs = require 'fs'
Type = require './type'
Effect = require './effect'

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
    @basePower = move.power
    @accuracy = if move.accuracy > 0 then move.accuracy else 100
    @priority = move.priority
    @effect = Effect.make move.effect, move.effect_chance
    @damageClass = move.damage_class
  
  banned: ->
    return @damageClass == @constructor.DAMAGE_NONE or @effect.banned() or this.power() < 2
  
  attackStat: -> if @damageClass == @constructor.DAMAGE_PHYSICAL then 'attack' else 'spattack'
  defenseStat: -> if @damageClass == @constructor.DAMAGE_PHYSICAL then 'defense' else 'spdefense'
  
  buildMultiplier: (attacker) ->
    base = @effect.buildMultiplier attacker
    
    base *= 1.33 if @priority > 0
    base *= 0.9 if @priority < 0
    
    return base
  
  battleMultiplier: (attacker, defender, damage) ->
    lethal = damage >= defender.hp
  
    base = @accuracy / 100
    if @priority > 0 and lethal
      base *= 5
      
    base *= @effect.battleMultiplier attacker, defender, damage, lethal
    
    return base
  
  effectiveness: (attacker, defender) ->
    effectiveness = @type.effectivenessAgainst defender.types
    return @effect.effectiveness effectiveness, attacker, defender
  
  power: (attacker, defender) ->
    return @effect.power @basePower, attacker, defender
  
  hits: ->
    return @effect.hits()
  
  criticalRateStage: ->
    return @effect.criticalRateStage()
  
  afterDamage: (attacker, defender, damage, log) ->
    @effect.afterDamage attacker, defender, damage, log
    
  afterMiss: (attacker, defender, log) ->
    @effect.afterMiss attacker, defender, log

  toString: ->
    return @name + " (" + @type.name + " - " + (if @basePower == 1 then 'X' else @basePower) + " power - " + @accuracy + " accuracy)"


module.exports = Move
