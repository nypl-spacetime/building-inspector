class AddressProgress extends Progress

  constructor: () ->
    options =
      jsdataID: '#progressjs'
      highlightClass: ".polygon-highlight"
      task: 'address'
      mode: $('#progressjs').data("mode")
    super(options)

  processData: (data) ->
    p = @

    p.map.off 'moveend', p.applyHighlights

    return if data.poly.features.length==0

    m = p.sheet

    p.highlights = []

    json = L.geoJson(data.poly,
      pointToLayer: (f,latlng)->
        L.circle(latlng, 3,
          color: '#d75b25'
          fillOpacity: 0.1
          opacity: 0.5
          # radius: 16
          weight: 4
        )
      style: (feature) ->
        feature.properties
      onEachFeature: (f, l) ->
        p.highlights.push(l)
        # html = "<div class=\"number-flag\"><div class=\"cont\">#{f.properties.flag_value}</div></div>"
        l.bindPopup(f.properties.flag_value,
          # closeButton: false
        )
        l.on "click", (e) ->
          p.map.setView(e.target.getLatLng(), 20)
    )

    bounds = new L.LatLngBounds()

    console.log data, json

    json.addTo(m)
    bounds.extend(json.getBounds())

    p.map.fitBounds(bounds)

    p.map.on 'moveend', p.applyHighlights

$ ->
  new AddressProgress()
