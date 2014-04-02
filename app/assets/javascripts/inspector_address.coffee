class Address extends Inspector

  constructor: (options) ->
    @flags = {}

    options =
      draggableMap: true
      tutorialData: options.tutorialData
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
  tutorialData =
    poly: {"bbox":"","poly":[{"geometry":"[[[-74.00443036960525,40.728929503132896],[-74.00447889872316,40.72902151016576],[-74.00442138273158,40.72904038338754],[-74.00437285361366,40.72895781300271],[-74.00436746148945,40.72894129891345],[-74.0044231801063,40.72892478482009],[-74.00443036960525,40.728929503132896]]]"},{"geometry":"[[[-74.00632054628083,40.729244503864464],[-74.0063868124038,40.72925242169528],[-74.00637023082675,40.72934979300548],[-74.0062985869315,40.7293433602966],[-74.00631364767415,40.72924697137612],[-74.00632054628083,40.729244503864464]]]"},{"geometry":"[[[-73.99126676982706,40.72514240535678],[-73.99130456630446,40.72515750491636],[-73.99130949627978,40.725168290313974],[-73.99126019652664,40.725237316817264],[-73.991202680148,40.72521358896483],[-73.99125362322623,40.72513809119627],[-73.99126676982706,40.72514240535678]]]"},{"geometry":"[[[-73.99110412431018,40.72698144981176],[-73.99113059795648,40.726994814879646],[-73.99109903322434,40.727044265607496],[-73.99106135918926,40.7270295640436],[-73.9910949603557,40.72698011330482],[-73.99110412431018,40.72698144981176]]]"},{"geometry":"[[[-73.99169157607754,40.7238133220003],[-73.99173566836136,40.72382668836745],[-73.99169451556313,40.723909114239056],[-73.9916269073946,40.723891292437635],[-73.99167099967842,40.72380886654396],[-73.99169157607754,40.7238133220003]]]"},{"geometry":"[[[-73.98847531317188,40.72467460030692],[-73.98848665962177,40.724659706493796],[-73.9885547383211,40.72468949411671],[-73.98851097344294,40.724751197007464],[-73.98844289474364,40.724721409412176],[-73.98847531317188,40.72467460030692]]]"},{"geometry":"[[[-73.99147807490841,40.724257022749065],[-73.9915579243347,40.72427980845411],[-73.9915579243347,40.72428892273395],[-73.99151279205027,40.72434816552244],[-73.99152667890702,40.72436639406214],[-73.99154750919213,40.72437550833011],[-73.99154750919213,40.724384622596844],[-73.99148154662261,40.724471208068515],[-73.99134614976933,40.72441196538954],[-73.99146071633749,40.72425246560712],[-73.99147807490841,40.724257022749065]]]"},{"geometry":"[[[-73.99176403374837,40.72536121354434],[-73.99177424962504,40.72535450872564],[-73.99189939411416,40.72539138522015],[-73.99186363854584,40.72549195737404],[-73.99171806230339,40.72542826169422],[-73.99176403374837,40.72536121354434]]]"},{"geometry":"[[[-74.00812265597645,40.70767820394839],[-74.00815898266991,40.707703886442694],[-74.00816177703095,40.70772223107541],[-74.00803603078438,40.707857981200476],[-74.00801647025715,40.707861650118936],[-74.00796617175853,40.70779560955577],[-74.00810588981025,40.707670866091064],[-74.00812265597645,40.70767820394839]]]"},{"geometry":"[[[-74.00821908346735,40.70481381445221],[-74.0083095173874,40.704891255270574],[-74.00838029175964,40.70496353328645],[-74.00841567894574,40.704989346844556],[-74.00843140658402,40.70500999768383],[-74.00844320231272,40.70501516039265],[-74.00843533849358,40.70502548580908],[-74.00835276839265,40.705071950163216],[-74.00823481110562,40.70496869599888],[-74.00821908346735,40.7049480451468],[-74.00813651336641,40.70488092983333],[-74.00811685381858,40.70485511623321],[-74.00814044527598,40.70484479079036],[-74.00814830909512,40.70483446534591],[-74.00820728773864,40.70479832627773],[-74.00821908346735,40.70481381445221]]]"},{"geometry":"[[[-74.00618771892398,40.70482371178674],[-74.00619487276296,40.70482371178674],[-74.00626998807223,40.7048753744777],[-74.00629502650865,40.70488007108398],[-74.00647387248311,40.704757959213],[-74.00649175708057,40.70476265582758],[-74.00652037243648,40.7047814422825],[-74.00652037243648,40.70479083550799],[-74.0063522572205,40.7048988575058],[-74.00634152646202,40.70492234052561],[-74.00647387248311,40.705011575925425],[-74.00646671864415,40.70502096911844],[-74.00643452636874,40.70504445209521],[-74.00623064195787,40.704908250714716],[-74.00620560352144,40.70488476768995],[-74.0061555266486,40.70485658804926],[-74.00618771892398,40.70482371178674]]]"},{"geometry":"[[[-74.00219162385866,40.71929818048351],[-74.00252258374226,40.719471966853504],[-74.00243275177385,40.71958989306045],[-74.00242329577718,40.71958989306045],[-74.00237128779547,40.71954644658746],[-74.00231927981378,40.719515413375106],[-74.00230982381709,40.71950300008611],[-74.00214907187363,40.719391280381004],[-74.00213961587696,40.719378867068855],[-74.0021065198886,40.719360247096304],[-74.00217271186533,40.71928576715401],[-74.00219162385866,40.71929818048351]]]"},{"geometry":"[[[-73.97590471455366,40.71528402198538],[-73.97594952922393,40.71529873044814],[-73.97595139650186,40.71530608467831],[-73.9759009799978,40.71540168959653],[-73.97583562527034,40.71538452974952],[-73.97588417449646,40.71529137621715],[-73.97589164360816,40.71528157057459],[-73.97590471455366,40.71528402198538]]]"},{"geometry":"[[[-74.00619742326523,40.717677905199274],[-74.00625701520751,40.71770235239139],[-74.00618811202426,40.7177879174931],[-74.0061210710892,40.71775858089918],[-74.00618624977606,40.717673015759765],[-74.00619742326523,40.717677905199274]]]"},{"geometry":"[[[-74.00412548526997,40.73149241447002],[-74.0041426883032,40.731521014641366],[-74.00414039456544,40.731527035728504],[-74.00406470121919,40.73154208844397],[-74.00405208566148,40.7315195093695],[-74.00405667313701,40.731510477737565],[-74.00412548526997,40.73149241447002]]]"},{"geometry":"[[[-73.99112701488116,40.72497202952946],[-73.99115080960904,40.72494079573442],[-73.99119839906483,40.72497549995024],[-73.991162706973,40.725025821031025],[-73.99111379558788,40.72499285205135],[-73.99112701488116,40.72497202952946]]]"},{"geometry":"[[[-73.98931674801268,40.7241899586374],[-73.9893529996838,40.72420999474554],[-73.98933391985689,40.72424505792026],[-73.98929194423769,40.72422251731006],[-73.9893110240646,40.724187454123474],[-73.98931674801268,40.7241899586374]]]"},{"geometry":"[[[-74.00492712528327,40.72919990884415],[-74.00494689719622,40.72919471851354],[-74.00497194161929,40.72924489169255],[-74.00491262588045,40.72926392288849],[-74.0048849452023,40.729213749723826],[-74.00492712528327,40.72919990884415]]]"},{"geometry":"[[[-74.00551316726514,40.72078175807435],[-74.00557526602503,40.72080504896306],[-74.00556935185742,40.72085939433834],[-74.00547324663376,40.72082251712423],[-74.00549986038801,40.72077981716659],[-74.00551316726514,40.72078175807435]]]"},{"geometry":"[[[-74.00534716745057,40.72462163359345],[-74.00551556758093,40.72463764796918],[-74.00550918647303,40.72467151318371],[-74.00534503874032,40.724656419302974],[-74.00534016947034,40.72465401301631],[-74.00534716745057,40.72462163359345]]]"},{"geometry":"[[[-74.00682084968801,40.71779799095398],[-74.00682576125232,40.717804438738746],[-74.00680938937133,40.71782163282841],[-74.00681266374752,40.71783882691363],[-74.00685195626188,40.7178603195139],[-74.00679629186654,40.71792909578819],[-74.00677991998556,40.71792909578819],[-74.00674881341169,40.71791405098426],[-74.00677664560936,40.717877513589144],[-74.00677337123317,40.7178603195139],[-74.00676354810457,40.71785602099442],[-74.00681266374752,40.71779584169226],[-74.00682084968801,40.71779799095398]]]"},{"geometry":"[[[-74.00650644327723,40.71938573920328],[-74.00656691925245,40.71941394052644],[-74.00655050626136,40.71944258277265],[-74.0064758345952,40.71940851402256],[-74.00649509864995,40.7193805030224],[-74.00650644327723,40.71938573920328]]]"},{"geometry":"[[[-74.00494266339545,40.72900178775542],[-74.00495577516642,40.72900022321681],[-74.00499153454177,40.72906906288125],[-74.00494147141627,40.72906593380714],[-74.004912863916,40.729012739524734],[-74.00494266339545,40.72900178775542]]]"},{"geometry":"[[[-74.00451479901618,40.7208065775638],[-74.00452869118801,40.720794972524104],[-74.00455773845641,40.72082647191285],[-74.00450974731734,40.72087289203753],[-74.00446680787712,40.720852997702345],[-74.00451479901618,40.7208065775638]]]"},{"geometry":"[[[-74.005708158738,40.7233845151023],[-74.00575078302717,40.72338892677306],[-74.00574510202344,40.723425157731384],[-74.00570044305219,40.723419969956815],[-74.005708158738,40.7233845151023]]]"},{"geometry":"[[[-74.00722043635047,40.73344138325038],[-74.00724730730501,40.73344002182614],[-74.00724095310422,40.73346366392232],[-74.00715052501583,40.73347632489106],[-74.00713807925527,40.733474876666214],[-74.00713721366252,40.7334511584392],[-74.00722043635047,40.73344138325038]]]"},{"geometry":"[[[-74.00530706320986,40.71938167569063],[-74.00534970983591,40.719402301425816],[-74.0053429761581,40.71941114102464],[-74.00535195439517,40.7194288202188],[-74.00540582381757,40.71945828553194],[-74.0053766445471,40.719496590419546],[-74.00536542175077,40.71949953694845],[-74.00522625907627,40.71943471328247],[-74.00528012849865,40.71936988955336],[-74.00530706320986,40.71938167569063]]]"},{"geometry":"[[[-74.00715793854066,40.7242064455755],[-74.00737591326454,40.724227326336326],[-74.0073746615915,40.72425326212984],[-74.0071275375683,40.724231264673534],[-74.00712224385829,40.724225265898035],[-74.0071257793366,40.72420532887145],[-74.00715793854066,40.7242064455755]]]"},{"geometry":"[[[-74.00460659090398,40.720561429777604],[-74.00461688061118,40.72056953429076],[-74.00452015736343,40.72069650486802],[-74.00450986765622,40.72069920636704],[-74.00445224529587,40.720672191371975],[-74.00445224529587,40.72066138537088],[-74.00450369383191,40.7205938478243],[-74.00450986765622,40.72059114632101],[-74.00453044707065,40.72060195233351],[-74.00455514236795,40.720596549327475],[-74.00456954795801,40.72057763880292],[-74.00459218531388,40.72056953429076],[-74.00460041707966,40.720558728273],[-74.00460659090398,40.720561429777604]]]"},{"geometry":"[[[-74.00762431167237,40.722307801073875],[-74.00771246070197,40.72231581784388],[-74.00769483089604,40.722404002250194],[-74.0075961039829,40.72239331323747],[-74.00761373378883,40.722305128816984],[-74.00762431167237,40.722307801073875]]]"}]}
    steps: [
      {
        element: "#map-highlight"
        intro: "Generally speaking, it's really easy to match most buildings with their street numbers. Click on the address number next to highlighted structure and type it into the text box that pops up."
        position: "right"
        polygon_index: -1
      }
      {
        element: "#submit-button"
        intro: " Hit the \"Next/Skip\" button to submit your entry (or to skip to the next one if you can't figure it out)."
        position: "top"
        polygon_index: -1
        ixactive: true
      }
      {
        element: "#map-highlight"
        intro: "Seems easy right? Well this one is anyway - mark it 20. But we'll take you through a few more examples so you can see some harder \"edge cases\" as well. "
        position: "right"
        polygon_index: 0
      }
      {
        element: "#submit-button"
        intro: "Okay smart guy. Hit next and we'll get to some tough ones!"
        position: "top"
        polygon_index: 0
      }
      {
        element: "#map-highlight"
        intro: "It can be easy to be fooled by those olde tyme numbers. 47 or 17? If you can't tell, look to addresses around it. It's near the 20s, so it must be ye olde 17. Click-eth it and type-eth it in. "
        position: "right"
        polygon_index: 1
      }
      {
        element: "#submit-button"
        intro: "Hit next to save it and move on. "
        position: "top"
        polygon_index: 1
        ixactive: true
      }
      {
        element: "#map-highlight"
        intro: "If an address includes a fraction, decimalize it! Turn that 1/2 into a \".5.\" This would be 395.5 "
        position: "right"
        polygon_index: 2
      }
      {
        element: "#submit-button"
        intro: "Boom! Hit next to save and continue!"
        position: "top"
        polygon_index: 2
        ixactive: true
      }
      {
        element: "#map-highlight"
        intro: "Times change and so do addresses. When you see new numbers written in under the old ones, enter both!  They were both right at some point and it's all info we can use."
        position: "right"
        polygon_index: 3
      }
      {
        element: "#submit-button"
        intro: "Next!"
        position: "top"
        polygon_index: 3
        ixactive: true
      }
      {
        element: "#map-highlight"
        intro: "But, what if there is no number at all? Well that's just a headache so we won't even bother with these. "
        position: "right"
        polygon_index: 4
      }
      {
        element: "#submit-button"
        intro: "Skip it like a jump rope!"
        position: "top"
        polygon_index: 4
        ixactive: true
      }
      {
        element: "#map-highlight"
        intro: "A house divided cannot stand? Abe Lincoln should have spent more time in New York. While this proved to be an apt metaphor for our nation torn asunder, large structures were actually frequently divided on the inside and were given more than one address (without collapsing as a result). Give us both numbers. <br /> They could be on the same street, like this one..."
        position: "right"
        polygon_index: 5
      }
      {
        element: "#submit-button"
        intro: "Hit next to save 'em."
        position: "top"
        polygon_index: 5
        ixactive: true
      }
      {
        element: "#map-highlight"
        intro: "On corner buildings on two streets..."
        position: "right"
        polygon_index: 6
      }
      {
        element: "#submit-button"
        intro: "You know what to do."
        position: "top"
        polygon_index: 6
        ixactive: true
      }
      {
        element: "#map-highlight"
        intro: "On three streets..."
        position: "right"
        polygon_index: 7
      }
      {
        element: "#submit-button"
        intro: "Yep, hit next."
        position: "top"
        polygon_index: 7
        ixactive: true
      }
      {
        element: "#map-highlight"
        intro: "On parallel streets... "
        position: "right"
        polygon_index: 8
      }
      {
        element: "#submit-button"
        intro: "I know, I know \" Next, next, next, next, <strong> NEXT!</strong>\" Sorry for all the redundancy but this is just how tutorials work!"
        position: "top"
        polygon_index: 8
        ixactive: true
      }
      {
        element: "#map-highlight"
        intro: "Or bizarre labyrinthine escape routes! Yes officer, he ran into 108 Wall Street and took off out of 121 Front Street! Smoke screen!"
        position: "right"
        polygon_index: 9
      }
      {
        element: "#submit-button"
        intro: "Next. (at least you'll be an expert at hitting next by the end of this)"
        position: "top"
        polygon_index: 9
        ixactive: true
      }
      {
        element: "#map-highlight"
        intro: "Soooooooo many numbers! We'll take 'em all! "
        position: "right"
        polygon_index: 10
      }
      {
        element: "#submit-button"
        intro: "Clearly, next."
        position: "top"
        polygon_index: 10
        ixactive: true
      }
      {
        element: "#map-highlight"
        intro: "Now don't get confused if you see a number <strong> ON </strong> the polygon. This is just how many stories/floors/levels the building has - NOT the address. This particular building is three stories high and has no street number.  "
        position: "right"
        polygon_index: 11
      }
      {
        element: "#submit-button"
        intro: "Skip it like your weird cousin's wedding!"
        position: "top"
        polygon_index: 11
        ixactive: true
      }
      {
        element: "#map-highlight"
        intro: "Be careful of reading the numbers upside down! This is a 60, not an 09. Always check other nearby addresses to make sure you're reading it correctly."
        position: "right"
        polygon_index: 12
      }
      {
        element: "#submit-button"
        intro: "Ext-nay (a little pig latin always keeps things interesting right?)"
        position: "top"
        polygon_index: 12
        ixactive: true
      }
      {
        element: ".leaflet-control-zoom.leaflet-bar.leaflet-control"
        intro: "Space is always at a premium in NYC and some properties may have more than one building on it - one right on the street and another in the backyard. Both of them share the same address. Use the zoom function to see who owns this building. "
        position: "left"
        polygon_index: 13
      }
      {
        element: "#map-highlight"
        intro: "This backlot structure is a part of 17 Morton St."
        position: "right"
        polygon_index: 13
      }
      {
        element: "#submit-button"
        intro: "You know what to do."
        position: "top"
        polygon_index: 13
        ixactive: true
      }
      {
        element: ".leaflet-control-zoom.leaflet-bar.leaflet-control"
        intro: "This can get tricky when dealing with funky boundary lines. When you run into this, look for one or two that seem to be primary dividers of multiple properties and use that to decide what belongs to whom. Zooming out a bit might make it easier to determine. "
        position: "left"
        polygon_index: 14
      }
      {
        element: "#map-highlight"
        intro: "Enter the number when you figure it out."
        position: "top"
        polygon_index: 14
      }
      {
        element: "#submit-button"
        intro: "You know the rest!"
        position: "top"
        polygon_index: 14
        ixactive: true
      }
      {
        element: "#map-highlight"
        intro: "Here's another - even though this back lot structure is closer to 65 Second Street, look at how it follows the property line of 52 First Street. Mark it 52."
        position: "right"
        polygon_index: 15
      }
      {
        element: "#submit-button"
        intro: "!TXEN (hold computer up to mirror to reveal this secret instruction.)"
        position: "top"
        polygon_index: 15
        ixactive: true
      }
      {
        element: "#map-highlight"
        intro: "The narrow alley leading to this building is a horserun - bascially a 19th century driveway. The structure was probably the stable for number 67, so mark it 67... "
        position: "right"
        polygon_index: 16
      }
      {
        element: "#submit-button"
        intro: "And submit it the best way you know how."
        position: "top"
        polygon_index: 16
        ixactive: true
      }
      {
        element: "#map-highlight"
        intro: "Over the line! Mark it 8, dude... or 10. Your guess is as good as ours on this one. You have a 50/50 shot so just go with your gut!"
        position: "right"
        polygon_index: 17
      }
      {
        element: "#submit-button"
        intro: "Whichever is cool with us. Hit next to continue."
        position: "top"
        polygon_index: 17
        ixactive: true
      }
      {
        element: "#map-highlight"
        intro: "This one too. It might have been a carriage house (horse garage) shared by 556 and 554. It's another tossup. "
        position: "right"
        polygon_index: 18
      }
      {
        element: "#submit-button"
        intro: "Next, of course. You're showing remarkable patience and fortitude with this. You should really be proud of yourself!"
        position: "top"
        polygon_index: 18
        ixactive: true
      }
      {
        element: "#map-highlight"
        intro: "Another thing to remember is that structures may be set farther back from the road than you'd expect. Maybe the people at 46 Leonard just really wanted a front yard."
        position: "right"
        polygon_index: 19
      }
      {
        element: "#submit-button"
        intro: "Duh."
        position: "top"
        polygon_index: 19
        ixactive: true
      }
      {
        element: "#map-highlight"
        intro: "Here's another that's set back: 114 West Broadway. In this case you'd have to enter through a narrow opening between the neighbors walls to get back there!"
        position: "right"
        polygon_index: 20
      }
      {
        element: "#submit-button"
        intro: "What do we want? <br /> <strong> NEXT! </strong> <br /> When do we want it? <br /> <strong> NOW! </strong>"
        position: "top"
        polygon_index: 20
        ixactive: true
      }
      {
          element: ".leaflet-control-zoom.leaflet-bar.leaflet-control"
        intro: "This structure was actually built to house the world's longest hot dog. No probably not, but it's very long. Zoom out to see who it belongs to. "
        position: "left"
        polygon_index: 26
      }
      {
        element: "#map-highlight"
        intro: "I'm thinking it extends from 103."
        position: "top"
        polygon_index: 26
      }
      {
        element: "#submit-button"
        intro: "Next."
        position: "top"
        polygon_index: 26
        ixactive: true
      }
      {
        element: "#map-highlight"
        intro: "It looks like this could be a backlot building for 222 or 220 but don't be fooled! Anything that faces the street like that is probably a separate property. This one just doesn't have a number."
        position: "right"
        polygon_index: 21
      }
      {
        element: "#submit-button"
        intro: "[So skip it like a flat stone on a calm lake!"
        position: "top"
        polygon_index: 21
        ixactive: true
      }
      {
        element: "#map-highlight"
        intro: "The shape of this one kind of follows the direction of the building at 376 Canal St. Remember, use those contiguous lines to your advantage! "
        position: "right"
        polygon_index: 22
      }
      {
        element: "#submit-button"
        intro: "Aaaaaaaaaaaaaand NEXT!"
        position: "top"
        polygon_index: 22
        ixactive: true
      }
      {
        element: "#map-highlight"
        intro: "If the number is written right between two buildings, and there isn't another number on the other side of either, you can assign both buildings the same address. Both this one and the green L-shaped structure next to it are 693. "
        position: "right"
        polygon_index: 24
      }
      {
        element: "#submit-button"
        intro: "[no text provided]"
        position: "top"
        polygon_index: 24
        ixactive: true
      }
      {
        element: "#map-highlight"
        intro: "Sometimes you just need use your best judgement. The property here seems to be extending from 16 White St, but it's hard to tell. Don't be ashamed to skip it... "
        position: "right"
        polygon_index: 25
      }
      {
        element: "#submit-button"
        intro: " Like Wild Horses on a Rolling Stones playlist!"
        position: "top"
        polygon_index: 25
        ixactive: true
      }
      {
        element: "#map-highlight"
        intro: "Always pay more attention to boundary lines than color. This building is probably a part of 11 Leonard Street, even though it's shaded like its neighbor on West Broadway. "
        position: "right"
        polygon_index: 27
      }
      {
        element: "#submit-button"
        intro: "I swear this is the last one - Next!"
        position: "top"
        polygon_index: 27
        ixactive: true
      }
      {
        element: "#map-highlight"
        intro: "Remember that the backlot buildings tend to be the trickiest, but hopefully these tips will make it a little bit easier. <br /> If you run into trouble, you can always review this tutorial again... "
        position: "right"
        polygon_index: 28
      }
      {
        element: "#submit-button"
        intro: "Or skip it like your 10-year high school reunion!"
        position: "top"
        polygon_index: 28
        ixactive: true
      }
      {
        element: "#link-help"
        intro: "<strong>Now you're ready to begin adding addresses!</strong><br />You can always refer to this tutorial again by hitting the HELP button.<br />Have fun! And thanks for helping The New York Public Library."
        position: "left"
        polygon_index: 28
      }
    ]
  new Address({tutorialData:tutorialData})

