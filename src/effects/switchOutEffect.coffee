DefaultEffect = require './defaultEffect'

class SwitchOutEffect extends DefaultEffect
  battleMultiplier: (attacker, defender, damage, lethal) ->
    hasOtherPokemon = attacker.trainer.ablePokemon().length > 1
    if (defender.typeAdvantageAgainst attacker) and attacker.speed() > defender.speed() and hasOtherPokemon then 2 else 1
  
  afterDamage: (attacker, defender, damage, log) ->
    trainer = attacker.trainer
    if trainer.ablePokemon().length > 1
      trainer.switchPokemon defender, log

  
module.exports = SwitchOutEffect
