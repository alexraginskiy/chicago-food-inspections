CollectionView = require 'views/base/collection-view'
SearchView = require 'views/search-view'
Inspections = require 'models/inspections'
SearchDetailsView = require 'views/search-details-view'
SearchGetMoreView = require 'views/search-get-more-view'

describe 'SearchView', ->
  beforeEach ->
    # stub region events
    Chaplin.mediator.setHandler 'region:register', sinon.spy()

    Chaplin.mediator.setHandler 'region:find', sinon.spy()

    Chaplin.mediator.setHandler 'region:show', sinon.spy()

    # stub url helper
    sinon.stub Chaplin.helpers, 'reverse'

    # stub subview creation
    @subviewSpy = sinon.spy SearchView::, 'subview'

    @clock = sinon.useFakeTimers()

    @collection = new Inspections
    @view = new SearchView collection: @collection

  afterEach ->
    Chaplin.mediator.removeHandlers ['region:register', 'region:find', 'region:show']
    Chaplin.helpers.reverse.restore()

    @subviewSpy.restore()
    @clock.restore()

    @view.dispose()
    @collection.dispose()

  it 'should be a collection view', ->
    expect(@view).to.be.an.instanceOf CollectionView

  it 'should auto render', ->
    expect(@view.autoRender).to.be.true
    expect(@view.$('div')).to.exist

  it 'should have a search details region', ->
    expect(@view.regions).to.have.property 'searchDetails'
    expect(@view.regions.searchDetails).to.equal '.search-details-container'

  it 'should have a get more region', ->
    expect(@view.regions).to.have.property 'searchGetMore'
    expect(@view.regions.searchGetMore).to.equal '.search-results-more-container'

  describe 'initial loading', ->
    beforeEach ->
      @collection.beginSync()

    it 'should have a loading indicator', ->
      expect(@view.loadingSelector).to.equal '.search-results-loading'

    it 'should show loading indicator when collection is syncing', ->
      expect(@view.$('.search-results-loading')).to.have.attr('style').match /display: block/

    it 'should show loading warning after 3 seconds', ->
      expect(@view.$('.search-results-loading-time-warning')).not.to.have.class 'in'
      @clock.tick(3000)
      expect(@view.$('.search-results-loading-time-warning')).to.have.class 'in'

  describe 'showing results', ->

    beforeEach ->
      results = for i in [1..@collection.limit]
        license_: i
        results: 'Pass'

      @collection.responseLength = results.length
      @collection.reset results

    it 'should show all of the results', ->
      expect(@view.$('.list-group-item').length).to.equal 20

    it 'should show result details', ->
      searchDetailsSubView = _(@view.subviews).find (subview)->
        subview.region == 'searchDetails'
      expect(searchDetailsSubView).to.be.an.instanceOf SearchDetailsView

    it 'should show a link to get more results', ->
      searchGetMoreSubview = _(@view.subviews).find (subview)->
        subview.region == 'searchGetMore'

      expect(searchGetMoreSubview).to.be.an.instanceOf SearchGetMoreView

    it 'should hide get more link when there are no more results', ->
      @collection.trigger('fetchedAllSearchResults')

      searchGetMoreSubview = _(@view.subviews).find (subview)->
        subview.region == 'searchGetMore'

      expect(searchGetMoreSubview).to.be.undefined

  describe 'limited results', ->

    beforeEach ->
      results = for i in [1..@collection.limit - 1]
        license_: i
        results: 'Pass'

    it 'should not show get more link', ->
      searchGetMoreSubview = _(@view.subviews).find (subview)->
        subview.region == 'searchGetMore'

      expect(searchGetMoreSubview).to.be.undefined