View = require 'views/base/view'

module.exports = class FacilityInspectionView extends View
  autoRender: true
  noWrap: true
  template: require './templates/facility_inspection'

  getTemplateData: ->
    data                        = @model.attributes
    data.friendlyInspectionDate = @model.friendlyInspectionDate()
    data.resultClass            = @model.resultCSSClass()
    data.resultIcon             = @model.resultIcon()
    data.violations             = @model.formattedViolations()
    return data
