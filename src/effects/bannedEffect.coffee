DefaultEffect = require './defaultEffect'

class BannedEffect extends DefaultEffect
  banned: -> true


module.exports = BannedEffect
