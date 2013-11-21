Collection = require './base/collection'
Inspection = require 'models/inspection'

DEFAULT_LIMIT = 20
DEFAULT_COLUMNS = ['dba_name', 'address', 'city', 'state', 'zip', 'results', 'inspection_date', 'inspection_id', 'inspection_type', 'license_']

module.exports = class Inspections extends Collection


  model: Inspection
  urlRoot: "http://data.cityofchicago.org/resource/4ijn-s7e5.json?$limit=#{DEFAULT_LIMIT}&$select=#{DEFAULT_COLUMNS.join(',')}"

  searchType: null
  searchString: null

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
    @url = @urlRoot + "&$q=#{name}"
    @_fetchSearch(options)
    @searchType = 'text'

  _searchByZip: (zipcode, options={})->
    @url = @urlRoot + "&zip=#{zipcode}"
    @_fetchSearch(options)
    @searchType = 'zip'

  _fetchSearch: (options)->

    if @length >= DEFAULT_LIMIT
      @url = "#{@url}&$offset=#{@length}"
      options.remove = false

    @fetch(options)

