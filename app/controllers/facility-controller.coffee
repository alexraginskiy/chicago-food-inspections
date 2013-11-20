Controller              = require 'controllers/base/controller'

FacilityInspections     = require 'models/facility_inspections'

FacilityView            = require 'views/facility-view'
FacilityInspectionsView = require 'views/facility-inspections-view'

module.exports = class FacilityController extends Controller

  show: (params)->
    @facilityInspections = new FacilityInspections license: params.license
    @facilityInspections.fetch
      success: =>
        @facility = @facilityInspections.first()
        @facilityView = new FacilityView model: @facility, region: 'main'

        @facilityInspectionView = new FacilityInspectionsView collection: @facilityInspections, region: 'facilityInspections'
