View = require 'views/base/view'

module.exports = class HomeView extends View
  autoRender: true
  template: require './templates/home'