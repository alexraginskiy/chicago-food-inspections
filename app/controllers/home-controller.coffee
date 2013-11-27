mediator        = require 'mediator'
Controller      = require 'controllers/base/controller'

HomeView        = require 'views/home-view'
AboutView       = require 'views/about-view'
ErrorView       = require 'views/error-view'

SearchFieldView = require 'views/search-field-view'

module.exports = class HomeController extends Controller

  beforeAction: ->
    super
    @compose 'searchField', SearchFieldView, region: 'searchField'

  show: ->
    @view = new HomeView region: 'main'
    analytics?.page('Home')

  about: ->
    @view = new AboutView region: 'main'
    analytics?.page('About')

  error: ->
    @view = new ErrorView region: 'main'
    analytics?.page('Error')
