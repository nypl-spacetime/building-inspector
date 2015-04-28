class PolygonfixProgress extends Progress

  constructor: () ->
    options =
      jsdataID: '#progressjs'
      highlightClass: ".polygon-highlight"
      task: 'polygonfix'
      tweetString: "_score_ footprints fixed! Data mining old maps with Building Inspector from @NYPLMaps @nypl_labs"
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
        $.extend {}, p.options.polygonStyle, {
          fillOpacity: 0
          stroke: true
          weight: 3
          dashArray: [1,8]
          lineCap: 'round'
          color: '#fff'
          opacity: 1
        }
    )

    json_fix = L.geoJson(data.fixes,
      style: (feature) ->
        p.options.polygonStyle
      onEachFeature: (f, l) ->
        p.highlights.push(l)
    )

    bounds = new L.LatLngBounds()

    if data.fixes.features.length>0
      json_fix.addTo(m)
      bounds.extend(json_fix.getBounds())

    if data.poly.features.length>0
      json.addTo(m)
      bounds.extend(json.getBounds())

    p.map.fitBounds(bounds)

    p.map.on 'moveend', p.applyHighlights if @options.mode == "user"

$ ->
  new PolygonfixProgress()

