# Application-specific view helpers
# http://handlebarsjs.com/#helpers
# --------------------------------

register = (name, fn) ->
  Handlebars.registerHelper name, fn

# Map helpers
# -----------

# Make 'with' behave a little more mustachey.
register 'with', (context, options) ->
  if not context or Handlebars.Utils.isEmpty context
    options.inverse(this)
  else
    options.fn(context)

# Inverse for 'with'.
register 'without', (context, options) ->
  inverse = options.inverse
  options.inverse = options.fn
  options.fn = inverse
  Handlebars.helpers.with.call(this, context, options)

# Get Chaplin-declared named routes. {{url "likes#show" "105"}}
register 'url', (routeName, params..., options) ->
  Chaplin.helpers.reverse routeName, params

register 'linkTo', (url, text)->
  return new Handlebars.SafeString "<a href='#{url}'>#{text}</a>"

register 'fromNow', (date)->
  moment(date).fromNow()

register 'mmddyy', (date)->
  moment(date).format('M/D/YYYY')

register 'icon', (iconClasses)->
  return new Handlebars.SafeString "<i class='fa #{iconClasses}'></i>"