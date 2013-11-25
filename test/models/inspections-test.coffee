Inspections = require ('models/inspections')

describe 'Inspections', ->

  beforeEach ->
    @server = sinon.fakeServer.create()
    @inspections = new Inspections

    # a limit is used to restrict the number of results from the API
    @limit = @inspections.limit = 10
    # quick simulate adding by using parse as would be after a fetch
    @inspections.parseAdd = (items)-> @add @parse(items)

    @triggerStub = sinon.stub(Inspections::, 'trigger')

  afterEach ->
    @server.restore()
    @triggerStub.restore()

  describe 'setup', ->
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
      expect(@triggerStub).not.to.have.been.called

      @inspections.parse [1..@limit - 1]
      expect(@triggerStub).to.have.been.calledWith 'fetchedAllSearchResults'

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

      beforeEach ->
        @fetchSpy = sinon.spy Inspections::, 'fetch'

      afterEach ->
        @fetchSpy.restore()

      describe 'text search', ->

        beforeEach ->
          @searchText = 'some text'
          @inspections.search(@searchText)

        it 'should determine text search type', ->
          expect(@inspections.searchType).to.equal 'text'

        it 'should set the search string', ->
          expect(@inspections.searchString).to.equal @searchText

        it 'should fetch results', ->
          fetchOptions = @fetchSpy.firstCall.args[0]

          expect(fetchOptions.data.$q).to.exist
          expect(fetchOptions.data.$q).to.equal @searchText

          requests = @server.requests
          expect(requests).to.have.length(1)

          request = requests[0]
          expect(request.method).to.equal('GET')

          expect(@fetchSpy).to.have.been.calledOnce

          query = URI.parseQuery(request.url)
          expect(query.$q).to.exist
          expect(URI.decodeQuery(query.$q)).to.equal @searchText.replace(/\ /g, '+')

        it 'should fetch more results when called again with empty', ->
          initialRespons = ({license_} for license_ in [1..@limit])
          @inspections.parseAdd initialRespons

          @inspections.search()

          fetchOptions = @fetchSpy.secondCall.args[0]

          expect(fetchOptions.data.$q).to.exist
          expect(fetchOptions.data.$q).to.equal @searchText
          expect(fetchOptions.data.$offset).to.equal = @inspections.responseLenght

          requests = @server.requests
          expect(requests).to.have.length(2)

          _(requests).each (request)=>
            query = URI.parseQuery(request.url)
            expect(query.$q).to.exist
            expect(URI.decodeQuery(query.$q)).to.equal @searchText.replace(/\ /g, '+')

