DefaultEffect = require './defaultEffect'

class WeightDependentEffect extends DefaultEffect
  power: (base, attacker, defender) ->
    return 60 unless defender?

    switch
      when defender.weight < 10 then 20
      when defender.weight < 25 then 40
      when defender.weight < 50 then 60
      when defender.weight < 100 then 80
      when defender.weight < 200 then 100
      else 200
 

module.exports = WeightDependentEffect
