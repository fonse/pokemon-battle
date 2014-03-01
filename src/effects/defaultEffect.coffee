class DefaultEffect
  constructor: (@id) ->
  
  power: (base) -> base
  
  hits: -> 1
  
  buildMultiplier: -> 1
  
  battleMultiplier: (attacker, defender, damage, kill) -> 1
  
  afterDamage: (attacker, defender, damage, log) ->
  afterMiss: (attacker, defender, log) ->
  
  effectiveness: (attacker, defender) ->
  
  banned: -> false

module.exports = DefaultEffect
