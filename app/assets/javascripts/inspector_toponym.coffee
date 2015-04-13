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
    @map.setView([random_lat, random_lon], 19)
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
    @cleanFlags() unless @options.tutorialOn
    super()

  addEventListeners: () =>
    super()
    @map.on('click', @onMapClick)

  addButtonListeners: () =>
    super()
    inspector = @
    $("#submit-button").on "click", @submitFlags

  removeButtonListeners: () ->
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
      @skipFlag(e)

  backgroundSubmitFlag: (item) =>
    obj = @flagObjectFromItem(item)

    return if !obj.flag

    @deleteFlag(null, obj.flag.flag_id) if obj.flag.flag_id && obj.flag.flag_id != 0

    obj.flag = @updateFlagObject(item, {isSaving:true, flag_id:0})
    @showFlagSpinner item
    data = @prepareFlag(obj.flag)
    @submitFlag(null, data, @onFlagSaved, item)

  onFlagSaved: (data, item) =>
    saved = false
    if data.flags
      saved = true
      newstatus = {
        changed: false
        saved: saved
        isSaving: false
        flag_id: data.flags[0].id
      }
    else
      newstatus = {
        changed: false
        saved: saved
        isSaving: false
        flag_id: 0
      }
    @updateFlagObject item, newstatus
    @hideFlagSpinner(item, saved)

  prepareData: () =>
    r = []
    for flag, contents of @flags
      submission = @prepareFlag(contents)
      r.push submission if submission != "" && !contents.saved && !contents.isSaving
    r

  prepareFlag: (contents) ->
    latlng = contents.circle.getLatLng()
    txt = contents.value
    if txt != "" && !contents.fake
      "#{txt}=#{latlng.lat}=#{latlng.lng}"
    else
      ""

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
    $("#submit-button").text("NEXT AREA")
    # count = 0
    # for e, contents of @flags
    #   count++ if !contents.saved && !contents.isSaving
    # $("#submit-button").text("NEXT AREA") if count > 0

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
      saved: false
      changed: true
      isSaving: false
      fake: fake
      flag_id: 0
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
    input.on 'click', (e) ->
      e.stopPropagation()
      window.scrollTo 0, 0

    setTimeout( ()->
      el.find(".cont").addClass("active")
      input.on "keyup", (e) ->
        inspector.validateInput(@, e)
      input.on "change", (e) ->
        inspector.setFlagChanged(@, e)
    , 50)
    return el

  setFlagChanged: (item, e) =>
    i = @
    setTimeout( ()->
      i.backgroundSubmitFlag(item)
    , 100)

  flagObjectFromItem: (item) ->
    input = $(item)
    x = input.attr("data-x")
    y = input.attr("data-y")
    elem = input.parentsUntil("#num-x-#{x}-y-#{y}")
    flag = @flags["x-#{x}-y-#{y}"]
    {elem:elem, flag:flag, input:input}

  destroyFlag: (item, fromDB = true) =>
    # console.log "destroying", item
    obj = @flagObjectFromItem(item)

    return if obj.flag.isSaving

    p = obj.elem

    if p.length > 0
      p.remove()
    else
      $(item).remove()

    @map.removeLayer obj.flag.circle if obj.flag.circle

    if fromDB && obj.flag.flag_id && obj.flag.flag_id != 0
      @deleteFlag(null, obj.flag.flag_id)

    x = obj.input.attr("data-x")
    y = obj.input.attr("data-y")

    delete @flags["x-#{x}-y-#{y}"]

    @updateButton()

  updateFlagObject: (item, updates) =>
    elem = $(item)
    x = elem.attr("data-x")
    y = elem.attr("data-y")
    for key, val of updates
      @flags["x-#{x}-y-#{y}"][key] = val
    @flags["x-#{x}-y-#{y}"]

  cleanFlags: () =>
    for flag, contents of @flags
      # console.log "destroyed", contents.elem[0]
      @destroyFlag("#num-" + flag + " .num-close", false)

  showFlagSpinner: (item) ->
    obj = @flagObjectFromItem(item)
    spinnerOpts =
      left: "10px"
      top: "10px"
      radius: 4
      speed: 2
      lines: 8
      className: "spinner-mini"
    @hideFlagSpinner(item)
    close = obj.elem.find(".num-close")
    close.addClass("saving")
    close.prepend(Utils.spinner(spinnerOpts).el)

  hideFlagSpinner: (item, saved = true) ->
    obj = @flagObjectFromItem(item)
    close = obj.elem.find(".num-close")
    close.removeClass("saving")
    if saved
      close.addClass("saved")
    else
      close.removeClass("saved")
    close.find(".spinner-mini").remove()

  cleanEmptyFlags: () =>
    for flag, contents of @flags
      @destroyFlag("#num-" + flag + " .num-close") if contents.value == ""

  validateInput: (item, e) =>
    charCode = if e.which then e.which else e.keyCode

    max = 256 # maximum for varchar fields
    elem = $(item)
    txt = $.trim(elem.val())

    elem.blur() if charCode == 13 || charCode == 27 # ENTER / Esc

    # console.log charCode

    # character limit
    e.preventDefault() if (e.which != 8 && txt.length >= max) || (e.which == 13)

    # console.log elem, x, y, txt
    @updateFlagObject item, {value:txt}
    @updateScore()

$ ->
  new Toponym()

