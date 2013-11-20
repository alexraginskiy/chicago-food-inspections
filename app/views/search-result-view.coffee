View = require 'views/base/view'

module.exports = class SearchResultView extends View
  autoRender: true
  noWrap: true
  template: require './templates/search_result'

  getTemplateData: ->
    data                        = @model.attributes
    data.friendlyInspectionDate = @model.friendlyInspectionDate()
    data.resultClass            = @model.resultCSSClass()
    data.resultIcon             = @model.resultIcon()
    data.fullAddress            = @model.fullAddress()
    return data
