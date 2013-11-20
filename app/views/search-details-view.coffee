View = require 'views/base/view'

module.exports = class SearchResultView extends View
  autoRender: true
  noWrap: true
  template: require './templates/search-details'

  getTemplateData: ->
    searchType = @collection.searchType
    searchString = @collection.searchString

    if searchType == 'zip'
      searchResultString = "inspections in #{searchString}"
    if searchType == 'text'
      searchResultString = "results for \"#{searchString}\""

    data =
      length:             @collection.length
      searchString:       @collection.searchString
      searchType:         @collection.searchType
      searchResultString: searchResultString
