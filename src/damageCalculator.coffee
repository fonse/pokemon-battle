class DamageCalculator
  calculate: (move, attacker, defender, critical = false, random = 0.9) ->
    attack = attacker.stat move.attackStat(), {ingoreNegative: critical}
    defense = defender.stat move.defenseStat(), {ingorePositive: critical}
    
    stab = if move.type.id in (attacker.types.map (type) -> type.id) then 1.5 else 1
    type = move.effectiveness attacker, defender
    crit = if critical then 1.5 else 1
    
    return Math.round (0.88 * (attack / defense) * move.power(attacker, defender) + 2 ) * stab * type * crit * random


module.exports = DamageCalculator
