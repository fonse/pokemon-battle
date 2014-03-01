fs = require 'fs'
Type = require './type'
Move = require './move'

class Pokemon
  this.pokedex = JSON.parse fs.readFileSync(__dirname + '/../data/pokemon.json').toString()

  constructor: (id, trainer) ->
    pokemon = @constructor.pokedex[id]
    throw new Error("Pokemon not found: " + id) unless pokemon?
    
    @name = pokemon.name
    @trainer = trainer
    @types = (new Type typeId for typeId in pokemon.types)
    @weight = pokemon.weight / 10
    
    @maxHp = 141 + 2 * pokemon.stats.hp
    @hp = @maxHp
    @attack = this.statFormula pokemon.stats.attack
    @defense = this.statFormula pokemon.stats.defense
    @spattack = this.statFormula pokemon.stats.spattack
    @spdefense = this.statFormula pokemon.stats.spdefense
    @speed = this.statFormula pokemon.stats.speed
    
    @debug = {}
    @debug.helpfulTypes = this.calculateHelpfulTypes
    this.chooseMoves (new Move moveId for moveId in pokemon.moves)
  
  trainerAndName: ->
    if not @trainer?
      return "your " + @name
    else
      return @trainer + "'s " + @name
    
  statFormula: (base) -> 36 + 2 * base
  
  calculateHelpfulTypes: ->
    helpfulTypes = []
    for weakness in (type for type in Type.all() when type.effectiveAgainst @types)
      helpfulTypes = helpfulTypes.concat (type.id for type in Type.all() when type.effectiveAgainst weakness)
    
    return helpfulTypes
  
  scoreMove: (move) ->
    typeMultiplier = switch
      when move.type.id in (@types.map (type) -> type.id) then 1.5
      when move.type.id in @debug.helpfulTypes then 1.2
      else switch move.type.strengths().length
        when 0,1,2 then 0.9
        when 3 then 1
        else 1.1
      
    stat = if move.damageClass == Move.DAMAGE_PHYSICAL then @attack else @spattack
    move.score = move.power(this) * typeMultiplier * stat * move.accuracy * move.buildMultiplier()
  
  chooseMoves: (moves) ->
    # Score each move this pokemon can learn
    scoredMoves = []
    for move in moves
      continue if move.banned()
      this.scoreMove move
      
      scoredMoves.push(move)
    
    scoredMoves.sort (a,b) -> b.score - a.score
    @debug.scoredMoves = scoredMoves
    
    # And keep the best four without repeating types
    @moves = []
    typesCovered = []
    for move in scoredMoves
      if move.type.id not in typesCovered
        @moves.push(move)
        typesCovered.push(move.type.id)
        break if typesCovered.length == 4
    
    # If no valid move exists, use Struggle
    if @moves.length == 0
      @moves = [ Move.Struggle ]

  toString: ->
    return @name
    
    
module.exports = Pokemon
