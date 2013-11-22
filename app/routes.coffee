module.exports = (match) ->
  match '',                             'home#show'
  match 'about',                        'home#about'
  match 'error',                        'home#error'

  match 'search/:query',                'search#search',    name: 'search'
  match 'search/within/:radius',        'search#geosearch', name: 'geosearch'
  match 'search/:query/within/:radius', 'search#geosearch', name: 'keywordGeosearch'

  match 'facility/:license',            'facility#show'