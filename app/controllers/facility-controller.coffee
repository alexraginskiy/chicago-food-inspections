Controller              = require 'controllers/base/controller'

FacilityInspections     = require 'models/facility-inspections'

LoadingIndicatorView    = require 'views/loading-indicator-view'
FacilityView            = require 'views/facility-view'
FacilityInspectionsView = require 'views/facility-inspections-view'

module.exports = class FacilityController extends Controller

  show: (params)->
    @loadingIndicatorView = new LoadingIndicatorView autoRender: true, region: 'main'

    @facilityInspections = new FacilityInspections license: params.license
    @facilityInspections.fetch
      success: =>
        @loadingIndicatorView.dispose()
        @facility = @facilityInspections.first()
        @facilityView = new FacilityView model: @facility, region: 'main'

        @facilityInspectionView = new FacilityInspectionsView collection: @facilityInspections, region: 'facilityInspections'


    analytics?.page('Facility', {license: params.license})