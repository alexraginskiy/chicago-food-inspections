mediator = module.exports = Chaplin.mediator

mediator.subscribe 'search', (searchResults)->
  mediator.searchResults = searchResults