class ColorProgress extends Progress

  constructor: () ->
    options =
      jsdataID: '#progressjs'
      highlightClass: ".polygon-highlight"
      task: 'color'
      tweetString: "_score_ building materials classified! Data mining old maps with Building Inspector from @NYPLMaps @nypl_labs"
      mode: $('#progressjs').data("mode")
    super(options)

  processData: (data) ->
    p = @

    p.map.off 'moveend', p.applyHighlights

    # console.log data

    return if data.nil_poly?.features.length==0 && data.green_poly.features.length==0 && data.yellow_poly.features.length==0 && data.pink_poly.features.length==0 && data.blue_poly.features.length==0 && data.gray_poly.features.length==0

    m = p.sheet

    p.highlights = []

    pink_color = '#F1B6BB'
    blue_color = '#00747A'
    yellow_color = '#FF9D00'
    green_color = '#37AD80'
    gray_color = '#303030'
    nil_color = '#908b85'

    blue_json = L.geoJson(data.blue_poly,
      style: (feature) ->
        $.extend p.options.polygonStyle, {fillColor: blue_color}
      onEachFeature: (f, l) ->
        p.highlights.push(l)
    )
    pink_json = L.geoJson(data.pink_poly,
      style: (feature) ->
        $.extend p.options.polygonStyle, {fillColor: pink_color}
      onEachFeature: (f, l) ->
        p.highlights.push(l)
    )
    yellow_json = L.geoJson(data.yellow_poly,
      style: (feature) ->
        $.extend p.options.polygonStyle, {fillColor: yellow_color}
      onEachFeature: (f, l) ->
        p.highlights.push(l)
    )
    green_json = L.geoJson(data.green_poly,
      style: (feature) ->
        $.extend p.options.polygonStyle, {fillColor: green_color}
      onEachFeature: (f, l) ->
        p.highlights.push(l)
    )
    gray_json = L.geoJson(data.gray_poly,
      style: (feature) ->
        $.extend p.options.polygonStyle, {fillColor: gray_color}
      onEachFeature: (f, l) ->
        p.highlights.push(l)
    )
    nil_json = L.geoJson(data.nil_poly,
      style: (feature) ->
        $.extend p.options.polygonStyle, {fillColor: nil_color}
    )

    bounds = new L.LatLngBounds()

    if data.blue_poly.features.length>0
      blue_json.addTo(m)
      bounds.extend(blue_json.getBounds())

    if data.pink_poly.features.length>0
      pink_json.addTo(m)
      bounds.extend(pink_json.getBounds())

    if data.yellow_poly.features.length>0
      yellow_json.addTo(m)
      bounds.extend(yellow_json.getBounds())

    if data.green_poly?.features.length>0
      green_json.addTo(m)
      bounds.extend(green_json.getBounds())

    if data.gray_poly?.features.length>0
      gray_json.addTo(m)
      bounds.extend(gray_json.getBounds())

    if data.nil_poly?.features.length>0
      nil_json.addTo(m)
      bounds.extend(nil_json.getBounds())

    p.map.fitBounds(bounds)

    p.map.on 'moveend', p.applyHighlights if @options.mode == "user"

$ ->
  new ColorProgress()

