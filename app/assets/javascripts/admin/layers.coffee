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

    @map.fitBounds([[$("#data").data("bbox")[0],$("#data").data("bbox")[1]],[$("#data").data("bbox")[2],$("#data").data("bbox")[3]]])

$ ->
  window._l = new Layer