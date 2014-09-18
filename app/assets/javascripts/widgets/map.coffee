class Map
  constructor: () ->
    layer_id = $('#sheetdata').data("layer")
    @map = L.mapbox.map('map', "https://s3.amazonaws.com/maptiles.nypl.org/#{layer_id}/#{layer_id}spec.json",
      zoomControl: false
      scrollWheelZoom: false
      touchZoom: false
      animate: false
      attributionControl: true
      minZoom: 12
      maxZoom: 21
      dragging: true
      tileLayer: # added this because maptiles.nypl does not support retina yet
        detectRetina: false
    )

    L.control.zoom(
      position: 'bottomleft'
    ).addTo(@map)

    sheet = @
    @map.on 'load', () ->
      sheet.getPolygons()

  getPolygons: () =>
    data = $('#sheetdata').data("map")

    no_color = '#AF2228'
    yes_color = '#609846'
    fix_color = '#FFB92D'
    nil_color = '#AAAAAA'

    return if data.nil_poly.features.length==0 && data.fix_poly.features.length==0 && data.no_poly.features.length==0 && data.yes_poly.features.length==0

    m = @map

    yes_json = L.geoJson(data.yes_poly,
      style: (feature) ->
        fillColor: yes_color
        opacity: 0
        fillOpacity: 0.7
        stroke: false
    )
    no_json = L.geoJson(data.no_poly,
      style: (feature) ->
        fillColor: no_color
        opacity: 0
        fillOpacity: 0.7
        stroke: false
    )
    fix_json = L.geoJson(data.fix_poly,
      style: (feature) ->
        fillColor: fix_color
        opacity: 0
        fillOpacity: 0.7
        stroke: false
    )
    nil_json = L.geoJson(data.nil_poly,
      style: (feature) ->
        fillColor: nil_color
        opacity: 0
        fillOpacity: 0.7
        stroke: false
    )

    bounds = new L.LatLngBounds()

    if data.yes_poly.features.length>0
      yes_json.addTo(m)
      bounds.extend(yes_json.getBounds())

    if data.no_poly.features.length>0
      no_json.addTo(m)
      bounds.extend(no_json.getBounds())

    if data.fix_poly.features.length>0
      fix_json.addTo(m)
      bounds.extend(fix_json.getBounds())

    if data.nil_poly.features.length>0
      nil_json.addTo(m)
      bounds.extend(nil_json.getBounds())

    m.fitBounds(bounds)

$ ->
  window._s = new Map