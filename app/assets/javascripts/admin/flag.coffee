class Flag
  constructor: () ->
    @map = L.mapbox.map('map', 'nypllabs.g6ei9mm0',
      animate: true
      minZoom: 1
      maxZoom: 21
      attributionControl: false
    )

    tileset = $("#data").data("tiles")
    tiletype = $("#data").data("type")

    @overlay = Utils.addOverlay(@map, tileset, tiletype)

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

    f = @
    @map.on 'load', () ->
      f.showFlag()

  showFlag: () =>
    data = $('#data').data("flag")

    return if !data #or data.features.length==0

    m = @map

    p = @
    console.log data

    json = L.geoJson(data,
      style: (feature) ->
        color: '#f0f'
        weight: 2
        opacity: 1
        dashArray: '4,4'
        fill: false
      onEachFeature: (feature, layer) ->
        # console.log layer
        str = ""
        str += "ID: <a href='/flags/#{feature.properties.id}'>" + feature.properties.id + "</a>" if feature.properties?.id
        str += "<br />" + "User: <a href='/users/#{feature.properties.user_id}'>" + feature.properties.user_id + "</a>" if feature.properties?.user_id
        str += "<br />" + "Session: " + feature.properties.session_id + "</a>" if feature.properties?.session_id
        str += "<br />" + feature.properties.flag_value if feature.properties?.flag_value
        layer.setIcon(p.markerFlag) if feature.geometry.type == "Point"
        layer.bindPopup(str,
          offset: L.point(0, -30)
        )
        layer.on "click", (e) ->
          m.setView(layer.getLatLng(), 20)
    )

    bounds = json.getBounds()
    json.addTo(m).openPopup()
    m.fitBounds(bounds)

$ ->
  window._f = new Flag