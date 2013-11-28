SearchFieldView = require 'views/search-field-view'

describe 'SearchFieldView', ->

  beforeEach ->
    @redirectToStub = sinon.stub Chaplin.helpers, 'redirectTo'

    @view = new SearchFieldView

  afterEach ->
    @redirectToStub.restore()
    @view.dispose()

  it 'should auto render', ->
    expect(@view.autoRender).to.be.true
    expect(@view.$el).to.match('.search-field-container')

  it 'should have a search field', ->
    expect(@view.$('input#search-field')).to.exist

  it 'should redirect to search when form is submitted', ->
    query = '   some search text   '
    @view.$('#search-field').val(query)
    @view.$('#search-form').submit()

    expect(@redirectToStub).to.have.been.calledWith 'search', query: 'some%20search%20text'

  it 'should update searchfield value when a search is triggered', ->
    Chaplin.mediator.publish 'search', searchString: 'some search text'

    expect(@view.$('#search-field')).to.have.value 'some search text'

  if navigator.geolocation?
    describe 'geosearch', ->

      beforeEach ->
        @geoSearchButton = @view.$('[data-radius]').first()

      it 'should have a geosearch control', ->
        expect(@view.$('[data-toggle="dropdown"]')).to.be.exist
        expect(@view.$('a.search-location[data-radius]')).to.exist

      it 'should redirect to geosearch', ->
        @geoSearchButton.click()

        expect(@redirectToStub).to.have.been
          .calledWith 'geosearch', radius: @geoSearchButton.data('radius'), query: ""

      it 'should redirect to keywordGeosearch', ->
        @view.$('#search-field').val('some search text   ')
        @geoSearchButton.click()

        expect(@redirectToStub).to.have.been
          .calledWith 'keywordGeosearch', radius: @geoSearchButton.data('radius'), query: "some%20search%20text"

