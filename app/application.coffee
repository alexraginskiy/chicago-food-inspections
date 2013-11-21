mediator = require 'mediator'

# The application object.
module.exports = class Application extends Chaplin.Application
  title: 'Chicago Food Inspection'

  initMediator: ->
    mediator.lastSearchTerm = ''
    super

  start: ->
    super
    $(document).ajaxError @handleAjaxError

  handleAjaxError: =>
    Chaplin.helpers.redirectTo 'home#error'