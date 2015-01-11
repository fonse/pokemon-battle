class DefaultEffect
  constructor: (@id, @chance) ->
  
  power: (base) -> base
  effectiveness: (effectiveness, attacker, defender) -> effectiveness
  
  hits: -> 1
  criticalRateStage: -> 0
  
  buildMultiplier: (attacker) -> 1
  battleMultiplier: (attacker, defender, damage, lethal) -> 1
  
  afterDamage: (attacker, defender, damage, log) ->
  afterMiss: (attacker, defender, log) ->
  
  banned: -> false
  fullSupport: -> @constructor.name != 'DefaultEffect'

module.exports = DefaultEffect
