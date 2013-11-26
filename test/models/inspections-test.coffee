Geo         = require 'lib/geolocation'
Inspections = require 'models/inspections'
Collection  = require 'models/base/collection'

describe 'Inspections', ->

  beforeEach ->
    @server = sinon.fakeServer.create()

    @inspections = new Inspections

    # a limit is used to restrict the number of results from the API
    @limit = @inspections.limit = 10
    # quick simulate adding by using parse as would be after a fetch
    @inspections.parseAdd = (items)-> @add @parse(items)

    @triggerSpy = sinon.spy Inspections::, 'trigger'
    @fetchSpy   = sinon.spy Inspections::, 'fetch'

  afterEach ->
    @server.restore()
    @triggerSpy.restore()
    @fetchSpy.restore()

  describe 'setup', ->
    it 'should be a Chaplin collection', ->
      expect(@inspections).to.be.instanceOf Collection

    it 'should have a @limit', ->
      expect(@inspections.limit).to.exist.and.be.a 'number'

    it 'should have a @responseLength of 0', ->
      expect(@inspections.responseLength).to.equal 0

  describe '#parse()', ->
    it 'should set and update @responseLength', ->
      @inspections.parse([1,2,3,4,5])
      expect(@inspections.responseLength).to.equal 5
      @inspections.parse([1,2,3])
      expect(@inspections.responseLength).to.equal 8

    it 'should trigger "fetchedAllSearchResults"', ->
      @inspections.parse [1..@limit]
      expect(@triggerSpy).not.to.have.been.called

      @inspections.parse [1..@limit - 1]
      expect(@triggerSpy).to.have.been.calledWith 'fetchedAllSearchResults'

    it 'should not add facilities that already exist', ->
      # the parse method should strip out any items in the response that have
      # the same `license_` value as any existing record in the collection

      response = ({license_} for license_ in [1..@limit])

      @inspections.parseAdd response
      expect(@inspections).to.have.length(@limit)

      @inspections.parseAdd license_: @limit+1
      expect(@inspections).to.have.length @limit + 1

      expect(@inspections).to.have.length @limit + 1

    it 'should sort the response by `inspection_date`', ->
      response = for inspection_date in [1..@limit]
        {inspection_date, license_: inspection_date}

      @inspections.parseAdd response

      @inspections.each (inspection, index)=>
        expect(inspection.get('inspection_date')).to.equal @limit - index

  describe '#search()', ->

    searchTypes = [
      {
        type: 'text'
        string: 'some text'
        param: '$q'
      }
      {
        type: 'zip'
        string: '12345'
        param: 'zip'
      }
    ]

    _(searchTypes).each (searchType)=>

      describe "#{searchType.type} search" , ->

        beforeEach ->
          @searchString = searchType.string
          @inspections.search(@searchString)

        describe 'getting results', ->

          it 'should determine text search type', ->
            expect(@inspections.searchType).to.equal searchType.type

          it 'should set the search string', ->
            expect(@inspections.searchString).to.equal @searchString

          it 'should fetch results', ->
            fetchOptions = @fetchSpy.firstCall.args[0]
            requests     = @server.requests
            request      = requests[0]
            uri          = new URI(request.url)
            query        = URI.parseQuery uri.query()

            expect(requests).to.have.length(1)
            expect(request.method).to.equal('GET')
            expect(@fetchSpy).to.have.been.calledOnce

            expect(query).to.have.property searchType.param
            expect(query[searchType.param]).to.equal @searchString.replace(/\ /g, '+')
            expect(fetchOptions.data).to.have.property searchType.param
            expect(fetchOptions.data[searchType.param]).to.equal @searchString

        describe 'getting more search results', ->

          beforeEach ->
            # ..ads some mock results
            firstResponse = ({license_} for license_ in [1..@limit])
            @inspections.parseAdd firstResponse

            # our subsequent search should get more
            @inspections.search()

            @firstRequest  = @server.requests[0]
            @secondRequest = @server.requests[1]

          it 'should request the same search with different offset', ->
            firstURI  = new URI(@firstRequest.url)
            secondURI = new URI(@secondRequest.url)

            firstQuery = URI.parseQuery firstURI.query()
            secondQuery = URI.parseQuery secondURI.query()

            expect(secondQuery[searchType.param]).to.exist.and.equal firstQuery[searchType.param]
            expect(+secondQuery.$offset).to.exist.and.equal @inspections.responseLength

          it 'should not remove existing results', ->
            moreResults = ({license_} for license_ in [@limit+1..@limit+10])

            @secondRequest.respond(
              200,
              { "Content-Type": "application/json" },
              JSON.stringify(moreResults))

            @server.respond()

            expect(@inspections).to.have.length(@limit+10)

  describe '#geosearch()', ->

    beforeEach ->
      @lat      = 41.878114
      @lng      = -87.629798
      @radius   = 5

    describe 'setup', ->
      beforeEach ->
        @inspections.geosearch(@lat, @lng, @radius)
        @boundingRect = Geo.boundingRect(@lat, @lng, @radius)

      it 'should set search type', ->
        expect(@inspections.searchType).to.equal 'geo'

      it 'should set the bounding rect', ->
        expect(@inspections.searchBoundingRect)
          .to.exist
          .and.to.deep.equal @boundingRect

      it 'should set the search radius', ->
        expect(@inspections.searchRadius).to.equal @radius

    describe 'without optional query', ->
      beforeEach ->
        @inspections.geosearch(@lat, @lng, @radius)

      it 'should trigger fetch', ->
        expect(@fetchSpy).to.have.been.called

      it 'should search within bounding rect', ->
        fetchCall = @fetchSpy.firstCall
        fetchArg  = fetchCall.args[0]

        expect(fetchArg).to.exist.and.have.deep.property 'data.$where'
        expect(fetchArg.data.$where).to.equal @boundingRect.toQuery()

    describe 'with optional query', ->
      beforeEach ->
        @textQuery = 'some text'
        @inspections.geosearch @lat, @lng, @radius, query: @textQuery

      it 'should trigger fetch', ->
        expect(@fetchSpy).to.have.been.called

      it 'should include query in fetch', ->
        fetchCall = @fetchSpy.firstCall
        fetchArg  = fetchCall.args[0]

        expect(fetchArg).to.exist.and.have.deep.property 'data.$where'
        expect(fetchArg.data.$where).to.equal @boundingRect.toQuery()

        expect(fetchArg).to.have.deep.property 'data.$q'
        expect(fetchArg.data.$q).to.equal @textQuery

    describe 'getting more search results', ->
      beforeEach ->
        @textQuery = 'someText'
        @inspections.geosearch @lat, @lng, @radius, query: @textQuery

        firstResponse = ({license_} for license_ in [1..@limit])
        @inspections.parseAdd firstResponse

        @inspections.geosearch()

        @firstRequest   = @server.requests[0]
        @secondRequest  = @server.requests[1]


      it 'should request the same search with different offset', ->
        firstURI      = new URI(@firstRequest.url)
        secondURI     = new URI(@secondRequest.url)

        firstQuery    = URI.parseQuery firstURI.query()
        secondQuery   = URI.parseQuery secondURI.query()

        expect(secondQuery.$where).to.exist.and.equal(firstQuery.$where)
        expect(secondQuery.$q).to.exist.and.equal(firstQuery.$q)

  describe '#_fetchSearch()', ->
    beforeEach ->
      @inspections._fetchSearch()

      uri = new URI(@server.requests[0].url)
      @parsedQuery = URI.parseQuery uri.query()

    it 'should include limit', ->
      expect(@parsedQuery).to.have.property('$limit')
      expect(+@parsedQuery.$limit).to.equal(@inspections.limit)

    it 'should request default columns', ->
      expect(@parsedQuery).to.have.property('$select')
      expect(@parsedQuery.$select).to.equal(@inspections.columns)
