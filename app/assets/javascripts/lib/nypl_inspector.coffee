class @Inspector

  constructor: (options) ->
    window.nypl_inspector = @ # to make it accessible from console
    @desktopWidth = 600

    defaults =
      editablePolygon: false
      draggableMap: false
      touchZoom: true
      scrollWheelZoom: true
      loaderID: "#loader"
      tutorialOn: true
      tutorialData: {}
      tutorialType: "intro"
      tutorialURL: ""
      buttonsID: "#buttons"
      task: '' # geometry, address, polygonfix
      jsdataID: ''
      scoreID: "#score .total"
      tweetID: "#tweet"
      tweetString: "_score_ buildings checked! Data mining old maps with the Building Inspector from @NYPLMaps @nypl_labs"
      polygonStyle:
        color: '#b00'
        weight: 5
        opacity: 1
        dashArray: '1,16'
        fill: false
    @options = $.extend defaults, options

    # not really options but properties accessible only to the class
    @polyData = {}
    @loadedData = {}
    @currentIndex = -1
    @currentPolygon = {}
    @originalPolygon = [] #to save the pre-edited polygon
    @allPolygonsSession = 0
    @firstLoad = true
    @intro = null
    @layer_id = 0 # HACK for the "now inspecting..." message

    # temp info for when in tutorial
    @_currentIndex = -1
    @_currentPolygon = {}
    @_polyData = {}

    # @geo = {}

    @initMap()

  initMap: () ->
    @map = L.mapbox.map('map', 'https://s3.amazonaws.com/maptiles.nypl.org/859-final/859spec.json',
      zoomControl: false
      scrollWheelZoom: @options.scrollWheelZoom
      touchZoom: @options.touchZoom
      animate: true
      attributionControl: false
      minZoom: 12
      maxZoom: 21
      dragging: @options.draggableMap
    )

    @overlay2 = L.mapbox.tileLayer('https://s3.amazonaws.com/maptiles.nypl.org/860/860spec.json',
      zIndex: 3
    ).addTo(@map)

    L.control.zoom(
      position: 'topright'
    ).addTo(@map)

    @addEventListeners()

    inspector = @

    history.replaceState("fixer","",@options.task)

    @options.tutorialOn = $(@options.jsdataID).data("session")

  clearScreen: () ->
    # rest should be implemented in the inspector instance

  addEventListeners: () ->
    inspector = @
    @map.on('load', () ->
      inspector.getPolygons()
      if (inspector.options.tutorialOn)
        window.setTimeout(
            () ->
              inspector.invokeTutorial()
            , 1000
        )
    )
    @addButtonListeners()
    # rest should be implemented in the inspector instance

  onTutorialClick: (e) =>
    # should be implemented in the inspector instance

  removeEventListeners: () ->
    # rest should be implemented in the inspector instance

  addButtonListeners: () ->
    @removeButtonListeners()
    $("#link-help-close").on("click", @hideTutorial)
    $("#link-exit-tutorial").on("click", @hideTutorial)
    $("#link-help").on("click", @invokeTutorial)

    inspector = @

    $("body").keydown (e)->
      switch e.which
        when 32 then inspector.hidePolygon(e)

    $("body").keyup (e)->
      switch e.which
        when 32 then inspector.showPolygon(e)

    # rest should be implemented in the inspector instance

  removeButtonListeners: () ->
    $("#link-help").unbind()
    $("body").unbind("keyup")
    # rest should be implemented in the inspector instance

  resetButtons: () =>
    @addButtonListeners() unless @options.tutorialOn
    # rest should be implemented in the inspector instance

  submitFlag: (event, data) ->
    @removeButtonListeners()
    event.preventDefault()
    @prepareFlagSubmission(data, "/fixer/flag")

  prepareFlagSubmission: (data, url) ->
    @clearScreen()

    if @options.tutorialOn
      # do not submit the data
      @intro.goToStep(@intro._currentStep+2)
      return

    type = @options.task

    _gaq.push(['_trackEvent', 'Flag', type])
    @allPolygonsSession++
    @updateScore()

    inspector = @

    $(@options.buttonsID).fadeOut 200 , () ->
      $.ajax(
        type: "POST"
        url: url
        data:
          i: inspector.currentPolygon.id
          t: type
          f: data
        success: () ->
          inspector.showNextPolygon()
      )

  updateScore: () ->
    if @allPolygonsSession == 0
      @allPolygonsSession = @loadedData.status.all_polygons_session

    $(@options.scoreID).text(@allPolygonsSession)

    url = $(@options.jsdataID).data("server")
    tweet = @options.tweetString.replace /_score_/,@allPolygonsSession
    twitterurl = "https://twitter.com/share?url=#{url}&text=#{tweet}"

    $(@options.tweetID).show()

    $(@options.tweetID).attr "href", twitterurl

  showMessage: (msg, fade) ->
    el = $("#map-message")
    el.html("<span>" + msg + "</span>").show()
    el.delay(2000).fadeOut(1000) if fade

  showInspectingMessage: () ->
    return if @layer_id == @loadedData.map.layer_id or @options.tutorialOn
    @layer_id = @loadedData.map.layer_id
    msg = "Now inspecting:<br/><strong>Brooklyn, 1855</strong>"
    msg = "Now inspecting:<br/><strong>Manhattan, 1857-62</strong>" if @layer_id == 859 # hack // eventually add to sheet table
    @showMessage(msg, true)

  invokeTutorial: () =>
    if window.innerWidth >= @desktopWidth
      if @options.tutorialType == "intro"
        @_polyData = Utils.clone(@polyData)
        @polyData = Utils.clone(@options.tutorialData.poly.poly)
        @_currentIndex = @currentIndex - 1
        @currentIndex = -1
        @showNextPolygon()
    else
      @hideOthers()
    @buildTutorial()
    @options.tutorialOn = true

  buildTutorial: () ->
    @intro = new NYPL_Map_Tutorial(
      inspector: @
      desktopWidth: @desktopWidth
      type: @options.tutorialType
      url: @options.tutorialURL
      tutorialID: "#map-tutorial"
      highlightID: "#map-highlight"
      steps: @options.tutorialData.steps
      changeFunction: @parseTutorial
      exitFunction: @hideTutorial
      ixactiveFunction: @addButtonListeners
      ixinactiveFunction: @removeButtonListeners
      highlightclickFunction: @onTutorialClick
    )
    @intro.init()

  hideTutorial: () =>
    if window.innerWidth >= @desktopWidth
      @clearScreen()
      @polyData = Utils.clone(@_polyData)
      @currentIndex = @_currentIndex
      @showNextPolygon()
    else
      @showOthers()
    @options.tutorialOn = false

  parseTutorial: () =>
    if @currentIndex != @intro.getCurrentPolygonIndex() + 1
      @currentIndex = @intro.getCurrentPolygonIndex()
      @showNextPolygon()
    @

  hideOthers: () ->
    $("#main-container").hide()
    $("#controls").hide()
    $("#score").hide()
    $("#nypl-mini").hide()
    $("#top-nav").removeClass("open")
    $("#map-tutorial").show()

  showOthers: () ->
    $("#main-container").show()
    $("#controls").show()
    $("#score").show()
    $("#nypl-mini").show()
    $("#map-tutorial").hide()

  showNextPolygon: () ->
    # console.log @polyData
    @clearScreen()
    @currentIndex++

    if @currentIndex < @polyData.length
      $(@options.buttonsID).show()
      @currentPolygon = @polyData[@currentIndex]
      if !@options.editablePolygon
        @makeRegularPolygon()
      else
        # things are slightly different for editable polygon drawing
        @makeEditablePolygon()
      # center on the polygon
      bounds = @geo.getBounds()
      @map.fitBounds( bounds )
      # @map.setZoom( @map.getZoom()-1 ) if @options.tutorialOn
      @resetButtons()
    else
      return if @options.tutorialOn
      # console.log "Loading more polygons..."
      @currentIndex = -1
      @currentPolygon = {}
      @allPolygonsSession = 0
      if @polyData.length == 0
        # no map found, die
        @endGame()
      else
        @getPolygons()

  endGame:() ->
    # no map found, die
    msg = "<strong>No unprocessed polygons found for this task</strong><br />Good news! This seems to be complete. Maybe try another task?"
    @showMessage(msg, false)
    $(@options.buttonsID).hide()

  getPolygons: () ->
    inspector = @
    if @firstLoad
      # using embedded map data
      @firstLoad = false
      mapdata = $(@options.jsdataID).data("map")
      @processPolygons(mapdata)
    else
      $.getJSON("/fixer/map.json?type=#{@options.task}", (data) ->
        # console.log(d);
        inspector.processPolygons(data)
      )

  processPolygons: (data) ->
    $(@options.loaderID).remove()
    @loadedData = data
    @polyData = data.poly
    @updateScore()
    if @polyData?.length > 0
      data.poly = Utils.shuffle(data.poly)
      @showInspectingMessage()
      @showNextPolygon()
    else
      #this only happens when no map was found with polygons
      @endGame()

  makePolygon: (poly) ->
    inspector = @
    json =
      type : "Feature"
      properties:
        DN: poly.dn
        color: poly.color
        id: poly.id
        sheet_id: poly.sheet_id
        status: poly.status
      geometry:
        type: "Polygon"
        coordinates: poly
    geo = L.geoJson({features:[]},
      style: (feature) ->
        inspector.options.polygonStyle
    ).addData json

  makeRegularPolygon: () ->
    inspector = @
    @map.removeLayer(@geo) if @geo
    @geo = @makePolygon($.parseJSON(@currentPolygon.geometry))
    @geo.addTo(@map)

  makeEditablePolygon: () ->
    maxCorners = 6
    # editable polyline works with [[lat,lon],[lat,lon],...] coordinates
    # geojson is [[[lon,lat],[lon,lat],...]]
    coordinates = $.parseJSON(@currentPolygon.geometry)[0]
    if coordinates[0][0] == coordinates[coordinates.length-1][0] && coordinates[0][1] == coordinates[coordinates.length-1][1]
      # same coordinate for the first and last point / redundant
      coordinates.pop()

    @originalPolygon = ([coord[1],coord[0]] for coord in coordinates)

    @originalPolygon = simplifyGeometry(@originalPolygon,0.000025) if coordinates.length > maxCorners

    if (!@geo)
      # console.table coordinates #, @currentGeo
      # console.table transposed #, @currentGeo
      pointIcon = L.icon(
        iconUrl: '/assets/polygonfix/editmarker.png'
        iconSize: [56, 87]
        iconAnchor: [28, 87]
      )
      newPointIcon = L.icon(
        iconUrl: '/assets/polygonfix/editmarker2.png'
        iconSize: [36, 36]
        iconAnchor: [18, 18]
      )
      @geo = L.Polygon.PolygonEditor(@originalPolygon,
        maxMarkers: 10000
        pointIcon: pointIcon
        newPointIcon: newPointIcon
        # style: (feature) ->
        color: '#b00'
        weight: 3
        opacity: 0.5
        # dashArray: '1,16'
        fill: false
        #   clickable: false
      )
    else
      @map._editablePolygons = [] # hack because the leaflet plugin does not destroy preexisting polygons
      @geo.updateLatLngs(@originalPolygon)
    @geo.addTo(@map)

  showPolygon: (e) =>
    inspector = @
    # console.log "showPolygon"
    @geo.setStyle (feature) ->
      inspector.options.polygonStyle

  hidePolygon: (e) =>
    @geo.setStyle (feature) ->
      opacity: 0
