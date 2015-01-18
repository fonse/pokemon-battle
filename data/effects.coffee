csv = require 'csv'
fs = require 'fs'
Move = require '../src/move'
Effect = require '../src/effect'


path = process.argv[2] ? __dirname +  '/pokedex/pokedex/data/csv'
options = { delimiter: ',', escape: '"', columns: true }

printEffect = (effect) ->
  return '' if effect.examples.length == 0 or not effect.damages
  return effect.id + ": " + effect.effect + " (" +  effect.examples[0..2].join(", ") + (if effect.examples.length > 3 then '...' else '') +  ")  \n"

fs.exists path, (exists) ->
  if exists
    csv()
    .from.path(path + "/move_effect_prose.csv", options)
    .to.array (rows) ->
      effects = {}
      for row in rows
        if row.move_effect_id < 10000
          effects[row.move_effect_id] = {
            id: +row.move_effect_id
            effect: row.short_effect.replace(/\$effect_chance% /g, '')
                                    .replace(/\[(.*?)\]{.+?:(.+?)}/g, (match, name, href) -> if name.length > 0 then name else href),
            damages: false,
            state: null,
            examples: [],
          }
      
      for id, move of Move.movedex
        effect = Effect.make move.effect
        effects[effect.id].state = switch
          when effect.banned() then 'banned'
          when effect.fullSupport() then 'supported'
          else 'partly-supported'
        
        effects[effect.id].damages = effects[effect.id].damages or move.damage_class != 'non-damaging'
        effects[effect.id].examples.push(move.name)
      
      
      output = ''
      output += "## Supported Effects ##\n"
      output += "The following moves are fully supported.\n\n"
      for id, effect of effects
        output += printEffect effect if effect.state == 'supported'
        
      output += "\n## Partly Supported Effects ##\n"
      output += "The following moves can be used but not all side effects will take place.\n\n"
      for id, effect of effects
        output += printEffect effect if effect.state == 'partly-supported'
        
      output += "\n## Banned Effects ##\n"
      output += "The following moves cannot be used in battle.\n\n"
      for id, effect of effects
        output += printEffect effect if effect.state == 'banned'
        
      fs.writeFile __dirname + '/../docs/effects.md', output.trim()
      
  else
    console.log "Usage: coffe " + process.argv[1] + " path/to/csvs\n"
