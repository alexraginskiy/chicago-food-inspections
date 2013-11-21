View = require 'views/base/view'

# Site view is a top-level view which is bound to body.
module.exports = class SiteView extends View
  container: 'body'
  id: 'site-container'
  regions:
    searchField: '.search-field'
    main: '.main-content'

  template: require './templates/site'
