exports.config =
  files:
    javascripts:
      joinTo:
        'javascripts/app.js': /^app/
        'javascripts/vendor.js': /^(vendor|bower_components)/
        'test/javascripts/test.js': /^test(\/|\\)(?!vendor)/
        'test/javascripts/test-vendor.js': /^test(\/|\\)(?=vendor)/

      order:
        after: [
          'test/vendor/scripts/chai-jquery.js'
        ]

    stylesheets:
      joinTo:
        'stylesheets/app.css': /^(app|vendor)/
        'test/stylesheets/test.css': /^test/

    templates:
      joinTo: 'javascripts/app.js'
      paths:
        handlebars: 'bower_components/handlebars/handlebars.js'
        emblem: 'bower_components/emblem.js/emblem.js'

  keyword:
    filePattern: /\.(js|css|html)$/

    map:
      assetPath: '/'
      version: ''

  plugins:
    sass:
      options: ['--precision', '16']

  overrides:
    production:
      paths:
        public: '../inspections-production'

      keyword:
        map:
          assetPath: 'http://alexraginskiy.github.io/chicago-food-inspections/'