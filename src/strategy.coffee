Type = require './type'
DamageCalculator = require './damageCalculator'

class Strategy
  
  constructor: (@pokemon) ->
    @helpfulTypes = []
    for weakness in (type for type in Type.all() when type.effectiveAgainst @pokemon.types)
      @helpfulTypes = @helpfulTypes.concat (type.id for type in Type.all() when type.effectiveAgainst weakness)
    

  chooseBuild: (moves) ->
    # Score each move the pokemon can learn
    scoredMoves = []
    for move in moves
      continue if move.banned()
      this.scoreMoveForBuild move
      
      scoredMoves.push(move)
    
    scoredMoves.sort (a,b) -> b.score - a.score
    
    # And keep the best four without repeating types
    chosenMoves = []
    typesCovered = []
    for move in scoredMoves
      if move.type.id not in typesCovered
        chosenMoves.push(move)
        typesCovered.push(move.type.id)
        break if typesCovered.length == 4

    # If no valid move exists, use Struggle
    if chosenMoves.length == 0
      chosenMoves = [ Move.Struggle ]

    return chosenMoves

  scoreMoveForBuild: (move) ->
    typeMultiplier = switch
      when move.type.id in (@pokemon.types.map (type) -> type.id) then 1.5
      when move.type.id in @helpfulTypes then 1.2
      else switch move.type.strengths().length
        when 0,1,2 then 0.9
        when 3 then 1
        else 1.1
      
    stat = @pokemon.stat move.attackStat()
    move.score = move.power(@pokemon) * typeMultiplier * stat * move.accuracy * move.buildMultiplier @pokemon


  chooseMove: (defender) ->
    damageCalculator = new DamageCalculator

    bestMove = null
    bestDamage = -1
    for move in @pokemon.moves
      damage = damageCalculator.calculate move, @pokemon, defender
      damage = defender.hp if defender.hp < damage 
      
      damage *= move.battleMultiplier @pokemon, defender, damage
      
      if damage > bestDamage
        bestMove = move
        bestDamage = damage
    
    @pokemon.move = bestMove


module.exports = Strategy
