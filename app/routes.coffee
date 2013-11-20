module.exports = (match) ->
  match '',                  'home#show'
  match 'search/:query',     'home#search'
  match 'facility/:license', 'facility#show'
  match 'about',             'home#about'