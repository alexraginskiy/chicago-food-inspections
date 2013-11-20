View = require 'views/base/view'
mediator = require 'mediator'

module.exports = class FacilityView extends View
  autoRender: true
  template: require './templates/facility'

  regions:
    'facilityInspections' : '#facility-inspections'

  initialize: ->
    super

  getTemplateData: ->
    data                        = @model.attributes
    data.friendlyInspectionDate = @model.friendlyInspectionDate()
    data.resultClass            = @model.resultCSSClass()
    data.resultIcon             = @model.resultIcon()
    data.fullAddress            = @model.fullAddress()
    data.mapURL                 = @model.mapURL(380, 200)
    data.streetViewURL          = @model.streetViewURL(380, 200)
    data.streetViewURLLarge     = @model.streetViewURL(1200, 600)
    data.lastSearchTerm         = mediator.lastSearchTerm

    console.log data.mapURL

    return data
