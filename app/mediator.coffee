Model = require 'models/base/model'

mediator = module.exports = Chaplin.mediator

mediator.subscribe 'search', (query)->
  mediator.lastSearchTerm = query