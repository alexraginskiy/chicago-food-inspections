View = require 'views/base/view'

module.exports = class ErrorView extends View
  autoRender: true
  template: require './templates/error'