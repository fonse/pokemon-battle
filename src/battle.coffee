Type = require './type'
Move = require './move'
Pokemon = require './pokemon'
Log = require './log'

class Battle
  constructor: (@pkmn1, @pkmn2) ->
  
  start: ->
    @log = new Log
    @winner = null
    until @winner?
      this.nextTurn()
    
    @winner.hp = 0 if @winner.hp < 0  
    @log.message "The winner is " + @winner.trainerAndName() + " with " + @winner.hp + " HP (" + Math.round(@winner.hp / @winner.maxHp * 100) + "%) remaining!"
    return @log
  
  nextTurn: ->
    # Choose moves
    this.chooseMove @pkmn1, @pkmn2
    this.chooseMove @pkmn2, @pkmn1
    throw new Error("One of the pokemon doesn't have an attack move.") unless @pkmn1.move? and @pkmn2.move?
    
    # Decide who goes first
    if @pkmn1.move.priority == @pkmn2.move.priority
      pkmn1GoesFirst = @pkmn1.speed > @pkmn2.speed or (@pkmn1.speed == @pkmn2.speed and Math.random() < 0.5)
    else
      pkmn1GoesFirst = @pkmn1.move.priority > @pkmn2.move.priority
    
    if (pkmn1GoesFirst)
      attacker = @pkmn1
      defender = @pkmn2
    else
      attacker = @pkmn2
      defender = @pkmn1
    
    # Perform the attacks
    this.doAttack attacker, defender
    this.doAttack defender, attacker unless @winner?
    @log.endTurn()
  
  doAttack: (attacker, defender) ->
    @log.message attacker.trainerAndName() + " used " + attacker.move.name + "!"
    if Math.random() * 100 > attacker.move.accuracy
      @log.message attacker.trainerAndName() + "'s attack missed!"

    else
      effectiveness = attacker.move.effectiveness attacker, defender
      if effectiveness == 0
        @log.message "It has no effect!"
      else
        hits = attacker.move.hits()
        hit = 0
        
        until hit++ == hits or @winner?
          critical = Math.random() < 0.0625
          random = Math.random() * (1 - 0.85) + 0.85
          damage = this.calculateDamage attacker.move, attacker, defender, critical, random
          damage = defender.hp if damage > defender.hp
          
          @log.message "It's a critical hit!" if critical
          @log.message "It's super effective!" if effectiveness > 1
          @log.message "It's not very effective..." if effectiveness < 1
          @log.message defender.trainerAndName() + " is hit for " + damage + " HP (" + Math.round(damage / defender.maxHp * 100) + "%)"
          
          defender.hp -= damage
          this.checkFaint attacker, defender
            
          attacker.move.afterDamage attacker, defender, damage, @log
          this.checkFaint defender, attacker
    
    @log.endAttack()
    
  checkFaint: (attacker, defender) ->
    if (defender.hp <= 0)
      @log.message defender.trainerAndName() + " fained!"
      @winner = attacker unless @winner
   
  chooseMove: (attacker, defender) ->
    bestMove = null
    bestDamage = -1
    for move in attacker.moves
      damage = this.calculateDamage move, attacker, defender
      damage = defender.hp if defender.hp < damage 
      
      damage *= move.battleMultiplier attacker, defender, damage
      
      if damage > bestDamage
        bestMove = move
        bestDamage = damage
    
    attacker.move = bestMove
  
  calculateDamage: (move, attacker, defender, critical = false, random = 0.925) ->
    attack = if move.damageClass == Move.DAMAGE_PHYSICAL then attacker.attack else attacker.spattack
    defense = if move.damageClass == Move.DAMAGE_PHYSICAL then defender.defense else defender.spdefense
    
    stab = if move.type.id in (attacker.types.map (type) -> type.id) then 1.5 else 1
    type = move.effectiveness attacker, defender
    crit = if critical then 1.5 else 1
    
    return Math.round (0.88 * (attack / defense) * move.power() + 2 ) * stab * type * crit * random
    

module.exports = Battle
