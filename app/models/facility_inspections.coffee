Collection = require 'models/base/collection'
Inspection = require 'models/inspection'

module.exports = class FacilityInspections extends Collection
  model: Inspection
  constructor: (options)->
    super
    @license = options.license

  url: ->
    "http://data.cityofchicago.org/resource/4ijn-s7e5.json?$where=license_=#{@license}"