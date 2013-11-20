CollectionView = require 'views/base/collection-view'
SearchResultView = require 'views/search-result-view'

module.exports = class SearchView extends CollectionView
  autoRender: true
  template: require './templates/search'
  itemView: SearchResultView
  listSelector: '#search-results'
  loadingSelector: '.loading-indicator'
  fallbackSelector: '.no-results'
