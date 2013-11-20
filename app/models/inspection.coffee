Model = require 'models/base/model'

module.exports = class Inspection extends Model

  friendlyInspectionDate: ->
    inspectionDate = @get('inspection_date')
    formatted = moment(inspectionDate).fromNow()

  formattedViolations: ->
    return unless @get('violations')
    violations = @get('violations')
    violations = violations.replace(/\|/g, '<br/><br/>')
    violations = violations.replace(/Comments:/g, '<br/>Comments:')
  resultCSSClass: ->
    result = @get('results').toLowerCase()
    if result == 'fail'
      cssClass = 'danger'
    else if result == 'pass'
      cssClass = 'success'
    else if result == 'pass w/ conditions'
      cssClass = 'warning'
    else
      cssClass = 'default'

    return cssClass

  resultIcon: ->
    result = @get('results').toLowerCase()

    if result == 'fail'
      iconClass = 'fa-exclamation-triangle text-danger'
    else if result == 'pass'
      iconClass = 'fa-check-circle text-success'
    else if result == 'pass w/ conditions'
      iconClass = 'fa-exclamation-circle text-warning'
    else if result == 'out of business'
      iconClass = 'fa-times-circle text-muted'

    return iconClass

  fullAddress: ->
    address = $.trim @get('address')
    city    = $.trim @get('city')
    state   = $.trim @get('state')
    zip     = $.trim @get('zip')
    "#{address}, #{city}, #{state} #{zip}"

  mapURL: (width=380, height=380)->
    encodeURI "http://maps.googleapis.com/maps/api/staticmap?zoom=16&size=#{width}x#{height}&sensor=false&markers=size:mid|color:red|#{@fullAddress()}"

  streetViewURL: (width=380, height=380)->
    encodeURI "http://maps.googleapis.com/maps/api/streetview?size=#{width}x#{height}&location=#{@fullAddress()}&fov=90&sensor=false"