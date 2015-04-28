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

    return if data?.features.length==0

    m = p.sheet

    p.highlights = []

    # pink_color = '#F1B6BB'
    # blue_color = '#00747A'
    # yellow_color = '#FF9D00'
    # green_color = '#37AD80'
    # gray_color = '#303030'
    nil_color = '#908b85'
    red_color = '#A31500'

    json = L.geoJson(data,
      style: (feature) ->
        $.extend p.options.polygonStyle, {
          stroke: true
          color: red_color
          weight: 2
          opacity: 1
          fillColor: nil_color
          fillOpacity:0.05
          dashArray: [4,6]
        }
      onEachFeature: (f, l) ->
        if p.options.mode != "all"
          p.highlights.push(l)
          colors = f.properties.flag_value.split(",")
          legends = ("<span class='color #{colorstr}'></span>" for colorstr in colors)
        else
          if f.properties.consensus != null
            colors = f.properties.consensus.split(",")
            legends = ("<span class='color #{colorstr}'></span>" for colorstr in colors)
          else
            legends = ["<span class='color nil'></span>"]
        str = legends.join(" ")
        l.bindPopup(str,
          closeButton: false
          className: 'popup-legend'
        )
    )

    bounds = new L.LatLngBounds()

    json.addTo(m)
    bounds.extend(json.getBounds())

    p.map.fitBounds(bounds)

    p.map.on 'moveend', p.applyHighlights if @options.mode == "user"

$ ->
  new ColorProgress()

