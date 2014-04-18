Pokemon = require './src/pokemon'
Trainer = require './src/trainer'
Battle = require './src/battle'

pokemon = {}

pokemon.lookup = (name) ->
  name = name.toLowerCase()
  switch
    when name == 'nidoran f' then 29
    when name == 'nidoran m' then 32
    else (id for id, pkmn of Pokemon.pokedex when name is pkmn.name.toLowerCase())[0]

pokemon.battle = (team1, team2) ->
  # Standarize input
  team1 = { trainer: null,      pokemon: team1 } unless team1 instanceof Object and team1 not instanceof Array
  team2 = { trainer: 'the foe', pokemon: team2 } unless team2 instanceof Object and team2 not instanceof Array
  
  team1.pokemon = [ team1.pokemon ] unless team1.pokemon instanceof Array
  team2.pokemon = [ team2.pokemon ] unless team2.pokemon instanceof Array
  
  # Build trainers
  trainer1 = new Trainer team1.trainer
  trainer1.addPokemon new Pokemon pokemon for pokemon in team1.pokemon
  
  trainer2 = new Trainer team2.trainer
  trainer2.addPokemon new Pokemon pokemon for pokemon in team2.pokemon

  # Fight!  
  battle = new Battle trainer1, trainer2
  return battle.start().toString()
  
pokemon.build = (pokemonId) ->
  pokemon = new Pokemon pokemonId
  
  return (move.toString() for move in pokemon.moves).join("\n").toString()
  
pokemon.buildDebug = (pokemonId) ->
  pokemon = new Pokemon pokemonId
  
  return (move.toString() + " " + move.score for move in pokemon.debug.scoredMoves).join("\n").toString()
  

module.exports = pokemon
