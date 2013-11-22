class Numbers

	constructor: () ->
    @geo = {}
    @firstLoad = true
    @buttonMode = 0
    $("#map-tutorial").hide()
    $("#buttons").hide()
    $("#tweet").hide()

    @map = L.mapbox.map('map', 'https://s3.amazonaws.com/maptiles.nypl.org/859-final/859spec.json', 
      zoomControl: false
      scrollWheelZoom: false
      animate: true
      attributionControl: false
      minZoom: 18
      maxZoom: 21
      dragging: false
      touchZoom: false
    )

    @overlay2 = L.mapbox.tileLayer('https://s3.amazonaws.com/maptiles.nypl.org/860/860spec.json',
      zIndex: 3
    ).addTo(@map)

    L.control.attribution(
      position: 'bottomright'
      prefix: ""
    ).addTo(@map)

    L.control.zoom(
      position: 'topright'
    ).addTo(@map)

    window.map = @

    @addEventListeners()

    tagger = @

    @map.on('load', () ->
      tagger.getPolygons()
      if (tagger.tutorialOn)
        tagger.tID = window.setTimeout(
            () ->
              tagger.invokeTutorial()
            , 1000
        )
    )

  addEventListeners: () =>
    tagger = @

  invokeTutorial: () =>
    @

  getPolygons: () =>
    tagger = @
    mapdata = $('#numbersjs').data("map")
    console.log @firstLoad, mapdata
    if @firstLoad && mapdata.poly.length > 0
      @firstLoad = false
      $("#loader").remove()
      @processPolygons(mapdata)
    else
      $.getJSON('/fixer/map.json?type=numbers', (data) ->
        # console.log(d);
        if data.poly.length > 0
          $("#loader").remove()
          tagger.processPolygons(data)
        else
          # retry until you find a good map
          tagger.getPolygons()
      )

  processPolygons: (data) =>
    data.poly = @shufflePolygons(data.poly)
    @loadedData = data
    @polyData = data.poly
    @updateScore()
    @animateSheet()
    @showNextPolygon()

  animateSheet: () =>
    return if @layer_id == @loadedData.map.layer_id or @tutorialOn
    @layer_id = @loadedData.map.layer_id
    msg = "Now inspecting:<br/>Brooklyn, 1855"
    msg = "Now inspecting:<br/>Manhattan, 1857-62" if @layer_id == 859 # hack // eventually add to sheet table
    el = $("#map-inspecting")
    el.html("<span>" + msg + "</span>")
    .show().delay(2000).fadeOut(1000)

  shufflePolygons: (a) ->
    return a if a.length < 2
    # from: http://coffeescriptcookbook.com/chapters/arrays/shuffling-array-elements
    # From the end of the list to the beginning, pick element `i`.
    for i in [a.length-1..1]
      # Choose random element `j` to the front of `i` to swap with.
      j = Math.floor Math.random() * (i + 1)
      # Swap `j` with `i`, using destructured assignment
      [a[i], a[j]] = [a[j], a[i]]
    # Return the shuffled array.
    a

  submitFlag: (number) =>
    if @tutorialOn
      # do not submit the data
      @intro.goToStep(@intro._currentStep+2)
      return

    type = "numbers"
    _gaq.push(['_trackEvent', 'Flag', type])
    @allPolygonsSession++
    @updateScore()

    tagger = @
    $("#buttons").fadeOut 200 , () ->
      $.get("/fixer/flag", 
        i: tagger.currentPolygon.id
        t: type
        f: number
        , () ->
          tagger.showNextPolygon()
      )
  
  showNextPolygon: () =>
    # console.log @polyData
    @currentIndex++
    @map.removeLayer(@geo)
    if @currentIndex < @polyData.length
      $("#buttons").show()
      @currentPolygon = @polyData[@currentIndex]
      @geo = @makePolygon(@currentPolygon)
      # console.log @currentPolygon #, @currentGeo
      # console.log @geo
      # center on the polygon
      @geo.addTo(@map)
      @map.fitBounds( @geo.getBounds() )
    else
      return if @tutorialOn
      # console.log "Loading more polygons..."
      @currentIndex = -1
      @currentPolygon = {}
      @allPolygonsSession = 0
      @getPolygons()

  makePolygon: (poly) ->
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
        color: '#b00'
        weight: 5
        opacity: 1
        dashArray: '1,16'
        fill: false
    ).addData json

  updateScore: () =>
    if @allPolygonsSession == 0
      @allPolygonsSession = @loadedData.status.all_polygons_session
    
    $("#score .total").text(@allPolygonsSession)

    url = $('#progressjs').data("server")
    tweet = @allPolygonsSession + " buildings checked! Data mining old maps with the Building Inspector from @NYPLMaps @nypl_labs"
    twitterurl = "https://twitter.com/share?url=" + url + "&text=" + tweet

    $("#tweet").show()

    $("#tweet").attr "href", twitterurl

$ ->
  window._n = new Numbers()
