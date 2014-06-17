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


    @markerFlag = L.icon(
      iconUrl: '/assets/minimarker.png'
      iconSize: [28, 44]
      iconAnchor: [14, 44]
    )

    @markerConsensus = L.icon(
      iconUrl: '/assets/polygonfix/editmarker.png'
      iconSize: [56, 87]
      iconAnchor: [28, 87]
    )

    p = @
    @map.on 'load', () ->
      p.showPolygon()
      p.showFlags()
      p.showAddresses()

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

    p = @
    # console.log data

    json = L.geoJson(data,
      style: (feature) ->
        color: '#ff0'
        weight: 1
        opacity: 1
        # dashArray: '1,16'
        fill: false
      onEachFeature: (feature, layer) ->
        console.log layer
        str = ""
        str += "ID: <a href='/flags/#{feature.properties.id}'>" + feature.properties.id + "</a>" if feature.properties?.id
        str += "<br />" + "User: <a href='/users/#{feature.properties.user_id}'>" + feature.properties.user_id + "</a>" if feature.properties?.user_id
        str += "<br />" + "Session: " + feature.properties.session_id + "</a>" if feature.properties?.session_id
        str += "<br />" + feature.properties.flag_value if feature.properties?.flag_value
        layer.setIcon(p.markerFlag) if feature.geometry.type == "Point"
        layer.bindPopup(str,
          offset: L.point(0, -30)
        )
    )

    bounds = json.getBounds()
    json.addTo(m)

  showAddresses: () =>
    data = $('#polydata').data("addresses")

    return if !data or data == "N/A" or data.features?.length==0

    m = @map

    p = @
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
        str += "<strong>" + feature.properties.flag_value + "</strong>"
        str += "<br />" + feature.properties.votes + "/" + feature.properties.total_votes
        layer.setIcon(p.markerConsensus)
        layer.bindPopup(str,
          offset: L.point(0, -60)
        )
    )

    bounds = json.getBounds()
    json.addTo(m)
$ ->
  window._p = new Polygon