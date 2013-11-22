# Copyright (C) 2013 Alex Raginskiy
#
# Utilities for geolocation data

# earth's mean radius in miles
EARTH_RADIUS = 3959

class GeoUtilities
  @radiansToDegrees: (radians)->
    radians / (Math.PI / 180)

  @degreesToRadians: (degrees)->
    degrees * (Math.PI / 180)

# Builds a bounding rectangle from center position and a radius
# adapted from http://www.movable-type.co.uk/scripts/latlong-db.html © 2008-2013 Chris Veness
class BoundingRect

  constructor: (@centerLat, @centerLng, @radius)->
    @maxLat = centerLat + GeoUtilities.radiansToDegrees(radius/EARTH_RADIUS)
    @minLat = centerLat - GeoUtilities.radiansToDegrees(radius/EARTH_RADIUS)

    @maxLng = centerLng + GeoUtilities.radiansToDegrees(radius/EARTH_RADIUS/Math.cos(GeoUtilities.degreesToRadians(centerLat)))
    @minLng = centerLng - GeoUtilities.radiansToDegrees(radius/EARTH_RADIUS/Math.cos(GeoUtilities.degreesToRadians(centerLat)))


  # retuns the where portion of a query for this rectangle
  toQuery: ->
    latSelectQuery = "(latitude<=#{@maxLat} AND latitude>=#{@minLat})"
    lngSelectQuery = "(longitude<=#{@maxLng} AND longitude>=#{@minLng})"
    "#{latSelectQuery} AND #{lngSelectQuery}"

class Geolocation
  @boundingRect: (lat, lng, radius)->
    new BoundingRect(lat, lng, radius)

module.exports = Geolocation
