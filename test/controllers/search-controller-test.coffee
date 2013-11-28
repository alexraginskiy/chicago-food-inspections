SearchController  = require 'controllers/search-controller'
SearchFieldView   = require 'views/search-field-view'
Inspections       = require 'models/inspections'
SearchView        = require 'views/search-view'
mediator          = require 'mediator'

describe 'SearchController', ->

  beforeEach ->

    # regions trigger a mediator event that must be handled
    @regionShowSpy = sinon.spy()
    Chaplin.mediator.setHandler 'region:show', @regionShowSpy

    @regionRegisterSpy = sinon.spy()
    Chaplin.mediator.setHandler 'region:register', @regionRegisterSpy

    # views that have templates that use url helper need this method stubbed
    sinon.stub Chaplin.helpers, 'reverse'

    # stub the compose method, we just need to make sure it's called
    @composeStub = sinon.stub SearchController::, 'compose'

    # stub the redirectTo method
    @redirectStub = sinon.stub SearchController::, 'redirectTo'

    # stub the publish event
    @publishStub = sinon.stub SearchController::, 'publish'


    @controller = new SearchController

    window.analytics =
      page: sinon.spy()

  afterEach ->
    Chaplin.mediator.removeHandlers ['region:show', 'region:register']
    Chaplin.helpers.reverse.restore()

    @publishStub.restore()
    @composeStub.restore()
    @redirectStub.restore()
    @controller.dispose()

    delete window.analytics

  it 'should have a publish shortcut', ->
    @publishStub.restore()
    expect(@controller.publish).to.exist.and.be.a 'function'
    expect(@controller.publish).to.equal mediator.publish

  describe 'beforeAction', ->
    beforeEach ->
      @controller.beforeAction()

    it 'should compose the searchfield', ->
      expect(@composeStub).to.have.been.calledWith 'searchField', SearchFieldView, region: 'searchField'

    it 'should create Inspections collection', ->
      expect(@controller.collection).to.be.an.instanceOf Inspections

    it 'should create the Search view', ->
      expect(@controller.view).to.be.an.instanceOf SearchView
      expect(@controller.view.region).to.equal 'main'
      expect(@controller.view.collection).to.equal @controller.collection

  describe 'searching', ->
    beforeEach ->
      @controller.beforeAction()

    describe '#search()', ->
      it 'should redirect to home if no query is given', ->
        @controller.search({})
        expect(@redirectStub).to.have.been.calledWith 'home#show'

      describe 'performing search', ->

        beforeEach ->
          @inspectionsSearchStub = sinon.stub Inspections::, 'search'

          @controller.search query: 'some query'

        afterEach ->
          @inspectionsSearchStub.restore()

        it 'should call #search() on the collection', ->
          expect(@inspectionsSearchStub).to.have.been.calledWith 'some query'

        it 'should publish search event', ->
          expect(@publishStub).to.have.been.calledWith 'search', @controller.collection

        it 'should call analytics', ->
          expect(window.analytics.page).to.have.been.calledWith 'Text Search', term: 'some query'


    # phantom js doesn't supoort geolocation
    if navigator.geolocation?
      describe '#geosearch()', ->

        beforeEach ->
          @geoSearchStub = sinon.stub Inspections::, 'geosearch'

          @getCurrentPositionStub = sinon.stub navigator.geolocation, 'getCurrentPosition'
          # let's assume the sad path and call the error callback in these scenarios
          @getCurrentPositionStub.callsArgWith 0, coords: {latitude: 123, longitude: 321}

        afterEach ->
          @geoSearchStub.restore()
          @getCurrentPositionStub.restore()

        describe 'setup', ->

          beforeEach ->
            @controller.geosearch({})

          it 'should show loading indicator', ->
            expect(@controller.view.$('.search-results-loading')).to.have.attr('style').match /display: block/

          it 'should redirect to home when radius is not valid', ->
            expect(@redirectStub).to.have.been.calledWith 'home#show'

            @controller.geosearch radius: 'not a valid radius'
            expect(@redirectStub).to.have.been.calledTwice

        describe 'searching', ->

          beforeEach ->
            @controller.geosearch radius: '5-miles', query: 'some query'

          it 'should not redirect with proper radius', ->
            expect(@redirectStub).not.to.have.been.calledTwice

          it 'should request the current position', ->
            expect(@getCurrentPositionStub).to.have.been.called

          it 'should call geosearch on inspections', ->
            expect(@geoSearchStub).to.have.been.calledWith 123, 321, 5, query: 'some query'

          it 'should publish search event', ->
            expect(@publishStub).to.have.been.calledWith 'search', @controller.collection

          it 'should call analytics', ->
            expect(window.analytics.page).to.have.been.calledWith 'Geo Search', {radius: 5, term: 'some query'}
