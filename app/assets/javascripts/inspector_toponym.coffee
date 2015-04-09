class Toponym extends Inspector

  constructor: (options) ->
    @flags = {}

    options =
      flaggableType: 'Sheet'
      draggableMap: true
      hasMiniMap: true
      constrainMapToPolygon: false
      tutorialType:"simple"
      tutorialURL: "//player.vimeo.com/video/123878608?autoplay=1&title=0&amp;byline=0&amp;portrait=0"
      jsdataID: '#toponymjs'
      tweetString: "_score_ toponyms found! Data mining old maps with Building Inspector from @NYPLMaps @nypl_labs"
      overlayHTML: '<div class="overlay">Find all the place names<br />(minus the streets)<br />in the area.<br /><strong>Zoom to begin.</strong></div>'
      task: 'toponym'
    @updateButton()
    super(options)

  showNextPolygon: () ->
    # OVERRIDES ORIGINAL TO NOT SHOW POLYGONS
    @clearScreen()
    @resetButtons()
    @updateButton()

    $(@options.buttonsID).show()

    # does not show polygon / gets random point from sheet bounds
    return if @options.tutorialOn

    @getPolygons()

  processPolygons: (data) ->
    # overrides original since we want to avoid redundant call to showNextPolygon()
    @allPolygonsSession = 0
    $(@options.loaderID).remove()
    @loadedData = data
    if @loadedData.tileset.tilejson != @tileset
      @tileset = @loadedData.tileset.tilejson
      @updateTileset()
    @updateScore()
    @showInspectingMessage()
    bbox = (parseFloat(c) for c in @loadedData.map.bbox.split(","))
    delta_lon = Math.abs(bbox[2] - bbox[0])
    delta_lat = Math.abs(bbox[3] - bbox[1])
    random_lon = Math.random()*delta_lon+bbox[0]
    random_lat = Math.random()*delta_lat+bbox[1]
    # constrain the map to the current sheet
    @bounds = Utils.bboxToBounds(bbox)
    @map.setMaxBounds(@bounds)
    @map.setView([random_lat, random_lon], 16)
    @fogOfWar(bbox)
    @showCurrentToponyms()

  showCurrentToponyms: () ->
    @map.removeLayer(@my_topos) if @my_topos
    return if @loadedData.toponyms.features.length == 0
    @my_topos = L.geoJson(@loadedData.toponyms,
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
        l.bindPopup(f.properties.flag_value,
          className: 'toponym-popup'
        )
    )
    @my_topos.addTo(@map)

  clearScreen: () =>
    @hideSubmit()
    @cleanFlags() unless @options.tutorialOn
    super()

  hideSubmit: () ->
    $("#submit-button").hide()

  showSubmit: () ->
    $("#submit-button").show()

  addEventListeners: () =>
    super()
    @map.on('click', @onMapClick)

  addButtonListeners: () =>
    super()
    inspector = @
    $("#submit-button").on "click", @submitFlags

    # $("body").keyup (e)->
    #   # console.log "key", e.which
    #   charCode = if e.which then e.which else e.keyCode
    #   switch charCode
    #     # when 83 then inspector.submitFlags(e) # s key
    #     when 13 then inspector.updateButton() # ENTER key

  removeButtonListeners: () =>
    super()
    $("#submit-button").unbind()

  resetButtons: () ->
    super()
    $("#submit-button").removeClass("active inactive")

  activateButton: (button) =>
    $("#submit-button").addClass("inactive") if button != "submit"
    $("#submit-button").addClass("active") if button == "submit"

  submitFlags: (e) =>
    @activateButton("submit") unless @options.tutorialOn

    flag_data = @prepareData()

    if flag_data.length > 0
      flag_str = flag_data.join("|")
      @submitFlag(e, flag_str)
    else
      # console.log "skipped"
      @skipFlag(e)


  prepareData: () =>
    r = []
    for flag, contents of @flags
      latlng = contents.circle.getLatLng()
      txt = contents.value
      r.push "#{txt}=#{latlng.lat}=#{latlng.lng}" if txt != "" && !contents.fake
    r

  onTutorialClick: (e) =>
    # console.log "tutclick", e
    e.stopPropagation?()
    e.preventDefault?()

    x = e.offsetX ? e.originalEvent.layerX
    y = e.offsetY ? e.originalEvent.layerY
    latlng = @.map.mouseEventToLatLng(e)

    elem = @createFlag(x, y, latlng, true)
    elem.css("top", y)
    elem.css("left", x)
    $("#map-highlight").append(elem)
    elem.find(".input").focus()

  onMapClick: (e) =>
    # console.log "mapclick", e
    e.stopPropagation?()
    e.preventDefault?()

    latlng = e.latlng
    x = e.containerPoint.x
    y = e.containerPoint.y

    return if !@bounds.contains(latlng)

    elem = @createFlag(x, y, latlng)
    elem.css("top", y)
    elem.css("left", x)
    $("#map-container").append(elem)
    elem.find(".input").focus()
    @updateScore()
    @updateButton()

  updateScore: () ->
    @allPolygonsSession = @loadedData.status.all_polygons_session
    for e, contents of @flags
      @allPolygonsSession++ if contents.value != ""
    super()

  updateButton: () ->
    @hideSubmit()
    $("#submit-button").text("SKIP")
    count = 0
    for e, contents of @flags
      count++
    $("#submit-button").text("SAVE (" + count + ")") if count > 0
    @showSubmit()

  createFlag: (x, y, latlng, fake) ->
    @cleanEmptyFlags()

    flagIcon = L.icon(
      iconUrl: '/assets/toponym/toponymmarker.png'
      iconSize: [30, 84]
      iconAnchor: [8, 77]
    )

    flag = L.marker(latlng,
      icon: flagIcon
      # color: '#d75b25'
      # fill: false
      # opacity: 0.5
      # radius: 28
      # weight: 4
    )

    m = @map

    flag.on 'add', ()->
      m.panTo(latlng, m.getZoom())

    flag.addTo @map

    e = @buildTextElement(x,y)
    @flags["x-#{x}-y-#{y}"] =
      elem: e
      circle: flag
      value: ""
      fake: fake
    e

  buildTextElement: (x,y) =>
    inspector = @
    html = "<div id=\"num-x-#{x}-y-#{y}\" class=\"toponym-flag\"><div class=\"cont\"><input class=\"input\" placeholder=\"name of place\" /><a href=\"javascript:;\" class=\"num-close\">x</a></div></div>"
    el = $(html)

    # console.log "num-x-#{x}-y-#{y}"

    input = el.find(".input")
    close = el.find(".num-close")
    close.on "click", (e) ->
      e.stopPropagation()
      inspector.destroyFlag(this)

    # add data attributes to facilitate flag remove/update
    el.attr("data-x", x)
    el.attr("data-y", y)
    close.attr("data-x", x)
    close.attr("data-y", y)
    input.attr("data-x", x)
    input.attr("data-y", y)

    # to fix window resize in iOS
    input.on 'blur click', (e) ->
      e.stopPropagation()
      window.scrollTo 0, 0

    setTimeout( ()->
      el.find(".cont").addClass("active")
      input.on "keyup", (e) ->
          inspector.validateInput(@, e)
      input.on "keydown", (e) ->
        switch e.which
          when 27 then inspector.destroyFromEscape(@)
          else inspector.validateInput(@, e)
    , 50
    )
    return el

  destroyFromEscape: (item) =>
    @destroyFlag(item)
    for e, contents of @flags
      @flags[e].elem.find(".input").focus()
      break

  destroyFlag: (item) =>
    # console.log "destroying", item
    elem = $(item)
    x = elem.attr("data-x")
    y = elem.attr("data-y")
    p = elem.parentsUntil("#num-x-#{x}-y-#{y}")
    if p.length > 0
      p.remove()
    else
      elem.remove()
    flag = @flags["x-#{x}-y-#{y}"]
    @map.removeLayer flag.circle if flag.circle
    delete @flags["x-#{x}-y-#{y}"]
    @updateButton()

  updateFlag: (x, y, value) =>
    @flags["x-#{x}-y-#{y}"].value = value

  cleanFlags: () =>
    for flag, contents of @flags
      # console.log "destroyed", contents.elem[0]
      @destroyFlag("#num-" + flag + " .num-close")

  cleanEmptyFlags: () =>
    for flag, contents of @flags
      @destroyFlag("#num-" + flag + " .num-close") if contents.value == ""

  validateInput: (item, e) =>
    charCode = if e.which then e.which else e.keyCode

    max = 256 # maximum for varchar fields
    elem = $(item)
    txt = $.trim(elem.val())

    elem.blur() if charCode == 13 # ENTER

    # console.log charCode

    # character limit
    e.preventDefault() if (e.which != 8 && txt.length >= max) || (e.which == 13)

    x = elem.attr("data-x")
    y = elem.attr("data-y")

    # console.log elem, x, y, txt
    @updateFlag x, y, txt
    @updateScore()

$ ->
  new Toponym()

