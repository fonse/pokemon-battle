Pokemon = require './src/pokemon'
Battle = require './src/battle'

pokemon = {}

pokemon.lookup = (name) ->
  name = name.toLowerCase()
  switch
    when name == 'nidoran f' then 29
    when name == 'nidoran m' then 32
    else (id for id, pkmn of Pokemon.pokedex when name is pkmn.name.toLowerCase())[0]

pokemon.battle = (team1, team2) ->
  team1 = { pokemon: team1 } unless team1 instanceof Object and team1 not instanceof Array
  team2 = { trainer: 'the foe', pokemon: team2 } unless team2 instanceof Object and team2 not instanceof Array
  
  team1.pokemon = [ team1.pokemon ] unless team1.pokemon instanceof Array
  team2.pokemon = [ team2.pokemon ] unless team2.pokemon instanceof Array
  
  pokemon1 = (new Pokemon pokemon, team1.trainer for pokemon in team1.pokemon)
  pokemon2 = (new Pokemon pokemon, team2.trainer for pokemon in team2.pokemon)

  battle = new Battle pokemon1, pokemon2
  return battle.start().toString()
  
pokemon.build = (pokemonId) ->
  pokemon = new Pokemon pokemonId
  
  return (move.toString() for move in pokemon.moves).join("\n").toString()
  
pokemon.buildDebug = (pokemonId) ->
  pokemon = new Pokemon pokemonId
  
  return (move.toString() + " " + move.score for move in pokemon.debug.scoredMoves).join("\n").toString()
  

module.exports = pokemon
