DefaultEffect = require './effects/defaultEffect'
HealEffect = require './effects/healEffect'
RecoilEffect = require './effects/recoilEffect'
StruggleEffect = require './effects/struggleEffect'
MultiHitEffect = require './effects/multiHitEffect'
DoublePowerEffect = require './effects/doublePowerEffect'

class Effect
  this.make = (id) ->
    switch id
      when 4, 348 then new HealEffect(id)
      when 49, 199, 254, 263, 270 then new RecoilEffect(id)
      when 255 then new StruggleEffect(id)
      when 30, 45, 78 then new MultiHitEffect(id)
      when 318 then new DoublePowerEffect(id)
      else new DefaultEffect(id)


module.exports = Effect
