AboutView = require 'views/about-view'

describe 'AboutView', ->

  beforeEach ->
    # stub reverse method

    @view = new AboutView

  afterEach ->
    @view.dispose()

  it 'should auto render', ->
    expect(@view.autoRender).to.be.true
    expect(@view.$('div')).to.exist

  it 'should include current year in the copyright notice', ->
    currentYear = (new Date).getFullYear()
    expect(@view.$('#license-info')).to.contain(currentYear)