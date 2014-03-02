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
    
    @stats = {
        base: pokemon.stats,
        stage: {
            attack: 0,
            defense: 0,
            spattack: 0,
            spdefense: 0,
            speed: 0,
        },
    }
    
    @maxHp = 141 + 2 * pokemon.stats.hp
    @hp = @maxHp
    
    @debug = {}
    @debug.helpfulTypes = this.calculateHelpfulTypes
    this.chooseMoves (new Move moveId for moveId in pokemon.moves)
  
  trainerAndName: ->
    if not @trainer?
      return "your " + @name
    else
      return @trainer + "'s " + @name
  
  stat: (stat) -> 36 + 2 * @stats.base[stat] * this.statStageMultiplier @stats.stage[stat]
  attack: -> this.stat 'attack'
  defense: -> this.stat 'defense'
  spattack: -> this.stat 'spattack'
  spdefense: -> this.stat 'spdefense'
  speed: -> this.stat 'speed'
  
  statStageMultiplier: (stage) ->
    switch stage
      when -6 then 2/8
      when -5 then 2/7
      when -4 then 2/6
      when -3 then 2/5
      when -2 then 2/4
      when -1 then 2/3
      when 0 then 1
      when 1 then 1.5
      when 2 then 2
      when 3 then 2.5
      when 4 then 3
      when 5 then 3.5
      when 6 then 4
  
  statName: (stat) ->
    switch stat
      when 'attack' then 'Attack'
      when 'defense' then 'Defense'
      when 'spattack' then 'Special Attack'
      when 'spdefense' then 'Special Defense'
      when 'speed' then 'Speed'
  
  modifyStatStage: (stat, change, log) ->
    statName = this.statName stat
    switch
      when @stats.stage[stat] == 6 and change > 0
        log.message this.trainerAndName() "'s " + statName + " cannot rise any higher."
      when @stats.stage[stat] == -6 and change < 0
        log.message this.trainerAndName() "'s " + statName + " cannot fall any lower."
      else
        change = 6 - @stats.stage[stat] if @stats.stage[stat] + change > 6
        change = -6 - @stats.stage[stat] if @stats.stage[stat] + change < -6
        @stats.stage[stat] += change
        switch change
          when 1 then log.message this.trainerAndName() + "'s " + statName + " rose!"
          when 2 then log.message this.trainerAndName() + "'s " + statName + " sharply rose!"
          when 3 then log.message this.trainerAndName() + "'s " + statName + " drastically rose!"
          when -1 then log.message this.trainerAndName() + "'s " + statName + " fell!"
          when -2 then log.message this.trainerAndName() + "'s " + statName + " harshly fell!"
          when -3 then log.message this.trainerAndName() + "'s " + statName + " severely fell!"
  
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
      
    stat = this.stat move.attackStat()
    move.score = move.power(this) * typeMultiplier * stat * move.accuracy * move.buildMultiplier this
  
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
