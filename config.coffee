exports.config =
  files:
    javascripts:
      joinTo:
        'javascripts/app.js': /^app/
        'javascripts/vendor.js': /^(?!app)/

    stylesheets:
      joinTo: 'stylesheets/app.css'

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