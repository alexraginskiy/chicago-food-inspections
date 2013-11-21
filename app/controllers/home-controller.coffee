mediator        = require 'mediator'
Controller      = require 'controllers/base/controller'

Inspections     = require 'models/inspections'

HomeView        = require 'views/home-view'
AboutView       = require 'views/about-view'
ErrorView       = require 'views/error-view'

SearchView      = require 'views/search-view'
SearchFieldView = require 'views/search-field-view'

module.exports = class HomeController extends Controller

  beforeAction: ->
    super
    @compose 'searchField', SearchFieldView, region: 'searchField'

  show: ->
    @view = new HomeView region: 'main'

  about: ->
    @view = new AboutView region: 'main'

  search: (params)->
    @collection = new Inspections
    @view       = new SearchView region: 'main', collection: @collection

    @collection.search(params.query)

    mediator.publish 'search', decodeURI(params.query)

  error: ->
    @view = new ErrorView region: 'main'