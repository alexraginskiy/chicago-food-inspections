Controller      = require 'controllers/base/controller'

mediator        = require 'mediator'

Inspections     = require 'models/inspections'

SearchView      = require 'views/search-view'
SearchFieldView = require 'views/search-field-view'

module.exports = class SearchController extends Controller

  beforeAction: ->
    super
    @compose 'searchField', SearchFieldView, region: 'searchField'

    @collection = new Inspections
    @view       = new SearchView region: 'main', collection: @collection

  search: (params)->
    if params.query
      @collection.search params.query
      mediator.publish 'search', @collection

      analytics.page('Text Search', {term: params.query})

    else
      @redirectTo 'home#show'

  geosearch: (params)->
    @collection.beginSync()
    @view.toggleLoadingIndicator()

    # redirect to home if geolocation is not available
    unless 'geolocation' of navigator
      @redirectTo 'home#show'
      return

    # get the numerical part of the radius param
    radius = +params.radius.split('-mile')[0]

    # return to home if no valid radius is provided
    unless _(radius).isNumber
      @redirectTo 'home#show'
      return

    # get the users geolocation
    geoSuccess = (position)=>
      lat = position.coords.latitude
      lng = position.coords.longitude

      @collection.geosearch lat, lng, radius, query: params.query
      mediator.publish 'search', @collection


    # handle geolocation errors
    geoError = =>
      console.log 'geo error'

    # get the current position and trigger callback
    navigator.geolocation.getCurrentPosition geoSuccess, geoError

