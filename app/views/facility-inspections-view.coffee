CollectionView = require 'views/base/collection-view'
FacilityInspectionView = require 'views/facility-inspection-view'

module.exports = class FacilityInspectionsView extends CollectionView
  autoRender: true
  template: require './templates/facility_inspections'
  itemView: FacilityInspectionView
  listSelector: '.facility-inspections-list'