Collection = require './base/collection'
Inspection = require 'models/inspection'

DEFAULT_LIMIT = 20
DEFAULT_COLUMNS = ['dba_name', 'aka_name', 'address', 'city', 'state', 'zip', 'results', 'inspection_date', 'inspection_id', 'inspection_type', 'license_']

module.exports = class Inspections extends Collection

  model: Inspection
  url: "http://data.cityofchicago.org/resource/4ijn-s7e5.json?$limit=#{DEFAULT_LIMIT}&$select=#{DEFAULT_COLUMNS.join(',')}"

  limit: DEFAULT_LIMIT
  responseLength: 0
  searchType: null
  searchString: null

  parse: (response)->
    # set the length of the response to keep track of offset for future requests
    @responseLength = @responseLength + response.length

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


  search: (term=@searchString, options={})->
    if /^\d{5}$/.test(term)
      @_searchByZip(term, options)
    else
      @_searchByText(term, options)

    @searchString = decodeURI(term)

  searchByLicense: (license, options={})->
    @url = @urlRoot + "&$where=license_=#{license}"
    @_fetchSearch(options)

  _searchByText: (name, options={})->
    options.data =
        '$q': "#{name}"

    @_fetchSearch(options)
    @searchType = 'text'

  _searchByZip: (zipcode, options={})->
    options.data =
      'zip': "#{zipcode}"

    @_fetchSearch(options)
    @searchType = 'zip'

  _fetchSearch: (options)->

    if @responseLength >= DEFAULT_LIMIT
      options.data = options.data || {}
      options.data['$offset'] = @responseLength
      options.remove = false

    @fetch(options)

