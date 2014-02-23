Type = require './type'
Move = require './move'
Pokemon = require './pokemon'
Log = require './log'

class Battle
  constructor: (@pkmn1, @pkmn2) ->
  
  start: ->
    log = new Log
    winner = null
    until winner?
      # Choose moves
      move1 = this.chooseMove @pkmn1, @pkmn2
      move2 = this.chooseMove @pkmn2, @pkmn1
      throw new Error("One of the pokemon doesn't have an attack move.") unless move1? and move2?
      
      # Decide who goes first
      if move1.priority == move2.priority
        pkmn1GoesFirst = @pkmn1.speed > @pkmn2.speed or (@pkmn1.speed == @pkmn2.speed and Math.random() > 0.5)
      else
        pkmn1GoesFirst = move1.priority > move2.priority
      
      if (pkmn1GoesFirst)
        attackerPokemon = @pkmn1
        attackerMove = move1
        defenderPokemon = @pkmn2
        defenderMove = move2
      else
        attackerPokemon = @pkmn2
        attackerMove = move2
        defenderPokemon = @pkmn1
        defenderMove = move1
      
      # Start the battle
      semiturns = 0
      until semiturns == 2 or winner?
        log.message attackerPokemon.trainerAndName() + " used " + attackerMove.name + "!"
        if Math.random() * 100 > attackerMove.accuracy
          log.message attackerPokemon.trainerAndName() + "'s attack missed!"

        else
          effectiveness = attackerMove.type.effectivenessAgainst defenderPokemon.types
          if effectiveness == 0
            log.message "It has no effect!"
          else
            hits = attackerMove.hits()
            hit = 0
            
            until hit++ == hits or winner?
              critical = Math.random() < 0.0625
              random = Math.random() * (1 - 0.85) + 0.85
              damage = this.calculateDamage attackerMove, attackerPokemon, defenderPokemon, critical, random
              damage = defenderPokemon.hp if damage > defenderPokemon.hp
              
              log.message "It's a critical hit!" if critical
              log.message "It's super effective!" if effectiveness > 1
              log.message "It's not very effective..." if effectiveness < 1
              log.message defenderPokemon.trainerAndName() + " is hit for " + damage + " HP (" + Math.round(damage / defenderPokemon.maxHp * 100) + "%)"
              
              defenderPokemon.hp -= damage
              if (defenderPokemon.hp <= 0)
                log.message defenderPokemon.trainerAndName() + " fained!"
                winner = attackerPokemon
                
              attackerMove.afterDamage attackerPokemon, defenderPokemon, damage, log
              if (attackerPokemon.hp <= 0)
                log.message attackerPokemon.trainerAndName() + " fained!"
                winner = defenderPokemon unless winner?
        
        log.endAttack()
        [attackerPokemon, defenderPokemon] = [defenderPokemon, attackerPokemon]
        [attackerMove, defenderMove] = [defenderMove, attackerMove]
        semiturns++
    
      log.endTurn()
    
    winner.hp = 0 if winner.hp < 0  
    log.message "The winner is " + winner.trainerAndName() + " with " + winner.hp + " HP (" + Math.round(winner.hp / winner.maxHp * 100) + "%) remaining!"
    return log
    
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
    
    return bestMove
  
  calculateDamage: (move, attacker, defender, critical = false, random = 0.925) ->
    attack = if move.damageClass == Move.DAMAGE_PHYSICAL then attacker.attack else attacker.spattack
    defense = if move.damageClass == Move.DAMAGE_PHYSICAL then defender.defense else defender.spdefense
    
    stab = if move.type.id in (attacker.types.map (type) -> type.id) then 1.5 else 1
    type = move.type.effectivenessAgainst defender.types
    crit = if critical then 2 else 1
    
    return Math.round (0.88 * (attack / defense) * move.power + 2 ) * stab * type * crit * random
    

module.exports = Battle
