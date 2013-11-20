CollectionView = require 'views/base/collection-view'

SearchResultView = require 'views/search-result-view'
SearchDetailsView = require 'views/search-details-view'

module.exports = class SearchView extends CollectionView
  autoRender: true
  template: require './templates/search'
  itemView: SearchResultView
  listSelector: '.search-results-list'
  loadingSelector: '.search-results-loading'
  fallbackSelector: '.no-results'

  useCssAnimation: true
  animationStartClass: 'fade'
  animationEndClass: 'in'

  regions:
    'searchDetails' : '.search-details-container'

  itemsReset: ->
    super
    @renderResultDetails()

  renderResultDetails: ->
    searchDetailsView = new SearchDetailsView region: 'searchDetails', collection: @collection
    @subview 'searchDetails', searchDetailsView
