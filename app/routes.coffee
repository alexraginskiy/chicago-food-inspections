module.exports = (match) ->
  match '',                             'home#show'
  match 'about',                        'home#about'
  match 'error',                        'home#error'

  match 'search/:query',                'search#search',    name: 'search'
  match 'search/within/:radius',        'search#geosearch', name: 'geosearch', constraints: {radius: /^[0-9]/}
  match 'search/:query/within/:radius', 'search#geosearch', name: 'keywordGeosearch', constraints: {radius: /^[0-9]/}

  match 'facility/:license',            'facility#show'