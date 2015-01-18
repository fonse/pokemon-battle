DefaultEffect = require './defaultEffect'

class MultiHitEffect extends DefaultEffect
  hits: ->
    switch @id
      when 30 then [2,2,3,3,4,5][Math.floor(Math.random() * 6)]
      when 45, 78 then 2

  buildMultiplier: (attacker) ->
    switch @id
      when 30 then 3.166
      when 45, 78 then 2
  
  battleMultiplier: (attacker, defender, damage, lethal) ->
    if not lethal  
      switch @id
        when 30 then 3.166
        when 45, 78 then 2
    else
      return 1
      

module.exports = MultiHitEffect
