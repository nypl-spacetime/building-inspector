class Layer
  constructor: () ->
    @map = L.mapbox.map('map', 'nypllabs.g6ei9mm0',
      animate: true
      minZoom: 6
      maxZoom: 21
      attributionControl: false
    )

    tileset = $("#data").data("tiles")
    tiletype = $("#data").data("type")

    @overlay = Utils.addOverlay(@map, tileset, tiletype)

    bbox = $("#data").data("bbox").split(",")

    @map.fitBounds([[bbox[1],bbox[0]],[bbox[3],bbox[2]]])

$ ->
  window._l = new Layer