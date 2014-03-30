class Log
  constructor: ->
    @log = []
    @turn = 0
    @attack = 0
  
  message: (str) ->
    @log[@turn] = [] unless @log[@turn]?
    @log[@turn][@attack] = [] unless @log[@turn][@attack]?
    
    @log[@turn][@attack].push(this.upperFirst str)
  
  endAttack: ->
    @attack++
    
  endTurn: ->
    @turn++
    @attack = 0
  
  toString: ->
    str = ''
    for turn in @log
      for attack in turn
        for message in attack
          str += message + "\n"
        
        str += "\n"
      str += "\n"
      
          
    return str.trim()

  upperFirst: (str) ->
    return str.charAt(0).toUpperCase() + str.slice(1)


module.exports = Log
