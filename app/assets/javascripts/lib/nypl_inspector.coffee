class @Inspector

  constructor: (options) ->
    window.nypl_inspector = @ # to make it accessible from console

    defaults =
      draggableMap: false
      loaderID: "#loader"
      tutorialOn: true
      tutorialData: {}
      tutorialID: "#map-tutorial"
      tutorialHighlightID: "#map-highlight"
      buttonsID: "#buttons"
      task: '' # geometry, numbers, polygonfix
      jsdataID: ''
      scoreID: "#score .total"
      tweetID: "#tweet"
      tweetString:  ""
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
    @allPolygonsSession = 0
    @firstLoad = true
    @intro = null
    @layer_id = 0 # HACK for the "now inspecting..." message

    # temp info for when in tutorial
    @_currentIndex = -1
    @_currentPolygon = {}
    @_polyData = {}

    @geo = {}

    @initMap()

  initMap: () =>
    @map = L.mapbox.map('map', 'https://s3.amazonaws.com/maptiles.nypl.org/859-final/859spec.json', 
      zoomControl: false
      scrollWheelZoom: false
      animate: true
      attributionControl: false
      minZoom: 18
      maxZoom: 21
      dragging: @options.draggableMap
      touchZoom: false
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

    @map.on('load', () ->
      inspector.getPolygons()
      if (inspector.options.tutorialOn)
        window.setTimeout(
            () ->
              inspector.invokeTutorial()
            , 1000
        )
    )

  clearScreen: () =>
    # rest should be implemented in the inspector instance

  addEventListeners: () =>
    inspector = @
    $("#link-help-close").on("click", @hideTutorial)
    $("#link-exit-tutorial").on("click", @hideTutorial)
    $("#link-help").on("click", @invokeTutorial)

    $("body").keydown (e)->
      switch e.which
        when 32 then inspector.hidePolygon(e)

    $("body").keyup (e)->
      switch e.which
        when 32 then inspector.showPolygon(e)

    @addButtonListeners()
    # rest should be implemented in the inspector instance

  onTutorialClick: (e) =>
    # should be implemented in the inspector instance

  removeEventListeners: () =>
    $("#link-help").unbind()
    $("body").unbind("keyup")
    # rest should be implemented in the inspector instance

  addButtonListeners: () =>
    @removeButtonListeners()
    # rest should be implemented in the inspector instance

  removeButtonListeners: () =>
    # rest should be implemented in the inspector instance

  resetButtons: () =>
    @addButtonListeners() unless @options.tutorialOn
    # rest should be implemented in the inspector instance

  submitSingleFlag: (type, data) =>
    @prepareFlagSubmission(type, data, "/fixer/flag")

  submitMultipleFlags: (type, data) =>
    @prepareFlagSubmission(type, data, "/fixer/flagnum.json")

  prepareFlagSubmission: (type, data, url) =>
    @clearScreen()

    if @options.tutorialOn
      # do not submit the data
      @intro.goToStep(@intro._currentStep+2)
      return

    _gaq.push(['_trackEvent', 'Flag', type])
    @allPolygonsSession++
    @updateScore()

    inspector = @

    $(@options.buttonsID).fadeOut 200 , () ->
      $.get(url,
        i: inspector.currentPolygon.id
        t: type
        f: data
        , () ->
          inspector.showNextPolygon()
      )

  updateScore: () =>
    if @allPolygonsSession == 0
      @allPolygonsSession = @loadedData.status.all_polygons_session

    $(@options.scoreID).text(@allPolygonsSession)

    url = $(@options.jsdataID).data("server")
    tweet = @options.tweetString.replace /_score_/,@allPolygonsSession
    twitterurl = "https://twitter.com/share?url=#{url}&text=#{tweet}"

    $(@options.tweetID).show()

    $(@options.tweetID).attr "href", twitterurl

  showInspectingMessage: () =>
    return if @layer_id == @loadedData.map.layer_id or @options.tutorialOn
    @layer_id = @loadedData.map.layer_id
    msg = "Now inspecting:<br/><strong>Brooklyn, 1855</strong>"
    msg = "Now inspecting:<br/><strong>Manhattan, 1857-62</strong>" if @layer_id == 859 # hack // eventually add to sheet table
    el = $("#map-inspecting")
    el.html("<span>" + msg + "</span>")
    .show().delay(2000).fadeOut(1000)

  invokeTutorial: () =>
    if (window.innerWidth < 500)
      @hideOthers()
      $(@options.tutorialID).unswipeshow()
      $(@options.tutorialID).show()
      $(@options.tutorialID).swipeshow
        mouse: true
        autostart: false
      .goTo 0
    else
      @_polyData = Utils.clone(@polyData)
      @polyData = Utils.clone(@options.tutorialData.poly.poly)
      @_currentIndex = @currentIndex - 1
      @currentIndex = -1
      @showNextPolygon()
      @buildTutorial()
    @options.tutorialOn = true

  hideOthers: () ->
    $("#main-container").hide()
    $("#controls").hide()
    $("#map-tutorial").hide()

  showOthers: () ->
    $("#main-container").show()
    $("#controls").show()
    $("#map-tutorial").hide()

  showNextPolygon: () =>
    # console.log @polyData
    @currentIndex++
    @map.removeLayer(@geo)
    if @currentIndex < @polyData.length
      $(@options.buttonsID).show()
      @currentPolygon = @polyData[@currentIndex]
      @geo = @makePolygon(@currentPolygon)
      # console.log @currentPolygon #, @currentGeo
      # console.log @geo
      # center on the polygon
      @geo.addTo(@map)
      @map.fitBounds( @geo.getBounds() )
      @resetButtons()
    else
      return if @options.tutorialOn
      # console.log "Loading more polygons..."
      @currentIndex = -1
      @currentPolygon = {}
      @allPolygonsSession = 0
      @getPolygons()

  getPolygons: () =>
    inspector = @
    mapdata = $(@options.jsdataID).data("map")
    if @firstLoad && mapdata.poly.length > 0
      @firstLoad = false
      $(@options.loaderID).remove()
      @processPolygons(mapdata)
    else
      $.getJSON("/fixer/map.json?type=#{@options.task}", (data) ->
        # console.log(d);
        if data.poly.length > 0
          $(@options.loaderID).remove()
          inspector.processPolygons(data)
        else
          # retry until you find a good map
          inspector.getPolygons()
      )

  processPolygons: (data) =>
    data.poly = Utils.shuffle(data.poly)
    @loadedData = data
    @polyData = data.poly
    @updateScore()
    @showInspectingMessage()
    @showNextPolygon()

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
        coordinates: $.parseJSON(poly.geometry)
    geo = L.geoJson({features:[]},
      style: (feature) ->
        inspector.options.polygonStyle
    ).addData json

  showPolygon: (e) =>
    inspector = @
    # console.log "showPolygon"
    @geo.setStyle (feature) ->
      inspector.options.polygonStyle

  hidePolygon: (e) =>
    if @geo._hideAll
      @geo._hideAll() # hacky
    else
      @geo.setStyle (feature) ->
        opacity: 0

  buildTutorial: () =>
    @intro = new NYPL_Map_Tutorial(
      highlightID: @options.tutorialHighlightID
      steps: @options.tutorialData.steps
      changeFunction: @parseTutorial
      exitFunction: @hideTutorial
      ixactiveFunction: @addButtonListeners
      ixinactiveFunction: @removeButtonListeners
      highlightclickFunction: @onTutorialClick
    )
    @intro.init()

  parseTutorial: () =>
    @currentIndex = @intro.getCurrentPolygonIndex()
    @showNextPolygon()
    @

  hideTutorial: () =>
    # console.log "end of tutorial"
    @clearScreen()
    if (window.innerWidth < 500)
      @showOthers()
    else
      @intro.exit()
      @polyData = Utils.clone(@_polyData)
      @currentIndex = @_currentIndex
      @showNextPolygon()
    @options.tutorialOn = false
