DefaultEffect = require './defaultEffect'

class SwitchOutEffect extends DefaultEffect
  battleMultiplier: (attacker, defender, damage, kill) ->
    if (defender.typeAdvantageAgainst attacker) and attacker.speed() > defender.speed() then 2 else 1
  
  afterDamage: (attacker, defender, damage, log) ->
    trainer = attacker.trainer
    if trainer.ablePokemon().length > 1
      trainer.switchPokemon defender, log

  
module.exports = SwitchOutEffect
