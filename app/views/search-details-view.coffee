View = require 'views/base/view'

module.exports = class SearchResultView extends View
  autoRender: true
  noWrap: true
  template: require './templates/search-details'

  getTemplateData: ->
    searchType =   @collection.searchType
    searchString = @collection.searchString
    searchRadius = @collection.searchRadius

    if searchType == 'zip'
      searchResultString = "inspections in #{searchString}"
    if searchType == 'text'
      searchResultString = "results for \"#{searchString}\""

    if searchType == 'geo'
      if searchString
        searchResultString = "results for \"#{searchString}\" within #{searchRadius} mile(s)"
      else
        searchResultString = "results within #{searchRadius} mile(s)"

    data =
      length:             @collection.length
      searchString:       @collection.searchString
      searchType:         @collection.searchType
      searchResultString: searchResultString
