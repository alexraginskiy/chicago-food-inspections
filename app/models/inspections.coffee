Geo = require 'lib/geolocation'

Collection = require './base/collection'
Inspection = require 'models/inspection'

DEFAULT_LIMIT = 20
DEFAULT_COLUMNS = ['dba_name', 'aka_name', 'address', 'city', 'state', 'zip', 'results', 'inspection_date', 'inspection_id', 'inspection_type', 'license_']

module.exports = class Inspections extends Collection

  model: Inspection
  url: "http://data.cityofchicago.org/resource/4ijn-s7e5.json"

  limit: DEFAULT_LIMIT
  columns: do -> DEFAULT_COLUMNS.join(',')

  getDefaultData: ->
    '$limit'  : @limit
    '$select' : @columns

  responseLength: 0

  searchType: null
  searchString: null
  searchBoundingRect: null
  searchRadius: null

  parse: (response)->
    # set the length of the response to keep track of offset for future requests
    @responseLength = @responseLength + response.length

    @trigger 'fetchedAllSearchResults' if response.length < @limit

    # group the response by 'license_' to eliminate past entries for the same facility
    groupedFacilities = _.groupBy(response, 'license_')

    # grab and return an array the last inspections for each unique facility
    lastInspections = _.map groupedFacilities, (inspections, facility)->
      inspections[0]

    # reject new inspections against existing list
    existingRecords     = @toJSON()
    existingFacilities  = _.map existingRecords, (record)-> record['license_']
    inspectionsToAdd    = _.reject lastInspections, (inspection)->
      _.contains existingFacilities, inspection['license_']

    # sort the response by latest
    (_.sortBy inspectionsToAdd, 'inspection_date').reverse()

  geosearch: (lat=@searchBoundingRect.centerLat, lng=@searchBoundingRect.centerLng, radius=@searchBoundingRect.radius, options={})->
    # get the bounding rectangle
    bounds = Geo.boundingRect(lat, lng, radius)

    # set the collections search properties for future searches without arguments
    @searchType         = 'geo'
    @searchBoundingRect = bounds
    @searchRadius       = radius

    # set the $where data for the request
    options.data =
      '$where': bounds.toQuery()

    # check if we're including a text search with this request
    # are we passing a search query?
    if options.query?
      options.data['$q'] = options.query
      @_setSearchString(options.query)
      delete options.query

    # was there a search query in the past, and should we use it?
    else if @searchString?
      options.data['$q'] = @searchString

    # trigger the fetch
    @_fetchSearch(options)

  search: (searchString=@searchString, options={})->

    if /^\d{5}$/.test(searchString)
      @_searchByZip(searchString, options)
    else
      @_searchByText(searchString, options)

    @_setSearchString(searchString)

  searchByLicense: (license, options={})->
    @url = @urlRoot + "&$where=license_=#{license}"
    @_fetchSearch(options)

  _searchByText: (name, options={})->
    options.data =
        '$q': "#{decodeURI name}"

    @_fetchSearch(options)
    @searchType = 'text'

  _searchByZip: (zipcode, options={})->
    options.data =
      'zip': "#{zipcode}"

    @_fetchSearch(options)
    @searchType = 'zip'

  _fetchSearch: (options={})->
    # is this fetch looking for more results of an existing search?
    if @responseLength >= @limit
      options.data = options.data || {}
      options.data['$offset'] = @responseLength
      options.remove = false

    options.data = _.extend @getDefaultData(), options.data
    @fetch(options)

  _setSearchString: (searchString)->
    @searchString = decodeURI searchString
