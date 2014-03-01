DefaultEffect = require './effects/defaultEffect'
HealEffect = require './effects/healEffect'
RecoilEffect = require './effects/recoilEffect'
StruggleEffect = require './effects/struggleEffect'
MultiHitEffect = require './effects/multiHitEffect'
DoublePowerEffect = require './effects/doublePowerEffect'
WeightDependentEffect = require './effects/weightDependentEffect'
BannedEffect = require './effects/bannedEffect'

class Effect
  this.make = (id) ->
    switch id
      when 1, 35, 104 then new DefaultEffect(id)
      
      # Status Ailments
      when 1, 3, 5, 6, 7, 37, 126, 153, 170, 172, 198, 201, 203, 210, 261, 274, 275, 276, 284, 330 then new DefaultEffect(id)
      
      # Pesudo-Status Ailments
      when 77, 268, 338 then new DefaultEffect(id)
      
      # Stat Levels
      when 21, 69, 70, 71, 72, 73, 74, 139, 140, 141, 186, 205, 219, 230, 272, 277, 296, 297, 304, 305, 306, 331, 335, 344 then new DefaultEffect(id)
      
      # Flinch - Also 201, 210, 274, 275, 276
      when 32, 147, 151 then new DefaultEffect(id)
      
      # Crit Rate
      when 44, 289 then new DefaultEffect(id)
      
      # Accuracy-related
      when 18, 79 then new DefaultEffect(id)
      
      # Items
      when 106, 189, 225, 315 then new DefaultEffect(id)
      
      # Misc
      when 129, 130, 148, 150, 187, 208, 222, 224, 229, 231, 232, 258, 269, 288, 290, 302, 303, 311, 314, 320, 350 then new DefaultEffect(id)
      
      when 4, 348, 353 then new HealEffect(id)
      when 49, 199, 254, 263, 270 then new RecoilEffect(id)
      when 255 then new StruggleEffect(id)
      when 30, 45, 78 then new MultiHitEffect(id)
      when 318 then new DoublePowerEffect(id)
      when 197 then new WeightDependentEffect(id)
      else new BannedEffect(id)


module.exports = Effect
