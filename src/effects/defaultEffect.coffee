class DefaultEffect
  constructor: (@id) ->
  
  power: (base) -> base
  
  hits: -> 1
  
  buildMultiplier: -> 1
  
  battleMultiplier: (attacker, defender, damage, kill) -> 1
  
  afterDamage: (attacker, defender, damage, log) ->
  
  effectiveness: (attacker, defender) ->
  
  blacklisted: ->
    blacklist = [
      # Multi-turn
      27, 28, 40, 76, 81, 146, 149, 152, 156, 160, 256, 257, 273, 312, 332, 333, 366
      
      # Stat Modifications
      183, 205, 230, 335,
      
      # Easier Effects
      46, 294, 298,
      
      # Harder Effects
      8, 9, 39, 105, 136, 159, 171, 191, 247, 249, 293, 339,
    ]
    
    return @id in blacklist


module.exports = DefaultEffect
