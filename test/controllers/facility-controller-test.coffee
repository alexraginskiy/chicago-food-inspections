FacilityController      = require 'controllers/facility-controller'

FacilityInspections     = require 'models/facility-inspections'

LoadingIndicatorView    = require 'views/loading-indicator-view'
FacilityView            = require 'views/facility-view'
FacilityInspectionsView = require 'views/facility-inspections-view'

describe 'FacilityController', ->

  beforeEach ->
    # regions trigger a mediator event that must be handled
    @regionShowSpy = sinon.spy()
    Chaplin.mediator.setHandler 'region:show', @regionShowSpy

    # no wrap views try to find the region through this event, must be handled
    @regionFindSpy = sinon.spy()
    Chaplin.mediator.setHandler 'region:find', @regionFindSpy

    # views which define regions execute this event, must be handled
    @regionRegisterSpy = sinon.spy()
    Chaplin.mediator.setHandler 'region:register', @regionRegisterSpy

    # stub the collection fetch method
    @fetchStub = sinon.stub FacilityInspections::, 'fetch'


    # views that have templates that use url helper need this method stubbed
    sinon.stub Chaplin.helpers, 'reverse'

    # stub the compose method, we just need to make sure it's called
    @composeStub = sinon.stub FacilityController::, 'compose'

    @controller = new FacilityController

  afterEach ->
    Chaplin.mediator.removeHandlers ['region:show', 'region:find', 'region:register']
    Chaplin.helpers.reverse.restore()

    @fetchStub.restore()
    @composeStub.restore()
    @controller.dispose()


  describe '#show()', ->

    describe 'setup', ->
      beforeEach ->
        @controller.show(license: '1234567890')

      it 'should show a loading indicator', ->
        expect(@controller.loadingIndicatorView).to.be.an.instanceOf LoadingIndicatorView
        expect(@controller.loadingIndicatorView.autoRender).to.be.true
        expect(@controller.loadingIndicatorView.region).to.equal 'main'
        expect(@regionShowSpy.args[0]).to.deep.equal ['main', @controller.loadingIndicatorView]


      it 'should create FacilityInspections', ->
        expect(@controller.facilityInspections).to.be.an.instanceOf FacilityInspections
        expect(@controller.facilityInspections.license).to.equal '1234567890'

    describe 'loading and showing results', ->
      beforeEach ->
        @fetchStub.yieldsTo('success')

        sinon.stub FacilityView::, 'render'
        sinon.stub FacilityInspectionsView::, 'render'

        window.analytics =
          page: sinon.spy()

        @controller.show(license: '1234567890')

      afterEach ->
        FacilityView::render.restore()
        FacilityInspectionsView::render.restore()

        delete window.analytics

      it 'should fetch inspections for facility', ->
        expect(@controller.facilityInspections.fetch).to.have.been.called

      it 'should switch to the facility view', ->
        expect(@controller.loadingIndicatorView.disposed).to.be.true

        expect(@controller.facilityView).to.be.an.instanceOf FacilityView
        expect(@controller.facilityView.region).to.equal 'main'

        expect(@controller.facilityInspectionView).to.be.an.instanceOf FacilityInspectionsView
        expect(@controller.facilityInspectionView.region).to.equal 'facilityInspections'
        expect(@controller.facilityInspectionView.collection).to.equal @controller.facilityInspections

      it 'should trigger analytics', ->
        expect(window.analytics.page).to.have.been.calledWith 'Facility', license: '1234567890'
