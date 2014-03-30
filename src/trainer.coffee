class Trainer
  constructor: (@name) ->
    @team = []
  
  addPokemon: (pokemon) ->
    pokemon.trainer = this
    @team.push(pokemon)
  
  ablePokemon: ->
    pokemon for pokemon in @team when pokemon.hp > 0
  
  firstPokemon: ->
    @mainPokemon = this.team[0];
    
  switchPokemon: (opponent, log) ->
    candidates = (pokemon for pokemon in this.ablePokemon() when pokemon != @mainPokemon)
    maxScore = 0
    
    for pokemon in candidates
      pokemon.score = 0
      
      if pokemon.typeAdvantageAgainst opponent
        pokemon.score += 1
      
      if opponent.typeAdvantageAgainst pokemon
        pokemon.score -= 1
        
      if pokemon.score > maxScore
        maxScore = pokemon.score
    
    bestChoices = (pokemon for pokemon in candidates when pokemon.score == maxScore)
        
    @mainPokemon = bestChoices[Math.floor(Math.random() * bestChoices.length)]
    log.message (if @name? then @name else 'You') + " took out " + @mainPokemon + "."
    
  nameOrYou: -> if @name? then @name else 'you'

module.exports = Trainer
