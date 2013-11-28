View = require 'views/base/view'

module.exports = class SearchFieldView extends View

  autoRender: true
  noWrap: true
  template: require './templates/search-field'
  events:
    'submit #search-form'    : 'search'
    'click .search-location' : 'geosearch'
    'click .search-anywhere' : 'search'

  listen:
    'search mediator' : 'updateSearchField'

  getTemplateData: ->
    geolocation: 'geolocation' of navigator

  updateSearchField: (searchResults)->
    @$('#search-field').val(searchResults.searchString)

  search: (e)->
    e?.preventDefault()

    query = @getQuery()
    @getSearchField().blur()

    Chaplin.helpers.redirectTo 'search', {query}

  geosearch: (e)->
    e?.preventDefault()
    link = $(e.target)

    radius       = link.data('radius')
    query        = @getQuery()

    searchRoute  = if query then 'keywordGeosearch' else 'geosearch'

    Chaplin.helpers.redirectTo searchRoute, {radius, query}


  getSearchField: ->
    @$('#search-field')

  getQuery: ->
    searchField = @getSearchField()
    encodeURI $.trim(searchField.val())