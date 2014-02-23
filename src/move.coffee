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
    @effect = Effect.make move.effect
    @damageClass = move.damage_class
  
  blacklisted: ->
    return @damageClass == @constructor.DAMAGE_NONE or @effect.blacklisted() or @basePower < 2
  
  buildMultiplier: ->
    base = @effect.buildMultiplier()
    
    base *= 1.33 if @priority > 0
    base *= 0.9 if @priority < 0
    
    return base
  
  battleMultiplier: (attacker, defender, damage) ->
    kill = damage >= defender.hp
  
    base = @accuracy / 100
    if @priority > 0 and kill
      base *= 5
      
    base *= @effect.battleMultiplier attacker, defender, damage, kill
    
    return base
  
  effectiveness: (attacker, defender) ->
    effectiveness = @effect.effectiveness attacker, defender

    return if effectiveness? then effectiveness else @type.effectivenessAgainst defender.types
  
  power: ->
    return @effect.power(@basePower)
  
  hits: ->
    return @effect.hits()
  
  afterDamage: (attacker, defender, damage, log) ->
    @effect.afterDamage attacker, defender, damage, log

  toString: ->
    return @name + " (" + @type.name + " - " + @basePower + " power - " + @accuracy + " accuracy)"


module.exports = Move
