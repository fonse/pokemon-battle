DefaultEffect = require './defaultEffect'

class CritRateEffect extends DefaultEffect
  criticalRateStage: ->
    switch @id
      when 44, 201, 210 then 1
      when 289 then 50

  buildMultiplier: (attacker) ->
    switch @id
      when 44, 201, 210 then 1.03
      when 289 then 1.5
  
  battleMultiplier: (attacker, defender, damage, kill) ->
    switch @id
      when 44, 201, 210 then 1.03
      when 289 then 1.5
  
  fullSupport: -> @id not in [201, 210]
  
  
module.exports = CritRateEffect
