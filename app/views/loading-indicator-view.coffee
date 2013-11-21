View = require 'views/base/view'

module.exports = class LoadingIndicatorView extends View
  noWrap: true
  template: require './templates/loading-indicator'