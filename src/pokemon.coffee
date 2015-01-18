fs = require 'fs'
Type = require './type'
Move = require './move'
Strategy = require './strategy'

class Pokemon
  this.pokedex = JSON.parse fs.readFileSync(__dirname + '/../data/pokemon.json').toString()

  constructor: (id) ->
    pokemon = @constructor.pokedex[id]
    throw new Error("Pokemon not found: " + id) unless pokemon?
    
    @name = pokemon.name
    @types = (new Type typeId for typeId in pokemon.types)
    @weight = pokemon.weight / 10
    
    @stats = {
        base: pokemon.stats,
        stage: {
            attack: 0,
            defense: 0,
            spattack: 0,
            spdefense: 0,
            speed: 0,
        },
    }
    
    @maxHp = 141 + 2 * pokemon.stats.hp
    @hp = @maxHp

    @conditions = {}
    @ailment = null
    
    @faintObservers = []
    @strategy = new Strategy(this)
    @moves = @strategy.chooseBuild (new Move moveId for moveId in pokemon.moves)
  
  trainerAndName: ->
    if not @trainer.name?
      return "your " + @name
    else
      return @trainer.name + "'s " + @name
  
  attack: -> this.stat 'attack'
  defense: -> this.stat 'defense'
  spattack: -> this.stat 'spattack'
  spdefense: -> this.stat 'spdefense'
  speed: -> this.stat 'speed'
  
  chooseMove: (defender) ->
    @move = @strategy.chooseMove defender

  takeDamage: (damage, message, log) ->
    damage = @hp if damage > @hp
    @hp -= damage

    message = message.replace '%(pokemon)', this.trainerAndName()
    message = message.replace '%(damage)', damage + " HP (" + Math.round(damage / @maxHp * 100) + "%)"
    log.message message

    unless this.isAlive()
      observer.notifyFaint(this) for observer in @faintObservers

    return damage

  isAlive: -> @hp > 0

  subscribeToFaint: (observer) ->
    @faintObservers.push(observer)

  stat: (stat, options) ->
    options = {} unless options?
    options.ingorePositive = false unless options.ingorePositive?
    options.ingoreNegative = false unless options.ingoreNegative?
  
    stageMultiplier = this.statStageMultiplier @stats.stage[stat]
    stageMultiplier = 1 if stageMultiplier > 1 and options.ingorePositive
    stageMultiplier = 1 if stageMultiplier < 1 and options.ingoreNegative

    ailmentMultiplier = 1
    ailmentMultiplier = @ailment.statMultiplier(stat) if @ailment?

    return 36 + 2 * @stats.base[stat] * stageMultiplier * ailmentMultiplier
    
  statStageMultiplier: (stage) ->
    switch stage
      when -6 then 2/8
      when -5 then 2/7
      when -4 then 2/6
      when -3 then 2/5
      when -2 then 2/4
      when -1 then 2/3
      when 0 then 1
      when 1 then 1.5
      when 2 then 2
      when 3 then 2.5
      when 4 then 3
      when 5 then 3.5
      when 6 then 4
  
  statName: (stat) ->
    switch stat
      when 'attack' then 'Attack'
      when 'defense' then 'Defense'
      when 'spattack' then 'Special Attack'
      when 'spdefense' then 'Special Defense'
      when 'speed' then 'Speed'
  
  modifyStatStage: (stat, change, log) ->
    statName = this.statName stat
    switch
      when @stats.stage[stat] == 6 and change > 0
        log.message this.trainerAndName() "'s " + statName + " cannot rise any higher."
      when @stats.stage[stat] == -6 and change < 0
        log.message this.trainerAndName() "'s " + statName + " cannot fall any lower."
      else
        change = 6 - @stats.stage[stat] if @stats.stage[stat] + change > 6
        change = -6 - @stats.stage[stat] if @stats.stage[stat] + change < -6
        @stats.stage[stat] += change
        switch change
          when 1 then log.message this.trainerAndName() + "'s " + statName + " rose!"
          when 2 then log.message this.trainerAndName() + "'s " + statName + " sharply rose!"
          when 3 then log.message this.trainerAndName() + "'s " + statName + " drastically rose!"
          when -1 then log.message this.trainerAndName() + "'s " + statName + " fell!"
          when -2 then log.message this.trainerAndName() + "'s " + statName + " harshly fell!"
          when -3 then log.message this.trainerAndName() + "'s " + statName + " severely fell!"
  
  typeAdvantageAgainst: (pokemon) ->
    ( type for type in @types when type.effectiveAgainst pokemon.types ).length > 0
  
  canAttack: (log) ->
    if @ailment? and not @ailment.canAttack this, log
      return false 

    for _, condition of @conditions
      return false unless condition.canAttack this, log

    return true

  whenSwitchedOut: -> 
    @move = null
    @ailment.whenSwitchedOut this if @ailment

  endTurn: (log) ->
    @ailment.endTurn this, log if @ailment?

    for _, condition of @conditions
      condition.endTurn this, log

  toString: ->
    return @name
    
    
module.exports = Pokemon
