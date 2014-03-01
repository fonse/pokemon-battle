fs = require 'fs'

class Type
  this.typedex = JSON.parse fs.readFileSync(__dirname + '/../data/types.json').toString()
  
  this.all = ->
    (new Type typeId for typeId, dummy of this.typedex)
  
  constructor: (id) ->
    type = @constructor.typedex[id]
    throw new Error("Type not found: " + id) unless type?
    
    @id = type.id
    @name = type.name
    @offense = type.offense
    @defense = type.defense
  
  effectivenessAgainst: (types) ->
    unless types instanceof Array
      types = [ types ]
    
    return types.reduce (multiplier, type) =>
      multiplier * @offense[type.id]
    , 1
    
  effectiveAgainst: (types) -> (this.effectivenessAgainst types) > 1
  
  weaknesses: ->
    return (new @constructor typeId for typeId, effectiveness of @defense when effectiveness > 1)
  
  strengths: ->
    return (new @constructor typeId for typeId, effectiveness of @offense when effectiveness > 1)
  
  toString: ->
    return @name


module.exports = Type
