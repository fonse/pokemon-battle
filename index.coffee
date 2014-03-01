Pokemon = require './src/pokemon'
Battle = require './src/battle'

pokemon = {}

pokemon.lookup = (name) ->
  name = name.toLowerCase()
  switch
    when name == 'nidoran f' then 29
    when name == 'nidoran m' then 32
    else (id for id, pkmn of Pokemon.pokedex when name is pkmn.name.toLowerCase())[0]

pokemon.battle = (trainer1, trainer2) ->
  trainer1 = { pokemon: trainer1 } unless trainer1 instanceof Object
  trainer2 = { trainer: 'the foe', pokemon: trainer2 } unless trainer2 instanceof Object
  
  pokemon1 = new Pokemon trainer1.pokemon, trainer1.trainer
  pokemon2 = new Pokemon trainer2.pokemon, trainer2.trainer
  battle = new Battle pokemon1, pokemon2
  return battle.start().toString()
  
pokemon.build = (pokemonId) ->
  pokemon = new Pokemon pokemonId
  
  return (move.toString() for move in pokemon.moves).join("\n").toString()
  
pokemon.buildDebug = (pokemonId) ->
  pokemon = new Pokemon pokemonId
  
  return (move.toString() + " " + move.score for move in pokemon.debug.scoredMoves).join("\n").toString()
  

module.exports = pokemon
