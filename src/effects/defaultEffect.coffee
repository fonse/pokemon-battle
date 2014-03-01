class DefaultEffect
  constructor: (@id) ->
  
  power: (base) -> base
  effectiveness: (attacker, defender) ->
  
  hits: -> 1
  criticalRateStage: -> 0
  
  buildMultiplier: -> 1
  battleMultiplier: (attacker, defender, damage, kill) -> 1
  
  afterDamage: (attacker, defender, damage, log) ->
  afterMiss: (attacker, defender, log) ->
  
  banned: -> false
  fullSupport: -> @constructor.name != 'DefaultEffect' or @id == 1

module.exports = DefaultEffect
