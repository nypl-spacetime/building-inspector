class Layer
  constructor: () ->
    @map = L.mapbox.map('map', 'nypllabs.g6ei9mm0',
      animate: true
      minZoom: 1
      maxZoom: 21
      attributionControl: false
    )

    tileset = $("#data").data("tiles")

    @overlay = L.mapbox.tileLayer(tileset,
      zIndex: 2
    ).addTo(@map)

    bbox = $("#data").data("bbox")

    @map.fitBounds([[bbox[0],bbox[1]],[bbox[2],bbox[3]]])

$ ->
  window._l = new Layer