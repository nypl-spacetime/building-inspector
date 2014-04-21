class GeometryProgress extends Progress

  constructor: () ->
    options =
      jsdataID: '#progressjs'
      highlightClass: ".polygon-highlight"
      task: 'geometry'
      tweetString: "_score_ footprints checked! Data mining old maps with Building Inspector from @NYPLMaps @nypl_labs"
      mode: $('#progressjs').data("mode")
    super(options)

  processData: (data) ->
    p = @

    p.map.off 'moveend', p.applyHighlights

    return if data.nil_poly?.features.length==0 && data.fix_poly.features.length==0 && data.no_poly.features.length==0 && data.yes_poly.features.length==0

    m = p.sheet

    p.highlights = []

    no_color = '#AF2228'
    yes_color = '#609846'
    fix_color = '#FFB92D'
    nil_color = '#908b85'

    yes_json = L.geoJson(data.yes_poly,
      style: (feature) ->
        $.extend p.options.polygonStyle, {fillColor: yes_color}
      onEachFeature: (f, l) ->
        p.highlights.push(l)
    )
    no_json = L.geoJson(data.no_poly,
      style: (feature) ->
        $.extend p.options.polygonStyle, {fillColor: no_color}
      onEachFeature: (f, l) ->
        p.highlights.push(l)
    )
    fix_json = L.geoJson(data.fix_poly,
      style: (feature) ->
        $.extend p.options.polygonStyle, {fillColor: fix_color}
      onEachFeature: (f, l) ->
        p.highlights.push(l)
    )
    nil_json = L.geoJson(data.nil_poly,
      style: (feature) ->
        $.extend p.options.polygonStyle, {fillColor: nil_color}
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

    if data.nil_poly?.features.length>0
      nil_json.addTo(m)
      bounds.extend(nil_json.getBounds())

    p.map.fitBounds(bounds)

    p.map.on 'moveend', p.applyHighlights if @options.mode == "user"

$ ->
  new GeometryProgress()

