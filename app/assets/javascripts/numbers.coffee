class Numbers

	constructor: () ->
    #tutorial stuff
    @tutorialOn = $('#buildingjs').data("session")
    @tutorialData = {"bbox":"","created_at":"2013-08-28T21:52:04Z","id":2,"map_id":0,"map_url":null,"poly":[{"color":"8","dn":1058779,"geometry":"[[[-73.9917489385617,40.73160355632643],[-73.99176508603846,40.7315894272398],[-73.9917785422691,40.73159295951173],[-73.99200729818992,40.7316883307832],[-73.99201268068218,40.73169539531639],[-73.99197500323639,40.73173778249977],[-73.99172471734657,40.73163534676037],[-73.9917489385617,40.73160355632643]]]","id":1488,"sheet_id":2,"status":"unprocessed"},{"color":"8","dn":1065840,"geometry":"[[[-73.99285440448465,40.73320584082565],[-73.99291608447433,40.733232825247896],[-73.99291450293613,40.7332390524207],[-73.99289077986317,40.733245279592936],[-73.99286863832842,40.73327849116829],[-73.99278956141856,40.73326603682947],[-73.99283226294989,40.73320168937511],[-73.99284017064087,40.733199613649745],[-73.99285440448465,40.73320584082565]]]","id":2101,"sheet_id":2,"status":"unprocessed"},{"color":"8","dn":1065840,"geometry":"[[[-73.99219510816457,40.73254771536549],[-73.99224570315576,40.73256835946708],[-73.99214451317339,40.7327010713958],[-73.992082242415,40.732674529031236],[-73.99217954047498,40.73254476620759],[-73.99218343239738,40.73254181704957],[-73.99219510816457,40.73254771536549]]]","id":2101,"sheet_id":2,"status":"unprocessed"},{"color":"3","dn":111187,"geometry":"[[[-73.991333336943,40.73301062882454],[-73.99147411122182,40.73303372418245],[-73.99147851041803,40.73305104569565],[-73.9914653128294,40.73309146254221],[-73.99129374417709,40.733062593368594],[-73.99130694176571,40.73300485498379],[-73.991333336943,40.73301062882454]]]","id":69407,"sheet_id":2,"status":"unprocessed"},{"color":"1","dn":1061017,"geometry":"[[[-73.99204496531397,40.733898502139596],[-73.9920540120468,40.733886628675144],[-73.99213724198881,40.733919874370265],[-73.99213905133539,40.73393174782879],[-73.9921064830972,40.73397449226191],[-73.9920847709384,40.73397449226191],[-73.99200696903611,40.733957869430064],[-73.99200515968954,40.73395074535801],[-73.99204496531397,40.733898502139596]]]","id":1984,"sheet_id":2,"status":"unprocessed"},{"color":"8","dn":1084906,"geometry":"[[[-73.99260271561742,40.733666621617616],[-73.99264410318662,40.73367341157545],[-73.99265445007892,40.73368699148904],[-73.99278895967879,40.733741311115665],[-73.99279154640186,40.73375149604072],[-73.99275015883266,40.733799025670365],[-73.992553567879,40.73371754628447],[-73.99257684838668,40.73367341157545],[-73.99258978200206,40.73366322663844],[-73.99260271561742,40.733666621617616]]]","id":69495,"sheet_id":2,"status":"unprocessed"},{"color":"8","dn":1084908,"geometry":"[[[-73.99467876998335,40.714962098308405],[-73.99481423128013,40.71500225525319],[-73.99478364324537,40.71505962227514],[-73.99463070307159,40.71501372866153],[-73.9946569213871,40.71495636160003],[-73.99467876998335,40.714962098308405]]]","id":2018,"sheet_id":2,"status":"unprocessed"},{"color":"12","dn":1095137,"geometry":"[[[-73.9914326318635,40.732605885457374],[-73.99164216035788,40.73269365226407],[-73.99165107646402,40.73273461006758],[-73.99164661841095,40.73274631229252],[-73.99153516708415,40.7326995033804],[-73.99150841876573,40.73268195002986],[-73.99149058655344,40.73268195002986],[-73.99139250938585,40.73264099219395],[-73.991401425492,40.73259418320773],[-73.9914326318635,40.732605885457374]]]","id":69655,"sheet_id":2,"status":"unprocessed"},{"color":"12","dn":1095137,"geometry":"[[[-73.99631771565119,40.738981722245896],[-73.9963831008286,40.73900779683433],[-73.99631771565119,40.73909905781334],[-73.99624544782354,40.73906776834893],[-73.99630739167581,40.738981722245896],[-73.99631771565119,40.738981722245896]]]","id":69655,"sheet_id":2,"status":"unprocessed"},{"color":"1","dn":1123405,"geometry":"[[[-73.99137871882681,40.73271012952303],[-73.99144820633073,40.73271979836216],[-73.9914399003793,40.73275058464772],[-73.99136756952616,40.732740159964955],[-73.99137375971172,40.73270948736736],[-73.99137871882681,40.73271012952303]]]","id":69530,"sheet_id":2,"status":"unprocessed"},{"color":"3","dn":1123406,"geometry":"[[[-73.99150976731543,40.732235259397115],[-73.9915611428715,40.732235259397115],[-73.99158040870505,40.73224368814436],[-73.99163178426112,40.73224368814436],[-73.99165105009465,40.73225211689052],[-73.9916895817617,40.73225211689052],[-73.99170884759523,40.73226054563564],[-73.99176022315132,40.73226054563564],[-73.99177948898485,40.73226897437967],[-73.99180517676288,40.73226897437967],[-73.99181159870739,40.732277403122644],[-73.99179875481836,40.73232797555806],[-73.99183728648545,40.73234483302798],[-73.99185013037444,40.73234483302798],[-73.99184370842994,40.732420691589795],[-73.99185013037444,40.73242912031355],[-73.9918886620415,40.73244597775785],[-73.99180517676288,40.73255555104169],[-73.99174737926229,40.73253026491528],[-73.99172811342875,40.73253869362516],[-73.99147765759288,40.73242912031355],[-73.99146481370386,40.73242912031355],[-73.99143912592584,40.73241226286497],[-73.99147765759288,40.73226054563564],[-73.99147765759288,40.7322268306488],[-73.99150976731543,40.732235259397115]]]","id":69712,"sheet_id":2,"status":"unprocessed"},{"color":"3","dn":1123406,"geometry":"[[[-73.9946878320301,40.71491928210032],[-73.9948462711411,40.71496778046124],[-73.99483103661119,40.71500011268223],[-73.99466345678226,40.71495161434486],[-73.9946725975002,40.714923900993355],[-73.99467869131216,40.714916972653675],[-73.9946878320301,40.71491928210032]]]","id":69712,"sheet_id":2,"status":"unprocessed"},{"color":"3","dn":1123406,"geometry":"[[[-73.99092398657614,40.73119895065988],[-73.99093727994169,40.73119197157895],[-73.99099311207691,40.731216398359],[-73.99095854932654,40.73126176235532],[-73.99089739984507,40.731237335591906],[-73.99092398657614,40.73119895065988]]]","id":69712,"sheet_id":2,"status":"unprocessed"},],"status":"unprocessed","updated_at":"2013-08-28T21:52:04Z"}
    @intro = null
    @prevStep = 0
    @_polyData = {}
    @_currentIndex = -1
    @_currentPolygon = {}
    @tutorialOn = $('#numbersjs').data("session")
    history.replaceState("numbers","inspector","numbers") 
    #end tutorial
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

  addButtonListeners: () =>
    @removeButtonListeners()

    $("#link-help-close").on("click", @hideTutorial)
    $("#link-exit-tutorial").on("click", @hideTutorial)
    $("#link-help").on("click", @invokeTutorial)
    $("#submit-button").on "click", @submitFlags

    $("body").keyup (e)->
      # console.log "key", e.which
      switch e.which
        when 107, 187 then tagger.submitFlags(e)

  removeButtonListeners: () =>
    $("#submit-button").unbind()
    $("#link-help").unbind()
    $("body").unbind("keyup")

  activateButton: (button) =>
    @resetButtons()
    $("#submit-button").addClass("inactive") if button != "submit"
    $("#submit-button").addClass("active") if button = "submit"
    @addButtonListeners()

  resetButtons: () ->
    $("#submit-button").removeClass("inactive")
    $("#submit-button").removeClass("active")

  hideOthers: () ->
    $("#main-container").hide()
    $("#controls").hide()
    $("#map-tutorial").hide()

  showOthers: () ->
    $("#main-container").show()
    $("#controls").show()
    $("#map-tutorial").hide()

  hideTutorial: () =>
    # console.log "end of tutorial"
    if (window.innerWidth < 500)
      @showOthers()
    else
      @intro.exit() if @intro
      @intro = null
      @removeButtonListeners()
      @polyData = _gen.clone(@_polyData)
      @currentIndex = @_currentIndex
      @showNextPolygon()
      @addButtonListeners()
    @tutorialOn = false

  invokeTutorial: () =>
    if (window.innerWidth < 500)
      @hideOthers()
      $("#map-tutorial").unswipeshow()
      $("#map-tutorial").show()
      $("#map-tutorial").swipeshow
        mouse: true
        autostart: false
      .goTo 0
    else
      @_polyData = _gen.clone(@polyData)
      @polyData = _gen.clone(@tutorialData.poly)
      @_currentIndex = @currentIndex - 1
      @currentIndex = -1
      @showNextPolygon()
      @buildTutorial()
    @tutorialOn = true

  buildTutorial: () =>
    tagger = @
    if @intro == null
      @intro = introJs()
      @intro.setOptions(
        skipLabel: "Exit tutorial"
        tooltipClass: "tutorial"
        showStepNumbers: false
        exitOnOverlayClick: false
        steps: [
            {
              element: "#map-highlight"
              intro: "<strong>Here's how this task works</strong><br />We'll show you one computer-generated building outline at a time, laid over the original map."
              position: "bottom"
            }
            {
              element: "#buttons .wrapper"
              intro: "Along with this button. Let's walk through a few examples…"
              position: "top"
            }
            {
              element: "#map-highlight"
              intro: "The address number of this building is 781. Click there and type 781."
              position: "right"
            }
            {
              element: "#submit-button"
              intro: "Press next to save it and go to the next building."
              position: "top"
            }
            {
              element: "#map-highlight"
              intro: "62 or 29? Look around! (remind of even/odd addressing system)"
              position: "right"
            }
            {
              element: "#submit-button"
              intro: "press."
              position: "top"
            }
            {
              element: "#map-highlight"
              intro: "1s may be confused for 4s and vice-versa. look around"
              position: "right"
            }
            {
              element: "#submit-button"
              intro: "Be vigilant!"
              position: "top"
            }
            {
              element: "#map-highlight"
              intro: "3s and 8s are another source of confusion."
              position: "right"
            }
            {
              element: "#submit-button"
              intro: "Press FIX to indicate so."
              position: "top"
            }
            {
              element: "#map-highlight"
              intro: "this building is part of the 33 address."
              position: "right"
            }
            {
              element: "#submit-button"
              intro: "This one's good enough. Press YES and keep going."
              position: "top"
            }
            {
              element: "#map-highlight"
              intro: "Some buildings have no address number."
              position: "right"
            }
            {
              element: "#submit-button"
              intro: "Now you can approve it."
              position: "top"
            }
            {
              element: "#map-highlight"
              intro: "don't be fooled by numbers inside buildings! this is a lucky 13."
              position: "right"
            }
            {
              element: "#submit-button"
              intro: "Those are FIXes."
              position: "top"
            }
            {
              element: "#map-highlight"
              intro: "some have more than one number. type em all!"
              position: "right"
            }
            {
              element: "#submit-button"
              intro: "That's a FIXer."
              position: "top"
            }
            {
              element: "#map-highlight"
              intro: "hand drawn maps go through corrections. we want both numbers [mga note: do we?]"
              position: "right"
            }
            {
              element: "#submit-button"
              intro: "Teach that computer a lesson!"
              position: "top"
            }
            {
              element: "#map-highlight"
              intro: "extra complicated... type fractions as .5 in this case 805.5"
              position: "right"
            }
            {
              element: "#submit-button"
              intro: "Laugh at the poor computer and move on."
              position: "top"
            }
            {
              element: "#map-highlight"
              intro: "i wants moar numberz!"
              position: "right"
            }
            {
              element: "#submit-button"
              intro: "Laugh at the poor computer and move on."
              position: "top"
            }
            {
              element: "#map-highlight"
              intro: "some numbers are shared by more than one building. this 11 would be typed in both."
              position: "right"
            }
            {
              element: "#submit-button"
              intro: "Laugh at the poor computer and move on."
              position: "top"
            }
            {
              element: "#map-highlight"
              intro: "this must be part of the 68 bottom-right (note wall 'entrance' connecting)"
              position: "right"
            }
            {
              element: "#submit-button"
              intro: "That's a YES!"
              position: "top"
            }
            {
              element: "#link-help"
              intro: "<strong>Now you're ready to begin checking buildings!</strong><br />You can always refer to this tutorial again by hitting the HELP button.<br />Have fun! And thanks for helping The New York Public Library."
              position: "left"
            }
        ]
      ).onchange (e) ->
        tagger.parseTutorial(e)
      .oncomplete () ->
        tagger.hideTutorial()
      .onexit () ->
        tagger.hideTutorial()
      .start()
    @

  parseTutorial: (e) =>
    # console.log @intro._currentStep, @currentIndex
    $(".introjs-helperLayer").removeClass("noMap")
    $(".introjs-helperLayer").removeClass("yesNext")
    @removeButtonListeners()

    switch @intro._currentStep
      when 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26
        $(".introjs-helperLayer").addClass("yesNext")
      when 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27
        $(".introjs-helperLayer").addClass("noMap")
        @addButtonListeners()
      when 28
        $(".introjs-helperLayer").addClass("noMap")
    # for polygon show
    switch @intro._currentStep
      when 0,1,2,3
        @currentIndex = -1
      when 4,5 then @currentIndex = 0
      when 6,7 then @currentIndex = 1
      when 8,9 then @currentIndex = 2
      when 10,11 then @currentIndex = 3
      when 12,13 then @currentIndex = 4
      when 14,15 then @currentIndex = 5
      when 16,17 then @currentIndex = 6
      when 18,19 then @currentIndex = 7
      when 20,21 then @currentIndex = 8
      when 22,23 then @currentIndex = 9
      when 24,25 then @currentIndex = 10
      when 26,27,28 then @currentIndex = 11
    @showNextPolygon()
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
    # check if current polygon is somewhat visible in view
    # so user does not get lost
    if @geo.getBounds? and not @map.getBounds().intersects(@geo.getBounds())
      @map.fitBounds( @geo.getBounds() )
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
