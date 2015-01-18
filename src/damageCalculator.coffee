class DamageCalculator
  calculate: (move, attacker, defender, critical = false, random = 0.9) ->
    attack = attacker.stat move.attackStat(), {ingoreNegative: critical}
    defense = defender.stat move.defenseStat(), {ingorePositive: critical}
    
    stab = if move.type.id in (attacker.types.map (type) -> type.id) then 1.5 else 1
    type = move.effectiveness attacker, defender
    crit = if critical then 1.5 else 1
    
    return this.formula move.power(attacker, defender), attack, defense, stab * type * crit * random

  confusionDamage: (pokemon) ->
    attack = pokemon.stat 'attack'
    defense = pokemon.stat 'defense'
    random = Math.random() * (1 - 0.85) + 0.85

    return this.formula 40, attack, defense, random

  formula: (power, attack, defense, multipliers) ->
    Math.round (0.88 * (attack / defense) * power + 2 ) * multipliers


module.exports = DamageCalculator
