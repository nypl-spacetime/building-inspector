class Polygonfix

  constructor: () ->
    #tutorial stuff
    @tutorialOn = $('#polygonfixjs').data("session")
    @tutorialData = {"bbox":"","created_at":"2013-08-28T21:52:04Z","id":2,"map_id":0,"map_url":null,"poly":[{"color":"8","dn":1058779,"geometry":"[[[-73.9917489385617,40.73160355632643],[-73.99176508603846,40.7315894272398],[-73.9917785422691,40.73159295951173],[-73.99200729818992,40.7316883307832],[-73.99201268068218,40.73169539531639],[-73.99197500323639,40.73173778249977],[-73.99172471734657,40.73163534676037],[-73.9917489385617,40.73160355632643]]]","id":1488,"sheet_id":2,"status":"unprocessed"},{"color":"8","dn":1065840,"geometry":"[[[-73.99285440448465,40.73320584082565],[-73.99291608447433,40.733232825247896],[-73.99291450293613,40.7332390524207],[-73.99289077986317,40.733245279592936],[-73.99286863832842,40.73327849116829],[-73.99278956141856,40.73326603682947],[-73.99283226294989,40.73320168937511],[-73.99284017064087,40.733199613649745],[-73.99285440448465,40.73320584082565]]]","id":2101,"sheet_id":2,"status":"unprocessed"},{"color":"8","dn":1065840,"geometry":"[[[-73.99219510816457,40.73254771536549],[-73.99224570315576,40.73256835946708],[-73.99214451317339,40.7327010713958],[-73.992082242415,40.732674529031236],[-73.99217954047498,40.73254476620759],[-73.99218343239738,40.73254181704957],[-73.99219510816457,40.73254771536549]]]","id":2101,"sheet_id":2,"status":"unprocessed"},{"color":"3","dn":111187,"geometry":"[[[-73.991333336943,40.73301062882454],[-73.99147411122182,40.73303372418245],[-73.99147851041803,40.73305104569565],[-73.9914653128294,40.73309146254221],[-73.99129374417709,40.733062593368594],[-73.99130694176571,40.73300485498379],[-73.991333336943,40.73301062882454]]]","id":69407,"sheet_id":2,"status":"unprocessed"},{"color":"1","dn":1061017,"geometry":"[[[-73.99204496531397,40.733898502139596],[-73.9920540120468,40.733886628675144],[-73.99213724198881,40.733919874370265],[-73.99213905133539,40.73393174782879],[-73.9921064830972,40.73397449226191],[-73.9920847709384,40.73397449226191],[-73.99200696903611,40.733957869430064],[-73.99200515968954,40.73395074535801],[-73.99204496531397,40.733898502139596]]]","id":1984,"sheet_id":2,"status":"unprocessed"},{"color":"8","dn":1084906,"geometry":"[[[-73.99260271561742,40.733666621617616],[-73.99264410318662,40.73367341157545],[-73.99265445007892,40.73368699148904],[-73.99278895967879,40.733741311115665],[-73.99279154640186,40.73375149604072],[-73.99275015883266,40.733799025670365],[-73.992553567879,40.73371754628447],[-73.99257684838668,40.73367341157545],[-73.99258978200206,40.73366322663844],[-73.99260271561742,40.733666621617616]]]","id":69495,"sheet_id":2,"status":"unprocessed"},{"color":"8","dn":1084908,"geometry":"[[[-73.99467876998335,40.714962098308405],[-73.99481423128013,40.71500225525319],[-73.99478364324537,40.71505962227514],[-73.99463070307159,40.71501372866153],[-73.9946569213871,40.71495636160003],[-73.99467876998335,40.714962098308405]]]","id":2018,"sheet_id":2,"status":"unprocessed"},{"color":"12","dn":1095137,"geometry":"[[[-73.9914326318635,40.732605885457374],[-73.99164216035788,40.73269365226407],[-73.99165107646402,40.73273461006758],[-73.99164661841095,40.73274631229252],[-73.99153516708415,40.7326995033804],[-73.99150841876573,40.73268195002986],[-73.99149058655344,40.73268195002986],[-73.99139250938585,40.73264099219395],[-73.991401425492,40.73259418320773],[-73.9914326318635,40.732605885457374]]]","id":69655,"sheet_id":2,"status":"unprocessed"},{"color":"12","dn":1095137,"geometry":"[[[-73.99631771565119,40.738981722245896],[-73.9963831008286,40.73900779683433],[-73.99631771565119,40.73909905781334],[-73.99624544782354,40.73906776834893],[-73.99630739167581,40.738981722245896],[-73.99631771565119,40.738981722245896]]]","id":69655,"sheet_id":2,"status":"unprocessed"},{"color":"1","dn":1123405,"geometry":"[[[-73.99137871882681,40.73271012952303],[-73.99144820633073,40.73271979836216],[-73.9914399003793,40.73275058464772],[-73.99136756952616,40.732740159964955],[-73.99137375971172,40.73270948736736],[-73.99137871882681,40.73271012952303]]]","id":69530,"sheet_id":2,"status":"unprocessed"},{"color":"3","dn":1123406,"geometry":"[[[-73.99150976731543,40.732235259397115],[-73.9915611428715,40.732235259397115],[-73.99158040870505,40.73224368814436],[-73.99163178426112,40.73224368814436],[-73.99165105009465,40.73225211689052],[-73.9916895817617,40.73225211689052],[-73.99170884759523,40.73226054563564],[-73.99176022315132,40.73226054563564],[-73.99177948898485,40.73226897437967],[-73.99180517676288,40.73226897437967],[-73.99181159870739,40.732277403122644],[-73.99179875481836,40.73232797555806],[-73.99183728648545,40.73234483302798],[-73.99185013037444,40.73234483302798],[-73.99184370842994,40.732420691589795],[-73.99185013037444,40.73242912031355],[-73.9918886620415,40.73244597775785],[-73.99180517676288,40.73255555104169],[-73.99174737926229,40.73253026491528],[-73.99172811342875,40.73253869362516],[-73.99147765759288,40.73242912031355],[-73.99146481370386,40.73242912031355],[-73.99143912592584,40.73241226286497],[-73.99147765759288,40.73226054563564],[-73.99147765759288,40.7322268306488],[-73.99150976731543,40.732235259397115]]]","id":69712,"sheet_id":2,"status":"unprocessed"},{"color":"3","dn":1123406,"geometry":"[[[-73.9946878320301,40.71491928210032],[-73.9948462711411,40.71496778046124],[-73.99483103661119,40.71500011268223],[-73.99466345678226,40.71495161434486],[-73.9946725975002,40.714923900993355],[-73.99467869131216,40.714916972653675],[-73.9946878320301,40.71491928210032]]]","id":69712,"sheet_id":2,"status":"unprocessed"},{"color":"3","dn":1123406,"geometry":"[[[-73.99092398657614,40.73119895065988],[-73.99093727994169,40.73119197157895],[-73.99099311207691,40.731216398359],[-73.99095854932654,40.73126176235532],[-73.99089739984507,40.731237335591906],[-73.99092398657614,40.73119895065988]]]","id":69712,"sheet_id":2,"status":"unprocessed"},],"status":"unprocessed","updated_at":"2013-08-28T21:52:04Z"}
    @intro = null
    @prevStep = 0
    @polyData = {}
    @loadedData = {}
    @currentIndex = -1
    @currentPolygon = {}
    @allPolygonsSession = 0
    @_polyData = {}
    @_currentIndex = -1
    @_currentPolygon = {}
    @tutorialOn = $('#polygonfixjs').data("session")
    history.replaceState("polygonfix","inspector","polygonfix") 
    #end tutorial
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

    # L.control.attribution(
    #   position: 'bottomright'
    #   prefix: ""
    # ).addTo(@map)

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

  addButtonListeners: () =>
    tagger = @
    @removeButtonListeners()

    $("#link-help-close").on("click", @hideTutorial)
    $("#link-exit-tutorial").on("click", @hideTutorial)
    $("#link-help").on("click", @invokeTutorial)
    $("#submit-button").on "click", @submitFlags

    # $("body").keyup (e)->
    #   # console.log "key", e.which
    #   switch e.which
    #     when 107, 187 then tagger.submitFlags(e)

  removeButtonListeners: () =>
    $("#submit-button").unbind()
    $("#link-help").unbind()
    # $("body").unbind("keyup")

  activateButton: (button) =>
    $("#submit-button").addClass("inactive") if button != "submit"
    $("#submit-button").addClass("active") if button == "submit"

  resetButtons: () ->
    $("#submit-button").removeClass("inactive")
    $("#submit-button").removeClass("active")
    @addButtonListeners() unless @tutorialOn

  getPolygons: () =>
    tagger = @
    mapdata = $('#polygonfixjs').data("map")
    # console.log "firstLoad", @firstLoad, mapdata
    if @firstLoad && mapdata.poly.length > 0
      @firstLoad = false
      $("#loader").remove()
      @processPolygons(mapdata)
    else
      $.getJSON('/fixer/map.json?type=polygonfix', (data) ->
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
    @activateButton("none")
    @removeButtonListeners()
    e.preventDefault()

    if @tutorialOn
      # do not submit the data
      @intro.goToStep(@intro._currentStep+2)
      return

    type = "polygonfix"
    _gaq.push(['_trackEvent', 'Flag', type])

    @allPolygonsSession++
    @updateScore()

    tagger = @

    flag_str = @getFixedPolygon()

    # console.log flag_str

    if !flag_str
      $("#buttons").fadeOut 200 , () ->
        tagger.showNextPolygon()
    else
      $("#buttons").fadeOut 200 , () ->
        $.get("/fixer/flag.json", 
          i: tagger.currentPolygon.id
          t: type
          f: flag_str
          , (data) ->
            # console.log "returned", data
            tagger.showNextPolygon()
        )

  showNextPolygon: () =>
    @currentIndex++
    if @currentIndex < @polyData.length
      $("#buttons").show()
      @currentPolygon = @polyData[@currentIndex]
      @makePolygon()
      @geo.addTo(@map)
      # center on the polygon
      @map.fitBounds( @geo.getBounds() )
      @resetButtons()
    else
      return if @tutorialOn
      # console.log "Loading more polygons..."
      @currentIndex = -1
      @currentPolygon = {}
      @allPolygonsSession = 0
      @getPolygons()

  makePolygon: () =>
    # editable polyline works with [[lat,lon],[lat,lon],...] coordinates
    # geojson is [[[lon,lat],[lon,lat],...]]
    coordinates = $.parseJSON(@currentPolygon.geometry)[0]
    if coordinates[0][0] == coordinates[coordinates.length-1][0] && coordinates[0][1] == coordinates[coordinates.length-1][1]
      # same coordinate for the first and last point / redundant
      coordinates.pop()
    transposed = ([coord[1],coord[0]] for coord in coordinates)

    if (!@geo)
      # console.table coordinates #, @currentGeo
      # console.table transposed #, @currentGeo
      pointIcon = L.icon(
        iconUrl: '/assets/polygonfix/editmarker.png'
        iconSize: [21, 21]
        iconAnchor: [10, 10]
      )
      newPointIcon = L.icon(
        iconUrl: '/assets/polygonfix/editmarker2.png'
        iconSize: [16, 16]
        iconAnchor: [8, 8]
      )
      @geo = L.Polygon.PolygonEditor(transposed,
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
      @geo.updateLatLngs(transposed)

  getFixedPolygon: () =>
    # prepares the new polygon in GeoJSON-ish format
    # (same format as was received from server)
    points = @geo.getPoints()
    # console.log "points:", points
    p_array = ([p.getLatLng().lng,p.getLatLng().lat] for p in points)
    coordinates = $.parseJSON(@currentPolygon.geometry)[0]
    if coordinates[0][0] == coordinates[coordinates.length-1][0] && coordinates[0][1] == coordinates[coordinates.length-1][1]
      # same coordinate for the first and last point / redundant
      coordinates.pop()
    # if there's no change return false to leave as is
    return false if p_array.join(",") == coordinates.join(",")
    return "[[" + ("[#{p.join(",")}]" for p in p_array) + "]]"

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
  window._p = new Polygonfix()
