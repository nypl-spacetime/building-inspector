class Address extends Inspector

  constructor: () ->
    @flags = {}

    tutorialData =
      poly: {"bbox":"","created_at":"2013-08-28T21:52:04Z","id":2,"map_id":0,"map_url":null,"poly":[{"color":"8","dn":1058779,"geometry":"[[[-73.9917489385617,40.73160355632643],[-73.99176508603846,40.7315894272398],[-73.9917785422691,40.73159295951173],[-73.99200729818992,40.7316883307832],[-73.99201268068218,40.73169539531639],[-73.99197500323639,40.73173778249977],[-73.99172471734657,40.73163534676037],[-73.9917489385617,40.73160355632643]]]","id":1488,"sheet_id":2,"status":"unprocessed"},{"color":"8","dn":1065840,"geometry":"[[[-73.99285440448465,40.73320584082565],[-73.99291608447433,40.733232825247896],[-73.99291450293613,40.7332390524207],[-73.99289077986317,40.733245279592936],[-73.99286863832842,40.73327849116829],[-73.99278956141856,40.73326603682947],[-73.99283226294989,40.73320168937511],[-73.99284017064087,40.733199613649745],[-73.99285440448465,40.73320584082565]]]","id":2101,"sheet_id":2,"status":"unprocessed"},{"color":"8","dn":1065840,"geometry":"[[[-73.99219510816457,40.73254771536549],[-73.99224570315576,40.73256835946708],[-73.99214451317339,40.7327010713958],[-73.992082242415,40.732674529031236],[-73.99217954047498,40.73254476620759],[-73.99218343239738,40.73254181704957],[-73.99219510816457,40.73254771536549]]]","id":2101,"sheet_id":2,"status":"unprocessed"},{"color":"3","dn":111187,"geometry":"[[[-73.991333336943,40.73301062882454],[-73.99147411122182,40.73303372418245],[-73.99147851041803,40.73305104569565],[-73.9914653128294,40.73309146254221],[-73.99129374417709,40.733062593368594],[-73.99130694176571,40.73300485498379],[-73.991333336943,40.73301062882454]]]","id":69407,"sheet_id":2,"status":"unprocessed"},{"color":"1","dn":1061017,"geometry":"[[[-73.99204496531397,40.733898502139596],[-73.9920540120468,40.733886628675144],[-73.99213724198881,40.733919874370265],[-73.99213905133539,40.73393174782879],[-73.9921064830972,40.73397449226191],[-73.9920847709384,40.73397449226191],[-73.99200696903611,40.733957869430064],[-73.99200515968954,40.73395074535801],[-73.99204496531397,40.733898502139596]]]","id":1984,"sheet_id":2,"status":"unprocessed"},{"color":"8","dn":1084906,"geometry":"[[[-73.99260271561742,40.733666621617616],[-73.99264410318662,40.73367341157545],[-73.99265445007892,40.73368699148904],[-73.99278895967879,40.733741311115665],[-73.99279154640186,40.73375149604072],[-73.99275015883266,40.733799025670365],[-73.992553567879,40.73371754628447],[-73.99257684838668,40.73367341157545],[-73.99258978200206,40.73366322663844],[-73.99260271561742,40.733666621617616]]]","id":69495,"sheet_id":2,"status":"unprocessed"},{"color":"8","dn":1084908,"geometry":"[[[-73.99467876998335,40.714962098308405],[-73.99481423128013,40.71500225525319],[-73.99478364324537,40.71505962227514],[-73.99463070307159,40.71501372866153],[-73.9946569213871,40.71495636160003],[-73.99467876998335,40.714962098308405]]]","id":2018,"sheet_id":2,"status":"unprocessed"},{"color":"12","dn":1095137,"geometry":"[[[-73.9914326318635,40.732605885457374],[-73.99164216035788,40.73269365226407],[-73.99165107646402,40.73273461006758],[-73.99164661841095,40.73274631229252],[-73.99153516708415,40.7326995033804],[-73.99150841876573,40.73268195002986],[-73.99149058655344,40.73268195002986],[-73.99139250938585,40.73264099219395],[-73.991401425492,40.73259418320773],[-73.9914326318635,40.732605885457374]]]","id":69655,"sheet_id":2,"status":"unprocessed"},{"color":"12","dn":1095137,"geometry":"[[[-73.99631771565119,40.738981722245896],[-73.9963831008286,40.73900779683433],[-73.99631771565119,40.73909905781334],[-73.99624544782354,40.73906776834893],[-73.99630739167581,40.738981722245896],[-73.99631771565119,40.738981722245896]]]","id":69655,"sheet_id":2,"status":"unprocessed"},{"color":"1","dn":1123405,"geometry":"[[[-73.99137871882681,40.73271012952303],[-73.99144820633073,40.73271979836216],[-73.9914399003793,40.73275058464772],[-73.99136756952616,40.732740159964955],[-73.99137375971172,40.73270948736736],[-73.99137871882681,40.73271012952303]]]","id":69530,"sheet_id":2,"status":"unprocessed"},{"color":"3","dn":1123406,"geometry":"[[[-73.99150976731543,40.732235259397115],[-73.9915611428715,40.732235259397115],[-73.99158040870505,40.73224368814436],[-73.99163178426112,40.73224368814436],[-73.99165105009465,40.73225211689052],[-73.9916895817617,40.73225211689052],[-73.99170884759523,40.73226054563564],[-73.99176022315132,40.73226054563564],[-73.99177948898485,40.73226897437967],[-73.99180517676288,40.73226897437967],[-73.99181159870739,40.732277403122644],[-73.99179875481836,40.73232797555806],[-73.99183728648545,40.73234483302798],[-73.99185013037444,40.73234483302798],[-73.99184370842994,40.732420691589795],[-73.99185013037444,40.73242912031355],[-73.9918886620415,40.73244597775785],[-73.99180517676288,40.73255555104169],[-73.99174737926229,40.73253026491528],[-73.99172811342875,40.73253869362516],[-73.99147765759288,40.73242912031355],[-73.99146481370386,40.73242912031355],[-73.99143912592584,40.73241226286497],[-73.99147765759288,40.73226054563564],[-73.99147765759288,40.7322268306488],[-73.99150976731543,40.732235259397115]]]","id":69712,"sheet_id":2,"status":"unprocessed"},{"color":"3","dn":1123406,"geometry":"[[[-73.9946878320301,40.71491928210032],[-73.9948462711411,40.71496778046124],[-73.99483103661119,40.71500011268223],[-73.99466345678226,40.71495161434486],[-73.9946725975002,40.714923900993355],[-73.99467869131216,40.714916972653675],[-73.9946878320301,40.71491928210032]]]","id":69712,"sheet_id":2,"status":"unprocessed"},{"color":"3","dn":1123406,"geometry":"[[[-73.99092398657614,40.73119895065988],[-73.99093727994169,40.73119197157895],[-73.99099311207691,40.731216398359],[-73.99095854932654,40.73126176235532],[-73.99089739984507,40.731237335591906],[-73.99092398657614,40.73119895065988]]]","id":69712,"sheet_id":2,"status":"unprocessed"},],"status":"unprocessed","updated_at":"2013-08-28T21:52:04Z"}
      steps: [
        {
          element: "#map-highlight"
          intro: "<strong>Here's how this task works</strong><br />We'll show you one computer-generated building outline at a time, laid over the original map."
          position: "bottom"
          polygon_index: -1
        }
        {
          element: "#submit-button"
          intro: "Along with this button. Let's walk through a few examples…"
          position: "top"
          polygon_index: -1
          ixactive: true
        }
        {
          element: "#map-highlight"
          intro: "The address number of this building is 781. Click there and type 781."
          position: "right"
          polygon_index: -1
        }
        {
          element: "#submit-button"
          intro: "Press next to save it and go to the next building."
          position: "top"
          polygon_index: -1
          ixactive: true
        }
        {
          element: "#map-highlight"
          intro: "62 or 29? Look around! (remind of even/odd addressing system)"
          position: "right"
          polygon_index: 0
        }
        {
          element: "#submit-button"
          intro: "press."
          position: "top"
          polygon_index: 0
          ixactive: true
        }
        {
          element: "#map-highlight"
          intro: "1s may be confused for 4s and vice-versa. look around"
          position: "right"
          polygon_index: 1
        }
        {
          element: "#submit-button"
          intro: "Be vigilant!"
          position: "top"
          polygon_index: 1
          ixactive: true
        }
        {
          element: "#map-highlight"
          intro: "3s and 8s are another source of confusion."
          position: "right"
          polygon_index: 2
        }
        {
          element: "#submit-button"
          intro: "Press FIX to indicate so."
          position: "top"
          polygon_index: 2
          ixactive: true
        }
        {
          element: "#map-highlight"
          intro: "this building is part of the 33 address."
          position: "right"
          polygon_index: 3
        }
        {
          element: "#submit-button"
          intro: "This one's good enough. Press YES and keep going."
          position: "top"
          polygon_index: 3
          ixactive: true
        }
        {
          element: "#map-highlight"
          intro: "Some buildings have no address number."
          position: "right"
          polygon_index: 4
        }
        {
          element: "#submit-button"
          intro: "Now you can approve it."
          position: "top"
          polygon_index: 4
          ixactive: true
        }
        {
          element: "#map-highlight"
          intro: "don't be fooled by numbers inside buildings! this is a lucky 13."
          position: "right"
          polygon_index: 5
        }
        {
          element: "#submit-button"
          intro: "Those are FIXes."
          position: "top"
          polygon_index: 5
          ixactive: true
        }
        {
          element: "#map-highlight"
          intro: "some have more than one number. type em all!"
          position: "right"
          polygon_index: 6
        }
        {
          element: "#submit-button"
          intro: "That's a FIXer."
          position: "top"
          polygon_index: 6
          ixactive: true
        }
        {
          element: "#map-highlight"
          intro: "hand drawn maps go through corrections. we want both numbers [mga note: do we?]"
          position: "right"
          polygon_index: 7
        }
        {
          element: "#submit-button"
          intro: "Teach that computer a lesson!"
          position: "top"
          polygon_index: 7
          ixactive: true
        }
        {
          element: "#map-highlight"
          intro: "extra complicated... type fractions as .5 in this case 805.5"
          position: "right"
          polygon_index: 8
        }
        {
          element: "#submit-button"
          intro: "Laugh at the poor computer and move on."
          position: "top"
          polygon_index: 8
          ixactive: true
        }
        {
          element: "#map-highlight"
          intro: "i wants moar numberz!"
          position: "right"
          polygon_index: 9
        }
        {
          element: "#submit-button"
          intro: "Laugh at the poor computer and move on."
          position: "top"
          polygon_index: 9
          ixactive: true
        }
        {
          element: "#map-highlight"
          intro: "some numbers are shared by more than one building. this 11 would be typed in both."
          position: "right"
          polygon_index: 10
        }
        {
          element: "#submit-button"
          intro: "Laugh at the poor computer and move on."
          position: "top"
          polygon_index: 10
          ixactive: true
        }
        {
          element: "#map-highlight"
          intro: "this must be part of the 68 bottom-right (note wall 'entrance' connecting)"
          position: "right"
          polygon_index: 11
        }
        {
          element: "#submit-button"
          intro: "That's a YES!"
          position: "top"
          polygon_index: 11
          ixactive: true
        }
        {
          element: "#link-help"
          intro: "<strong>Now you're ready to begin checking buildings!</strong><br />You can always refer to this tutorial again by hitting the HELP button.<br />Have fun! And thanks for helping The New York Public Library."
          position: "left"
          polygon_index: 11
        }
      ]
    options =
      draggableMap: true
      tutorialData: tutorialData
      jsdataID: '#addressjs'
      task: 'address'
    super(options)

  clearScreen: () =>
    @cleanFlags()
    super()

  addEventListeners: () =>
    super()
    @map.on('click', @onMapClick)
    @map.on('move', @onMapChange)

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
      flag_str = ",,NONE"

    @submitMultipleFlags(e, flag_str)

  prepareData: () =>
    r = []
    for flag, contents of @flags
      latlng = contents.circle.getLatLng()
      txt = contents.value
      r.push "#{latlng.lat},#{latlng.lng},#{txt}" if txt != "" && !contents.fake
    r

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

  onTutorialClick: (e) =>
    # console.log "tutclick", e
    e.stopPropagation?()
    e.preventDefault?()

    x = e.offsetX
    y = e.offsetY
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

    console.log "num-x-#{x}-y-#{y}"

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

