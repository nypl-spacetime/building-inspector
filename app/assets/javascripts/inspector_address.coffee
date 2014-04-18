class Address extends Inspector

  constructor: (options) ->
    @flags = {}

    options =
      draggableMap: true
      tutorialType:"video"
      tutorialURL: "//player.vimeo.com/video/92360461?title=0&amp;byline=0&amp;portrait=0"
      jsdataID: '#addressjs'
      task: 'address'
    super(options)

  clearScreen: () =>
    @cleanFlags()
    super()

  addEventListeners: () =>
    super()
    @map.on('click', @onMapClick)

    inspector = @

    $("body").keyup (e)->
      # console.log "key", e.which
      switch e.which
        when 107, 187 then inspector.submitFlags(e)

  addButtonListeners: () =>
    super()
    inspector = @
    $("#submit-button").on "click", @submitFlags

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
    console.log "tutclick", e
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

  createFlag: (x, y, latlng, fake) ->
    @cleanEmptyFlags()
    circle = L.circleMarker(latlng,
      color: '#d75b25'
      fill: false
      opacity: 0.5
      radius: 28
      weight: 4
    ).addTo @map

    e = @buildNumberElement(x,y)
    @flags["x-#{x}-y-#{y}"] =
      elem: e
      circle: circle
      value: ""
      fake: fake
    e

  buildNumberElement: (x,y) =>
    inspector = @
    html = "<div id=\"num-x-#{x}-y-#{y}\" class=\"number-flag\"><div class=\"cont\"><input type=\"number\" class=\"input\" step=\"any\" placeholder=\"#\" /><a href=\"javascript:;\" class=\"num-close\">x</a></div></div>"
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

    max = 6
    elem = $(item)
    txt = elem.val()

    elem.blur() if charCode == 13 # ENTER

    # console.log charCode

    # non-number characters
    e.preventDefault() if (charCode != 46 && charCode != 190 && charCode != 110 && charCode > 31 && (charCode < 48 || charCode > 57) && (charCode > 105 || charCode < 96))

    # more than one period
    e.preventDefault() if txt.indexOf(".") > -1 && (charCode == 190 || charCode == 110)
    # console.log e

    # character limit
    e.preventDefault() if (e.which != 8 && txt.length >= max) || (e.which == 13)

    x = elem.attr("data-x")
    y = elem.attr("data-y")

    # console.log elem, x, y, txt
    @updateFlag x, y, txt

$ ->
  new Address()

