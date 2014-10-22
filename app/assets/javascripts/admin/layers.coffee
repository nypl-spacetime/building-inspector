class Layer
  constructor: () ->
    @map = L.mapbox.map('map', 'nypllabs.g6ei9mm0',
      animate: true
      minZoom: 1
      maxZoom: 21
      attributionControl: false
    )

    tileset = $("#data").data("tiles")

    console.log "hi", tileset, @map

    @overlay = L.mapbox.tileLayer(tileset,
      zIndex: 2
    ).addTo(@map)

    @map.setView($("#data").data("center"), 13)

$ ->
  window._l = new Layer