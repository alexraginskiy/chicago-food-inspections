View = require 'views/base/view'

module.exports = class AboutView extends View
  autoRender: true
  template: require './templates/about'