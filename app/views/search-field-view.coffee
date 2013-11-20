View = require 'views/base/view'

module.exports = class SearchFieldView extends View

  autoRender: true
  template: require './templates/search-field'
  events:
    'submit #search-form' : 'search'

  listen:
    'search mediator' : 'updateSearchField'

  updateSearchField: (query)->
    @$('#search-field').val(query)

  search: (e)->
    e?.preventDefault()
    form = $ e.target

    input = form.find('input')
    query = input.val()

    input.blur()
    Chaplin.helpers.redirectTo 'home#search', {query}