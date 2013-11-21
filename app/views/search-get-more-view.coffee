View = require 'views/base/view'

module.exports = class SearchGetMoreView extends View
  autoRender: true
  noWrap: true
  template: require './templates/search-get-more'
  events:
    'click' : 'fetchMoreResults'

  initialize: ->
    super
    @listenTo @collection, 'syncing', @showLoading
    @listenTo @collection, 'synced', @hideLoading

  fetchMoreResults: ->
    @collection.search()

  showLoading: ->
    @$('.search-results-more-text').addClass('hide')
    @$('.search-results-more-loading').removeClass('hide')

  hideLoading: ->
    @$('.search-results-more-text').removeClass('hide')
    @$('.search-results-more-loading').addClass('hide')
