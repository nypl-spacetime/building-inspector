class Polygon
  constructor: () ->
    @map = L.mapbox.map('map', 'https://s3.amazonaws.com/maptiles.nypl.org/859/859spec.json',
      animate: true
      minZoom: 16
      maxZoom: 21
    )

    @overlay2 = L.mapbox.tileLayer('https://s3.amazonaws.com/maptiles.nypl.org/860/860spec.json',
      zIndex: 3
    ).addTo(@map)

    p = @
    @map.on 'load', () ->
      p.showPolygon()
      p.showFlags()

  showPolygon: () =>
    data = $('#polydata').data("map")

    return if !data or data.features.length==0

    m = @map

    # console.log data

    json = L.geoJson(data,
      style: (feature) ->
        color: '#b00'
        weight: 5
        opacity: 1
        dashArray: '1,16'
        fill: false
    )

    bounds = json.getBounds()

    # console.log bounds

    json.addTo(m)

    m.fitBounds(bounds)

  showFlags: () =>
    data = $('#polydata').data("flags")

    return if !data or data.features.length==0

    m = @map

    # console.log data

    json = L.geoJson(data,
      style: (feature) ->
        color: '#ff0'
        weight: 1
        opacity: 1
        # dashArray: '1,16'
        fill: false
      onEachFeature: (feature, layer) ->
        str = ""
        str += "ID: <a href='/flags/#{feature.properties.id}'>" + feature.properties.id + "</a>" if feature.properties?.id
        str += "<br />" + "User: <a href='/users/#{feature.properties.user_id}'>" + feature.properties.user_id + "</a>" if feature.properties?.user_id
        str += "<br />" + "Session: " + feature.properties.session_id + "</a>" if feature.properties?.session_id
        str += "<br />" + feature.properties.flag_value if feature.properties?.flag_value
        layer.bindPopup(str)
    )

    bounds = json.getBounds()
    json.addTo(m)
    # m.fitBounds(bounds)

$ ->
  window._p = new Polygon