HomeView = require 'views/home-view'

describe 'HomeView', ->

  beforeEach ->
    # stub reverse method
    sinon.stub Chaplin.helpers, 'reverse'

    @view = new HomeView

  afterEach ->
    Chaplin.helpers.reverse.restore()
    @view.dispose()

  it 'should auto render', ->
    expect(@view.autoRender).to.be.true
    expect(@view.$('div')).to.exist

  it 'should link to about page', ->
    expect(Chaplin.helpers.reverse).to.have.been.calledWith 'home#about'

  it 'should have an image of the logo', ->
    expect(@view.$('img.logo-image')).to.exist.and.to.have.attr('src').match /chicago_health_logo.png/