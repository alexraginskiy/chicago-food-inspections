Application = require 'application'
routes = require 'routes'

# Initialize the application on DOM ready event.
$ ->
  window.app = new Application {
    title: 'Chicago Food Inspection',
    controllerSuffix: '-controller',
    routes
  }
