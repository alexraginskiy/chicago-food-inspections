Inspection = require 'models/inspection'

describe 'Inspection model', ->

  beforeEach ->
    @inspection = new Inspection inspection_id: 12345

  afterEach ->
    @inspection.dispose()

  it 'should format `inspection_date` date with #friendlyInspectionDate', ->
    sampleInspectionDate = '2013-11-21T00:00:00'
    @inspection.set('inspection_date', sampleInspectionDate)

    expect(@inspection.friendlyInspectionDate()).to.equal moment(sampleInspectionDate).fromNow()

  it 'should format the violations field', ->

    @inspection.set('violations', 'Some text | Comments: then this happened')

    expect(@inspection.formattedViolations()).to.equal 'Some text <br/><br/> <br/>Comments: then this happened'


  it 'should return the #fullAddress()', ->
    @inspection.set
      address: '123 Main St'
      city: 'Chicago'
      state: 'IL'
      zip: '60602'
    expect(@inspection.fullAddress()).to.equal "123 Main St, Chicago, IL 60602"

  # setup for css class names and icons
  results = ['fail', 'pass', 'pass w/ conditions', 'out of business', 'something else']
  classes = ['danger', 'success', 'warning', 'default', 'default']
  icons   = [
    'fa-exclamation-triangle text-danger'
    'fa-check-circle text-success'
    'fa-exclamation-circle text-warning'
    'fa-times-circle text-muted'
    undefined
  ]

  describe '#resultCSSClass()', ->
    _(results).each (result, i)->

      it "should return #{classes[i]} for #{result}", ->
        @inspection.set('results', result)
        expect(@inspection.resultCSSClass()).to.equal classes[i]

  describe '#resultIcon()', ->
    _(results).each (result, i)->

      it "should return #{icons[i]} for #{result}", ->
        @inspection.set('results', result)
        expect(@inspection.resultIcon()).to.equal icons[i]

