routes = require 'routes'

describe 'Routes', ->
  beforeEach ->
    @router = new Chaplin.Router pushState: false
    routes @router.match

    # some utilities for testing routes
    @findHandler = (matchString)->
      handler = @router.findHandler (handler)->
        handler.route.test matchString

    @findMatch = (matchString)->
      handler = @findHandler(matchString)
      if handler
        "#{handler.route.controller}##{handler.route.action}"
      else
        false

    @getRouteParams = (matchString)->
      handler = @findHandler(matchString)
      handler.route.extractParams matchString

  afterEach ->
    @router.dispose()

  it 'should route / to home#show', ->
    expect(@findMatch '').to.equal 'home#show'

  it 'should route /about to home#about', ->
    expect(@findMatch 'about').to.equal 'home#about'

  it 'should route /search/:query to search#search', ->
    expect(@findMatch 'search/2342342').to.equal 'search#search'

    expect(@getRouteParams 'search/2342342').to.deep.equal query: '2342342'


  it 'should route /search/within/:radius to search#geosearch', ->
    expect(@findMatch 'search/within/1-mile').to.equal 'search#geosearch'
    expect(@findMatch 'search/within/5-miles').to.equal 'search#geosearch'
    expect(@findMatch 'search/within/text').to.equal false

    expect(@getRouteParams 'search/within/1-mile').to.deep.equal radius: '1-mile'


  it 'should route /search/:query/within/:radius to search#geosearch', ->
    expect(@findMatch 'search/some text/within/1-mile').to.equal 'search#geosearch'
    expect(@findMatch 'search/some text/within/5-mile').to.equal 'search#geosearch'
    expect(@findMatch 'search/some text/within/text').to.equal false

    expect(@getRouteParams 'search/some text/within/1-mile').to.deep.equal query: 'some text', radius: '1-mile'

  it 'should route /facility/:license to facility#show', ->
    expect(@findMatch 'facility/234234234').to.equal 'facility#show'

    expect(@getRouteParams 'facility/234234234').to.deep.equal license: '234234234'
