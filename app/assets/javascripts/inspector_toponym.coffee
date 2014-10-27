class Toponym extends Inspector

  constructor: (options) ->
    @flags = {}

    options =
      draggableMap: true
      constrainMapToPolygon: false
      tutorialType:"video"
      tutorialURL: "//player.vimeo.com/video/92360461?autoplay=1&title=0&amp;byline=0&amp;portrait=0"
      jsdataID: '#toponymjs'
      tweetString: "_score_ toponyms found! Data mining old maps with Building Inspector from @NYPLMaps @nypl_labs"
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
    bbox = @loadedData.map.bbox.split(",")
    delta_lon = Math.abs(Number(bbox[2]) - Number(bbox[0]))
    delta_lat = Math.abs(Number(bbox[3]) - Number(bbox[1]))
    random_lon = Math.random()*delta_lon+Number(bbox[0])
    random_lat = Math.random()*delta_lat+Number(bbox[1])
    @map.setView([random_lat, random_lon], 20) # TODO: support variable zoom

  clearScreen: () =>
    @hideSubmit()
    @cleanFlags()
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
    else
      # console.log "skipped"
      flag_str = "NONE=="

    @submitFlag(e, flag_str)

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

    elem = @createFlag(x, y, latlng)
    elem.css("top", y)
    elem.css("left", x)
    $("#map-container").append(elem)
    elem.find(".input").focus()
    @updateButton()

  updateScore: () ->
    for e, contents of @flags
      @allPolygonsSession++ if contents.value != ""
    super()

  updateButton: () ->
    @hideSubmit()
    $("#submit-button").text("SKIP")
    for e, contents of @flags
      $("#submit-button").text("SAVE")
      @showSubmit()
      break

  createFlag: (x, y, latlng, fake) ->
    @cleanEmptyFlags()
    circle = L.circleMarker(latlng,
      color: '#d75b25'
      fill: false
      opacity: 0.5
      radius: 28
      weight: 4
    ).addTo @map

    e = @buildTextElement(x,y)
    @flags["x-#{x}-y-#{y}"] =
      elem: e
      circle: circle
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

$ ->
  new Toponym()

