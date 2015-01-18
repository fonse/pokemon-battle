DefaultEffect = require './effects/defaultEffect'
NoEffect = require './effects/noEffect'
DualEffect = require './effects/dualEffect'
HealEffect = require './effects/healEffect'
RecoilEffect = require './effects/recoilEffect'
RecoilOnMissEffect = require './effects/recoilOnMissEffect'
StruggleEffect = require './effects/struggleEffect'
MultiHitEffect = require './effects/multiHitEffect'
DoublePowerEffect = require './effects/doublePowerEffect'
WeightDependentEffect = require './effects/weightDependentEffect'
CritRateEffect = require './effects/critRateEffect'
StatStageEffect = require './effects/statStageEffect'
SwitchOutEffect = require './effects/switchOutEffect'
BannedEffect = require './effects/bannedEffect'
StatusAilmentEffect = require './effects/statusAilmentEffect'
ConditionEffect = require './effects/conditionEffect'

class Effect
  this.make = (id, chance) ->
    switch id
      when 1, 35, 104 then new NoEffect(id)
      
      when 254, 263 then new DualEffect id, [(new RecoilEffect id), (new StatusAilmentEffect id, chance)]
      when 78 then new DualEffect id, [(new MultiHitEffect id), (new StatusAilmentEffect id, chance)]
      when 274, 275, 276 then new DualEffect id, [(new ConditionEffect id, chance), (new StatusAilmentEffect id, chance)]
      when 201, 210 then new DualEffect id, [(new CritRateEffect id), (new StatusAilmentEffect id, chance)]

      # Status Ailments - Also 126
      when 3, 5, 6, 7, 153, 203, 261 then new StatusAilmentEffect(id, chance)
      when 37, 126, 153, 170, 172, 198, 284, 330 then new DefaultEffect(id)
      
      # Stat Levels
      when 74, 304, 305, 306, 344 then new DefaultEffect(id)
      
      # Accuracy-related
      when 18, 79 then new DefaultEffect(id)
      
      # Items
      when 106, 189, 225, 315 then new DefaultEffect(id)
      
      # U-turn
      when 229 then new SwitchOutEffect(id)
      
      # Misc
      when 130, 148, 150, 186, 187, 208, 222, 224, 231, 232, 258, 269, 288, 290, 302, 303, 311, 314, 320, 350 then new DefaultEffect(id)
      
      # Flinch
      when 32, 147, 151 then new ConditionEffect(id, chance)

      # Confusion
      when 77, 268, 338 then new ConditionEffect(id, chance)

      # Fully Implemented
      when 4, 348, 353 then new HealEffect(id)
      when 49, 199, 270 then new RecoilEffect(id)
      when 46 then new RecoilOnMissEffect(id)
      when 255 then new StruggleEffect(id)
      when 30, 45 then new MultiHitEffect(id)
      when 318 then new DoublePowerEffect(id)
      when 197 then new WeightDependentEffect(id)
      when 44, 289 then new CritRateEffect(id)
      when 21, 69, 70, 71, 72, 73, 139, 140, 141, 205, 219, 230, 272, 277, 296, 297, 331, 335 then new StatStageEffect(id, chance)
      else new BannedEffect(id)


module.exports = Effect
