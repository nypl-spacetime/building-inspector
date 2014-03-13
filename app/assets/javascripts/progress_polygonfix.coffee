class PolygonfixProgress extends Progress

  constructor: () ->
    options =
      jsdataID: '#progressjs'
      highlightClass: ".polygon-highlight"
      task: 'polygonfix'
      mode: $('#progressjs').data("mode")
    super(options)

  processData: (data) ->
    p = @

    p.map.off 'moveend', p.applyHighlights

    return if data.poly.features.length==0

    m = p.sheet

    p.highlights = []

    json = L.geoJson(data.poly,
      style: (feature) ->
        p.options.polygonStyle
      onEachFeature: (f, l) ->
        p.highlights.push(l)
    )

    bounds = new L.LatLngBounds()

    if data.poly.features.length>0
      json.addTo(m)
      bounds.extend(json.getBounds())

    p.map.fitBounds(bounds)

    p.map.on 'moveend', p.applyHighlights if @options.mode == "user"

$ ->
  new PolygonfixProgress()

