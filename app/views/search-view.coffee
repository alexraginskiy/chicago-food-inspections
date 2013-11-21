CollectionView = require 'views/base/collection-view'

SearchResultView = require 'views/search-result-view'
SearchDetailsView = require 'views/search-details-view'

module.exports = class SearchView extends CollectionView
  autoRender: true
  template: require './templates/search'
  itemView: SearchResultView
  listSelector: '.search-results-list'
  loadingSelector: '.search-results-loading'
  fallbackSelector: '.search-results-none'

  useCssAnimation: true
  animationStartClass: 'fade'
  animationEndClass: 'in'

  regions:
    'searchDetails' : '.search-details-container'

  initialize: ->
    super
    @loadingTimeWarningTimeout = window.setTimeout(@showLoadingTimeWarning, 3000)

  itemsReset: ->
    super
    @renderResultDetails()

  renderResultDetails: ->
    if @collection.length
      searchDetailsView = new SearchDetailsView region: 'searchDetails', collection: @collection
      @subview 'searchDetails', searchDetailsView

  showLoadingTimeWarning: =>
    @$('.search-results-loading-time-warning').addClass('in')