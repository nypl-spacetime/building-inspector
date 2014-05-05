class Flags
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
      p.showFlags()

  showFlags: () =>
    data = $('#data').data("flags")

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
    )

    bounds = json.getBounds()
    json.addTo(m)
    # m.fitBounds(bounds)

$ ->
  window._f = new Flags