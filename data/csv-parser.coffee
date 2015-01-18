csv = require 'csv'
fs = require 'fs'

path = process.argv[2] ? __dirname + '/pokedex/pokedex/data/csv'
options = { delimiter: ',', escape: '"', columns: true }

language = '9'
version_group = '15'

write_json = (filename, object) ->
  fs.writeFile __dirname + '/' + filename, JSON.stringify object, null, 2

Array::unique = ->
  output = {}
  output[@[key]] = @[key] for key in [0...@length]
  value for key, value of output

fs.exists path, (exists) ->
  if exists
    # Pokemon
    csv()
    .from.path(path + "/pokemon.csv", options)
    .to.array (rows) ->
      pokemons = {}
      for row in rows
        if row.is_default == '1'
          pokemons[row.id] = {
            id: +row.id,
            name: '',
            types: [],
            stats: {},
            moves: [],
            weight: +row.weight,
            height: +row.height,
          }
      
      csv()
      .from.path(path + "/pokemon_species_names.csv", options)
      .to.array (rows) ->
        for row in rows
          if row.local_language_id == language
            pokemons[row.pokemon_species_id].name = row.name
            
        csv()
        .from.path(path + "/pokemon_types.csv", options)
        .to.array (rows) ->
          for row in rows
            pokemons[row.pokemon_id].types.push +row.type_id if pokemons[row.pokemon_id]

          csv()
          .from.path(path + "/pokemon_stats.csv", options)
          .to.array (rows) ->
            stats = { 1: 'hp', 2: 'attack', 3: 'defense', 4: 'spattack', 5: 'spdefense', 6: 'speed' }
            for row in rows
              pokemons[row.pokemon_id].stats[stats[row.stat_id]] = +row.base_stat if pokemons[row.pokemon_id]
            
            csv()
            .from.path(path + "/pokemon_moves.csv", options)
            .to.array (rows) ->
              for row in rows
                if row.version_group_id == version_group and +row.pokemon_move_method_id < 5 +row.move_id < 10000
                  pokemons[row.pokemon_id].moves.push(+row.move_id) if pokemons[row.pokemon_id]
              
              csv()
              .from.path(path + "/pokemon_species.csv", options)
              .to.array (rows) ->
                evolutions = {}
                for row in rows
                  evolutions[row.id] = {
                    id: +row.id,
                    chain: +row.evolution_chain_id,
                    preevolution: +row.evolves_from_species_id,
                  }
                
                csv()
                .from.path(path + "/evolution_chains.csv", options)
                .to.array (rows) ->
                  for row in rows
                    chain = (evolution for id, evolution of evolutions when evolution.chain == +row.id)
                    chain.sort (a,b) ->
                      switch
                        when a.preevolution == 0 or b.preevolution == a.id then -1
                        when b.preevolution == 0 or a.preevolution == b.id then 1
                        else 0
                    
                    for link in chain
                      pokemons[link.id].moves = pokemons[link.id].moves.concat(pokemons[link.preevolution].moves) if link.preevolution != 0
                      pokemons[link.id].moves = pokemons[link.id].moves.unique()
                    
                  write_json 'pokemon.json', pokemons
    
    
    # Moves
    csv()
    .from.path(path + "/moves.csv", options)
    .to.array (rows) ->
      moves = {}
      damages = { 1: 'non-damaging', 2:'physical', 3:'special' }
      for row in rows
        if row.id < 10000 and +row.effect_id < 10000
          moves[row.id] = {
            id: +row.id
            name: '',
            type: +row.type_id,
            power: +row.power,
            accuracy: +row.accuracy,
            pp: +row.pp,
            priority: +row.priority,
            damage_class: damages[+row.damage_class_id],
            effect: +row.effect_id,
            effect_chance: +row.effect_chance,
          }
      
      csv()
      .from.path(path + "/move_names.csv", options)
      .to.array (rows) ->
        for row in rows
          if row.local_language_id == language
            moves[row.move_id].name = row.name if moves[row.move_id]?
      
        write_json 'moves.json', moves
       
    # Types
    csv()
    .from.path(path + "/type_names.csv", options)
    .to.array (rows) ->
      types = {}
      for row in rows
        if row.local_language_id == language and row.type_id < 10000
          types[row.type_id] = {
            id: +row.type_id
            name: row.name,
            offense: {},
            defense: {},
          }
      
      csv()
      .from.path(path + "/type_efficacy.csv", options)
      .to.array (rows) ->
        for row in rows
          types[row.damage_type_id].offense[row.target_type_id] = row.damage_factor / 100
          types[row.target_type_id].defense[row.damage_type_id] = row.damage_factor / 100
          
        write_json 'types.json', types
    
  else
    console.log "Usage: coffe " + process.argv[1] + " path/to/csvs\n"
