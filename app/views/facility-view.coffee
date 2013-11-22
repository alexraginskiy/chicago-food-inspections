View = require 'views/base/view'
mediator = require 'mediator'

module.exports = class FacilityView extends View
  autoRender: true
  template: require './templates/facility'

  regions:
    'facilityInspections' : '#facility-inspections'

  getTemplateData: ->

    mapImageWidth   = 380
    mapImageHeight  = 220
    headerGradient  = 'linear-gradient(rgba(255,255,255,.95),rgba(255,255,255,0.7) 100%)'

    # view specific data
    data                        = @model.attributes
    data.resultClass            = @model.resultCSSClass()
    data.resultIcon             = @model.resultIcon()
    data.fullAddress            = @model.fullAddress()
    data.mapURL                 = @model.mapURL(mapImageWidth, mapImageHeight)
    data.streetViewURL          = @model.streetViewURL(640, 371)
    data.headerGradient         = headerGradient

    # search related data to go back to the correct results
    searchResults = mediator.searchResults

    if searchResults
      data.searchType   = searchResults.searchType
      data.searchRadius = searchResults.searchRadius
      data.searchString = searchResults.searchString

    return data
