Type = require './type'
Move = require './move'
Pokemon = require './pokemon'
Log = require './log'

class Battle
  constructor: (@trainer1, @trainer2) ->
    @trainer1.firstPokemon()
    @trainer2.firstPokemon()
  
  start: ->
    @log = new Log
    @winner = null
    until @winner?
      this.nextTurn()
    
    loser = if @winner == @trainer1 then @trainer2 else @trainer1
    @log.message @winner.nameOrYou() + " defeated " + loser.nameOrYou() + "!"
    for pokemon in @winner.team
      @log.message pokemon.name + ": " + pokemon.hp + " HP (" + Math.round(pokemon.hp / pokemon.maxHp * 100) + "%) left."

    return @log
  
  nextTurn: ->
    pokemon1 = @trainer1.mainPokemon
    pokemon2 = @trainer2.mainPokemon

    # Choose moves
    this.chooseMove pokemon1, pokemon2
    this.chooseMove pokemon2, pokemon1
    throw new Error("One of the pokemon doesn't have an attack move.") unless pokemon1.move? and pokemon2.move?
    
    # Clear temp status
    pokemon1.flinch = false
    pokemon2.flinch = false
    
    # Switch out pokemon?
    newPokemon1 = pokemon1.trainer.maybeSwitchOut pokemon1, pokemon2, @log
    newPokemon2 = pokemon2.trainer.maybeSwitchOut pokemon2, pokemon1, @log
    pokemon1 = newPokemon1
    pokemon2 = newPokemon2

    # Decide who goes first
    unless pokemon1.move? and pokemon2.move?
      pkmn1GoesFirst = true
    else if pokemon1.move.priority == pokemon2.move.priority
      pkmn1GoesFirst = pokemon1.speed() > pokemon2.speed() or (pokemon1.speed() == pokemon2.speed() and Math.random() < 0.5)
    else
      pkmn1GoesFirst = pokemon1.move.priority > pokemon2.move.priority

    if (pkmn1GoesFirst)
      attacker = pokemon1
      defender = pokemon2
    else
      attacker = pokemon2
      defender = pokemon1
    
    # Perform the attacks
    defenderFainted = this.doAttack attacker, defender if attacker.move?
    attacker = attacker.trainer.mainPokemon # Moves like U-turn can force a switch
    
    this.doAttack defender, attacker if defender.move? and not defenderFainted
    @log.endTurn()
  
  doAttack: (attacker, defender) ->
    if attacker.flinch
      @log.message attacker.trainerAndName() + " flinched and couldn't move!"
      return false
  
    @log.message attacker.trainerAndName() + " used " + attacker.move.name + "!"
    effectiveness = attacker.move.effectiveness attacker, defender
    miss = false

    if effectiveness == 0
      @log.message "It doesn't affect " + defender.trainerAndName() + "..."
      miss = true

    else
      if Math.random() * 100 > attacker.move.accuracy
        @log.message attacker.trainerAndName() + "'s attack missed!"
        miss = true
      
      else
        hits = attacker.move.hits()
        hit = 0
        miss = false
        
        attackerFainted = false
        defenderFainted = false
        until (hit++ == hits) or attackerFainted or defenderFainted
          critical = Math.random() < this.criticalChance attacker.move.criticalRateStage()
          random = Math.random() * (1 - 0.85) + 0.85
          damage = this.calculateDamage attacker.move, attacker, defender, critical, random
          damage = defender.hp if damage > defender.hp
          
          @log.message "It's a critical hit!" if critical
          @log.message "It's super effective!" if effectiveness > 1
          @log.message "It's not very effective..." if effectiveness < 1
          @log.message defender.trainerAndName() + " is hit for " + damage + " HP (" + Math.round(damage / defender.maxHp * 100) + "%)"
          
          defender.hp -= damage
          defenderFainted = this.checkFaint defender
            
          attacker.move.afterDamage attacker, defender, damage, @log
          attackerFainted = this.checkFaint attacker
          
    if miss
      attacker.move.afterMiss attacker, defender, @log
      attackerFainted = this.checkFaint attacker
    
    if defenderFainted and not @winner?
      defender.trainer.switchPokemon attacker, @log
      
    if attackerFainted and not @winner?
      attacker.trainer.switchPokemon defender, @log
    
    @log.endAttack()
    return defenderFainted
    
  checkFaint: (pokemon) ->
    result = false
    if (pokemon.hp <= 0)
      pokemon.hp = 0
      @log.message pokemon.trainerAndName() + " fainted!"
      result = true
    
    if pokemon.trainer.ablePokemon().length == 0
      otherTrainer = if pokemon.trainer == @trainer1 then @trainer2 else @trainer1
      @winner = otherTrainer unless @winner
    
    return result
  
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
  
  criticalChance: (stage) ->
    switch stage
      when 0 then 1/16
      when 1 then 1/8
      when 2 then 1/2
      else 1
  
  calculateDamage: (move, attacker, defender, critical = false, random = 0.9) ->
    attack = attacker.stat move.attackStat(), {ingoreNegative: critical}
    defense = defender.stat move.defenseStat(), {ingorePositive: critical}
    
    stab = if move.type.id in (attacker.types.map (type) -> type.id) then 1.5 else 1
    type = move.effectiveness attacker, defender
    crit = if critical then 1.5 else 1
    
    return Math.round (0.88 * (attack / defense) * move.power(attacker, defender) + 2 ) * stab * type * crit * random
    

module.exports = Battle
