DefaultEffect = require './defaultEffect'

class DualEffect extends DefaultEffect
  constructor: (@id, @effects) ->

  power: (base) -> base # No dual-effect attack has this
  effectiveness: (attacker, defender) -> this.multiply (effect.effectiveness attacker, defender for effect in @effects)
  
  hits: -> this.max (effect.hits() for effect in @effects)
  criticalRateStage: -> this.max (effect.criticalRateStage() for effect in @effects)
  
  buildMultiplier: (attacker) -> this.multiply (effect.buildMultiplier attacker for effect in @effects)
  battleMultiplier: (attacker, defender, damage, lethal) -> this.multiply (effect.battleMultiplier attacker, defender, damage, lethal for effect in @effects)
  
  afterDamage: (attacker, defender, damage, log) -> effect.afterDamage attacker, defender, damage, log for effect in @effects
  afterMiss: (attacker, defender, log) -> effect.afterMiss attacker, defender, log for effect in @effects

  # Aux functions
  max: (list) ->  Math.max.apply null, list
  multiply: (list) -> list.reduce ((a,b) -> a*b), 1

module.exports = DualEffect
