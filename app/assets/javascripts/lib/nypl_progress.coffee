class @Progress

  constructor: (options) ->
    # HACK: testing for IE 10 or earlier
    match = /Trident\/5.0/g.test(navigator.userAgent)
    if match # detect trident engine so IE
        $("#ie8").show()

    window.nypl_progress = @ # to make it accessible from console

    @ids = [] # for timed animations (highlights)
    # @_SW = new L.LatLng(40.62563874006115,-74.13093566894531)
    # @_NE = new L.LatLng(40.81640757520087,-73.83087158203125)

    defaults =
      task: '' # geometry, address, polygonfix
      mode: '' # user, all
      loaderID: "#loader"
      containerID: "#map-container"
      jsdataID: ''
      scoreID: "#score .total"
      tweetID: "#tweet"
      tweetString: "_score_ buildings checked! Data mining old maps with the Building Inspector from @NYPLMaps @nypl_labs"
      polygonStyle:
        color: '#609846'
        opacity: 0
        fillOpacity: 0.75
        stroke: false
    @options = $.extend defaults, options

    @loadedData = $(@options.jsdataID).data("progress")

    @layer_id = @loadedData.layer.id

    @tileset = @loadedData.layer.tilejson
    @tiletype = @loadedData.layer.tileset_type

    @bbox = @loadedData.layer.bbox

    @initMap()

  initMap: () ->
    @map = L.mapbox.map('map', 'nypllabs.g6ei9mm0',
      zoomControl: false
      animate: true
      scrollWheelZoom: true
      attributionControl: false
      minZoom: 7
      maxZoom: 21
      dragging: true
      # maxBounds: new L.LatLngBounds(@_SW, @_NE).pad(1)
    )

    t = @

    @zoomControl = L.control.zoom(
      position: 'topright'
    ).addTo(@map)

    @updateTileset()

    @updateLayersControl()

    @addEventListeners()

    @resetSheet()

    L.InspectorMarker = L.Marker.extend
      options:
        total: 0
        sheet_id: 0
        bounds: []

  loadProgress: () ->
    url = "/#{@options.task}/progress.json"
    url = "/#{@options.task}/progress_all.json" if @options.mode == "all"

    url += '?layer_id=' + @layer_id

    p = @

    $.getJSON(url, (data) ->
      p.loadedData = data
      p.getCounts()
    )


  updateTileset: () ->
    @map.removeLayer(@overlay) if @overlay

    @overlay = Utils.addOverlay(@map, @tileset, @tiletype, 3)

  updateLayersControl: () ->
    $("#layers_toggler").remove()

    if @loadedData.layers.length > 1
      html = '<div id="layers_toggler"><select id="layers_select">'

      layer_array = (@createLayerToggle layer for layer in @loadedData.layers)

      # console.log layer_array
      html += layer_array.join("")

      html += "</select></div>"
    else
      layer = @loadedData.layers[0]
      html = "<strong>Map: #{layer.name}, #{layer.year}</strong>"

    $("#legend").prepend(html)

    p = @

    $("#layers_select").on("change", () ->
      # console.log "click:", e.layer
      id = $(this).val()
      p.toggleLayer(Number(id)) unless id == ""
    )

  createLayerToggle: (layer) ->
    selected = if (@layer_id==layer.id) then 'selected=\"selected\"' else ''
    "<option id=\"layer_toggle_#{layer.id}\" #{selected} value=\"#{layer.id}\" data-bbox=\"#{layer.bbox}\" data-tileset=\"#{layer.tilejson}\" data-type=\"#{layer.tileset_type}\">Map: #{layer.name}, #{layer.year}</option>"

  toggleLayer: (id) ->
    @map.removeLayer(@markers) if @markers
    target = $("#layer_toggle_#{id}")

    @tileset = target.data("tileset")
    @tiletype = target.data("type")
    @layer_id = id
    @bbox = target.data("bbox")

    @resetSheet()
    @updateTileset()
    @updateLayersControl()
    @loadProgress()

  addEventListeners: () ->
    p = @
    @map.on('load', @getCounts)

  getMarkerData: (e) =>
    p = @

    el = $(e.originalEvent.target)
    sheet_id = e.layer.options.sheet_id

    spinner_xy = @map.layerPointToContainerPoint(e.layer.getLatLng())
    el.append(Utils.spinner().el)

    color = '#609846'

    url = "/#{@options.task}/progress_user.json"
    url = "/#{@options.task}/progress_sheet.json" if @options.mode == "all"

    url += '?id=' + sheet_id

    $.getJSON(url, (data) ->
      el.find('.spinner').remove()
      p.processData(data)
    )

  resetSheet: () ->
    @clearTimers()
    @map.off 'moveend', @applyHighlights
    $(@options.highlightClass).remove()
    @map.removeLayer @sheet if @map.hasLayer @sheet
    p = @
    @sheet = L.geoJson({features:[]},
      style: (feature) ->
        p.options.polygonStyle
    ).addTo @map
    # additional stuff to be implemented in instance

  clearTimers: () ->
    clearTimeout id for id in @ids

  applyHighlights: (e) =>
    @map.off 'moveend', @applyHighlights
    @map.panBy [0, 20]
    @ids = (setTimeout @showHighlight, i*30, poly for poly, i in @highlights)

  showHighlight: (polygon) =>
    point = @map.latLngToContainerPoint polygon.getBounds().getCenter()
    elem = $('<div><div class="polygon-highlight"></div></div>')
    elem.css("position", "absolute")
    elem.css("top", point.y)
    elem.css("left", point.x)
    $(@options.containerID).append(elem)
    setTimeout @killHighlight, 10, elem
    @

  killHighlight: (elem) =>
    elem.find(@options.highlightClass).addClass("scaled")
    elem.fadeOut 500, () ->
      $(@).remove()

  getCounts: () =>
    @map.removeLayer(@markers) if @markers
    $(@options.loaderID).remove()

    @map.fitBounds(Utils.parseBbox(@bbox))

    @updateScore(@loadedData.all_polygons_session)

    # marker clustering layer
    @markers = new L.MarkerClusterGroup
      singleMarkerMode: true
      disableClusteringAtZoom: 19
      iconCreateFunction: (c) ->
        count = 0
        for child in c.getAllChildMarkers()
          count = count + parseInt(child.options.total)
        cl = 'cluster-large'
        if count < 10
          cl = 'cluster-small'
        else if count < 100
          cl = 'cluster-medium'
        new L.DivIcon
          html: Humanize.compactInteger(count)
          className: cl
          iconSize: L.point(30, 30)
      polygonOptions:
        stroke: false

    p = @

    @markers.on("click", (e) ->
      # console.log "click:", e.layer
      p.resetSheet()
      p.getMarkerData(e)
    )

    @markers.on("clusterclick", (e) ->
      p.resetSheet()
    )

    counts = @loadedData.counts
    @addMarker @markers, count for count in counts

    @markers.addTo @map
    @

  processData: (data) ->
    # to be implemented in instance

  updateScore: (current) =>
    $(@options.scoreID).text(current)

    url = $(@options.jsdataID).data("server")
    tweet = @options.tweetString.replace /_score_/,current
    twitterurl = "https://twitter.com/share?url=#{url}&text=#{tweet}"

    $(@options.tweetID).show()

    $(@options.tweetID).attr "href", twitterurl

  addMarker: (markers, data) ->
    # console.log data

    bounds = Utils.parseBbox(data.bbox)

    latlng = bounds.getCenter()

    markers.addLayer new L.InspectorMarker latlng,
      total: data.total
      sheet_id: (if data.id then data.id else data.sheet_id)
      bounds: bounds
    @
