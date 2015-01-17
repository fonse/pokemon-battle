class Trainer
  constructor: (@name) ->
    @team = []
  
  addPokemon: (pokemon) ->
    pokemon.trainer = this
    @team.push(pokemon)
  
  ablePokemon: ->
    pokemon for pokemon in @team when pokemon.isAlive()
  
  firstPokemon: ->
    @mainPokemon = this.team[0];
  
  maybeSwitchOut: (own, opponent, log) ->
    # 67% chance to not switch out
    if Math.random() < 0.67
      return own
    
    # Only switch out against pokemon strong against you
    unless opponent.typeAdvantageAgainst own
      return own
    
    # Also make sure you have at least a neutral alternative
    unless (pokemon for pokemon in this.ablePokemon() when not opponent.typeAdvantageAgainst pokemon).length > 0
      return own

    log.message this.nameOrYou() + " withdrew " + own + "."
    this.switchPokemon opponent, log

    return @mainPokemon
  
  switchPokemon: (opponent, log) ->
    # Reset current pokemon's stats
    @mainPokemon.stats.stage = {
      attack: 0,
      defense: 0,
      spattack: 0,
      spdefense: 0,
      speed: 0,
    }
  
    #TODO Maybe consider fast pokemon against low-HP pokemon?
    candidates = (pokemon for pokemon in this.ablePokemon() when pokemon != @mainPokemon)
    maxScore = -1
    
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
    @mainPokemon.whenSwitchedOut() if @mainPokemon?
    
    log.message this.nameOrYou() + " took out " + @mainPokemon + "."
    return @mainPokemon
  
  nameOrYou: -> if @name? then @name else 'you'


module.exports = Trainer
