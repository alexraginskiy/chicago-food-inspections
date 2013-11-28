HomeController = require 'controllers/home-controller'

SearchFieldView = require 'views/search-field-view'

HomeView        = require 'views/home-view'
AboutView       = require 'views/about-view'
ErrorView       = require 'views/error-view'

describe 'HomeController', ->

  beforeEach ->

    # regions trigger a mediator event that must be handled
    @regionShowSpy = sinon.spy()
    Chaplin.mediator.setHandler 'region:show', @regionShowSpy

    # views that have templates that use url helper need this method stubbed
    sinon.stub Chaplin.helpers, 'reverse'

    # stub the compose method, we just need to make sure it's called
    @composeStub = sinon.stub HomeController::, 'compose'

    @controller = new HomeController

  afterEach ->
    Chaplin.mediator.removeHandlers ['region:show']
    Chaplin.helpers.reverse.restore()

    @composeStub.restore()
    @controller.dispose()

  describe 'beforeAction', ->
    it 'should compose the searchfield', ->
      @controller.beforeAction()
      expect(@composeStub).to.have.been.calledWith 'searchField', SearchFieldView, region: 'searchField'

  actions = [
    {
      method: 'show'
      description: 'Home'
      view: HomeView
    }
    {
      method: 'about'
      description: 'About'
      view: AboutView
    }
    {
      method: 'error'
      description: 'Error'
      view: ErrorView
    }
  ]

  _(actions).each (action)->

    describe "##{action.method}()", ->
      beforeEach ->
        window.analytics =
          page: sinon.spy()

        @controller[action.method]()

      afterEach ->
         delete window.analytics

      it "should setup the #{action.description} view", ->

        # test that the view has been setup with the right region
        expect(@controller.view).to.be.instanceOf action.view
        expect(@controller.view.region).to.equal 'main'

        # test regions working properly
        expect(@regionShowSpy.args[0][0]).to.equal 'main'
        expect(@regionShowSpy.args[0][1]).to.equal @controller.view

      it "should call analytics", ->
        expect(analytics.page).to.have.been.calledWith action.description