class @Progress

  constructor: (options) ->
    # HACK: testing for IE 10 or earlier
    match = /Trident\/5.0/g.test(navigator.userAgent)
    if match # detect trident engine so IE
        $("#ie8").show()

    window.nypl_progress = @ # to make it accessible from console

    @ids = [] # for timed animations (highlights)
    @_SW = new L.LatLng(40.62563874006115,-74.13093566894531)
    @_NE = new L.LatLng(40.81640757520087,-73.83087158203125)

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

    @tileset = @loadedData.layer.tilejson

    @initMap()

  initMap: () ->
    @map = L.mapbox.map('map', 'nypllabs.g6ei9mm0',
      zoomControl: false
      animate: true
      scrollWheelZoom: true
      attributionControl: false
      minZoom: 12
      maxZoom: 21
      dragging: true
      maxBounds: new L.LatLngBounds(@_SW, @_NE).pad(1)
    )

    t = @

    @zoomControl = L.control.zoom(
      position: 'topright'
    ).addTo(@map)

    @updateTileset()

    @addEventListeners()

    @resetSheet()

    L.InspectorMarker = L.Marker.extend
      options:
        total: 0
        sheet_id: 0
        bounds: []

  updateTileset: () ->
    @map.removeLayer(@overlay) if @overlay
    @overlay = L.mapbox.tileLayer(@tileset,
      zIndex: 3
      detectRetina: false # added this because maptiles.nypl does not support retina yet
    ).addTo(@map)

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
    $(@options.loaderID).remove()

    bounds = new L.LatLngBounds(@_SW, @_NE)
    @map.fitBounds bounds

    @updateScore(@loadedData.all_polygons_session)

    # marker clustering layer
    markers = new L.MarkerClusterGroup
      singleMarkerMode: true
      disableClusteringAtZoom: 19
      iconCreateFunction: (c) ->
        count = 0
        for child in c.getAllChildMarkers()
          count = count + parseInt(child.options.total)
        c = 'cluster-large'
        if count < 10
          c = 'cluster-small'
        else if count < 100
          c = 'cluster-medium'
        new L.DivIcon
          html: Humanize.compactInteger(count)
          className: c
          iconSize: L.point(30, 30)
      polygonOptions:
        stroke: false

    p = @

    markers.on("click", (e) ->
      # console.log "click:", e.layer
      p.resetSheet()
      p.getMarkerData(e)
    )

    markers.on("clusterclick", (e) ->
      p.resetSheet()
    )

    counts = @loadedData.counts
    @addMarker markers, count for count in counts

    markers.addTo @map
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

    bbox = data.bbox.split ","

    W = parseFloat(bbox[0])
    S = parseFloat(bbox[1])
    E = parseFloat(bbox[2])
    N = parseFloat(bbox[3])

    SW = new L.LatLng(S, W)
    NW = new L.LatLng(N, W)
    NE = new L.LatLng(N, E)
    SE = new L.LatLng(S, E)

    bounds = new L.LatLngBounds(SW, NE)
    latlng = bounds.getCenter()

    markers.addLayer new L.InspectorMarker latlng,
      total: data.total
      sheet_id: (if data.id then data.id else data.sheet_id)
      bounds: bounds
    @
