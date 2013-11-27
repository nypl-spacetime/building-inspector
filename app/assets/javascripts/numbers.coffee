class Numbers

	constructor: () ->
    @flags = {}
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
      dragging: true
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

    @addButtonListeners()
    @map.on('click', @onMapClick)
    @map.on('move', @onMapChange)

    # $("body").keyup (e)->
    #   # console.log "key", e.which
    #   switch e.which
    #     when 27 then console.log "hi"

  addButtonListeners: () =>
    @removeButtonListeners()
    $("#submit-button").on "click", @submitFlags

  removeButtonListeners: () =>
    $("#submit-button").unbind()

  activateButton: (button) =>
    @resetButtons()
    $("#submit-button").addClass("inactive") if button != "submit"
    $("#submit-button").addClass("active") if button = "submit"
    @addButtonListeners()

  resetButtons: () ->
    $("#submit-button").removeClass("inactive")
    $("#submit-button").removeClass("active")

  invokeTutorial: () =>
    @

  getPolygons: () =>
    tagger = @
    mapdata = $('#numbersjs').data("map")
    # console.log @firstLoad, mapdata
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

  submitFlags: (e) =>
    @removeButtonListeners()
    e.preventDefault()
    @activateButton("submit") unless @tutorialOn

    if @tutorialOn
      # do not submit the data
      @intro.goToStep(@intro._currentStep+2)
      return

    type = "numbers"
    _gaq.push(['_trackEvent', 'Flag', type])

    @allPolygonsSession++
    @updateScore()

    flag_data = @prepareData()

    if flag_data.length > 0
      flag_str = flag_data.join("|")
    else
      # console.log "skipped"
      flag_str = ",,NONE"

    tagger = @
    $("#buttons").fadeOut 200 , () ->
      $.get("/fixer/flagnum.json", 
        i: tagger.currentPolygon.id
        t: type
        f: flag_str
        , (data) ->
          # console.log "returned", data
          tagger.resetButtons()
          tagger.showNextPolygon()
      )
  
  prepareData: () =>
    r = []
    for flag, contents of @flags
      latlng = contents.circle.getLatLng()
      txt = contents.value
      r.push "#{latlng.lat},#{latlng.lng},#{txt}" if txt != ""
    r

  showNextPolygon: () =>
    # console.log @polyData
    @cleanFlags()
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
        clickable: false
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

  onMapChange: (e) =>
    # console.log "changed!"
    for flag, contents of @flags
      latlng = contents.circle.getLatLng()
      xy = @map.latLngToContainerPoint(latlng)
      contents.elem.css("left",xy.x)
      contents.elem.css("top",xy.y)

  onMapClick: (e) =>
    # console.log "click", e
    latlng = e.latlng
    lat = latlng.lat
    lng = latlng.lng
    x = e.containerPoint.x
    y = e.containerPoint.y
    
    tagger = @

    circle = L.circleMarker(latlng,
      color: '#d75b25'
      fill: false
      opacity: 0.5
      radius: 28
      weight: 4
    ).addTo @map

    elem = @createFlag(x, y, circle)
    elem.css("top", y)
    elem.css("left", x)
    $("#map-container").append(elem)

    close = elem.find(".num-close")

    close.on "click", (e) ->
      tagger.destroyFlag(this)

    input = elem.find(".input")

    # add data attributes to facilitate flag remove/update
    elem.attr("data-x", x)
    elem.attr("data-y", y)
    close.attr("data-x", x)
    close.attr("data-y", y)
    input.attr("data-x", x)
    input.attr("data-y", y)

    # to fix window resize in iOS
    input.on 'blur', () ->
      window.scrollTo 0, 0

    input.focus()

    setTimeout( ()->
      elem.find(".cont").addClass("active")
      input.on "keyup", (e) ->
          tagger.validateInput(this, e)
      input.on "keydown", (e) ->
        switch e.which
          when 27 then tagger.destroyFlag(this)
          else tagger.validateInput(this, e)
    , 50
    )

  createFlag: (x, y, c) =>
    e = @buildNumberElement(x,y)
    @flags["x-#{x}-y-#{y}"] =
      elem: e
      circle: c
      value: ""
    e

  destroyFlag: (item) =>
    # console.log "destroying", item
    elem = $(item)
    x = elem.attr("data-x")
    y = elem.attr("data-y")
    p = elem.parentsUntil("#map-container")
    if p.length == 0
      elem.remove()
    else
      p.remove()
    flag = @flags["x-#{x}-y-#{y}"]
    @map.removeLayer flag.circle
    delete @flags["x-#{x}-y-#{y}"]

  updateFlag: (x, y, value) =>
    @flags["x-#{x}-y-#{y}"].value = value

  cleanFlags: () =>
    for flag, contents of @flags
      # console.log "destroyed", flag
      @destroyFlag contents.elem[0]

  validateInput: (item, e) =>
    charCode = if e.which then e.which else e.keyCode

    max = 6
    elem = $(item)
    txt = elem.val()

    elem.blur() if charCode == 13 # ENTER

    # console.log charCode
    
    e.preventDefault() if (charCode != 46 && charCode != 190 && charCode != 110 && charCode > 31 && (charCode < 48 || charCode > 57) && (charCode > 105 || charCode < 96))

    e.preventDefault() if txt.indexOf(".") > -1 && (charCode == 190 || charCode == 110)
    # console.log e

    e.preventDefault() if (e.which != 8 && txt.length >= max) || (e.which == 13)

    x = elem.attr("data-x")
    y = elem.attr("data-y")

    # console.log elem, x, y, txt
    @updateFlag x, y, txt


  buildNumberElement: (x,y) =>
    html = "<div id=\"num-x-#{x}-y-#{y}\" class=\"number-flag\"><div class=\"cont\"><input type=\"number\" class=\"input\" step=\"any\" placeholder=\"#\" /><a href=\"javascript:;\" class=\"num-close\">x</a></div></div>"
    el = $(html)
    return el

$ ->
  window._n = new Numbers()
