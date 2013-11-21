CollectionView    = require 'views/base/collection-view'

SearchResultView  = require 'views/search-result-view'
SearchDetailsView = require 'views/search-details-view'
SearchGetMoreView = require 'views/search-get-more-view'

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
    'searchGetMore' : '.search-results-more-container'

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

    if @collection.responseLength >= @collection.limit
      getMoreResultsView = new SearchGetMoreView region: 'searchGetMore', collection: @collection
      @subview 'searchGetMore', getMoreResultsView

  showLoadingTimeWarning: =>
    @$('.search-results-loading-time-warning').addClass('in')