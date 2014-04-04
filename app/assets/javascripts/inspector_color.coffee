class Color extends Inspector

  constructor: (options) ->
    options =
      draggableMap: true
      tutorialData: options.tutorialData
      jsdataID: '#colorjs'
      task: 'color'
    super(options)
    @isMultiple = false
    @flags = []

  clearScreen: () =>
    document.getElementById("multiple-checkbox").checked = false
    @clearFlags()
    @updateMultipleStatus()
    super()

  addEventListeners: () =>
    super()
    $("#multiple-checkbox").on("change", @multipleColorClick)

  addButtonListeners: () =>
    super()
    inspector = @
    $("#pink-button").on("click", @submitPinkFlag)
    $("#blue-button").on("click", @submitBlueFlag)
    $("#yellow-button").on("click", @submitYellowFlag)
    $("#green-button").on("click", @submitGreenFlag)
    $("#gray-button").on("click", @submitGrayFlag)
    $("#save-button").on("click", @submitMulticolorFlag)

    $("#pink-button").on("dblclick", (e) ->
      e.preventDefault()
    )
    $("#blue-button").on("dblclick", (e) ->
      e.preventDefault()
    )
    $("#yellow-button").on("dblclick", (e) ->
      e.preventDefault()
    )
    $("#green-button").on("dblclick", (e) ->
      e.preventDefault()
    )
    $("#gray-button").on("dblclick", (e) ->
      e.preventDefault()
    )

    $("#save-button").on("dblclick", (e) ->
      e.preventDefault()
    )

    $("body").keyup (e)->
      # console.log "key", e.which
      switch e.which
        # IMPORTANT:
        # a listener to key 32 (space)
        # is already present in superclass
        when 49 then inspector.submitPinkFlag(e)
        when 97 then inspector.submitPinkFlag(e)
        when 50 then inspector.submitBlueFlag(e)
        when 98 then inspector.submitBlueFlag(e)
        when 51 then inspector.submitYellowFlag(e)
        when 99 then inspector.submitYellowFlag(e)
        when 52 then inspector.submitGreenFlag(e)
        when 100 then inspector.submitGreenFlag(e)
        when 53 then inspector.submitGrayFlag(e)
        when 101 then inspector.submitGrayFlag(e)

  removeButtonListeners: () =>
    super()
    $("#pink-button").unbind()
    $("#blue-button").unbind()
    $("#yellow-button").unbind()
    $("#green-button").unbind()
    $("#gray-button").unbind()
    $("#save-button").unbind()

  activateButton: (button) ->
    $("#blue-button").addClass("inactive") if button != "blue"
    $("#pink-button").addClass("inactive") if button != "pink"
    $("#yellow-button").addClass("inactive") if button != "yellow"
    $("#green-button").addClass("inactive") if button != "green"
    $("#gray-button").addClass("inactive") if button != "gray"
    $("#save-button").addClass("inactive") if button != "save"
    $("#blue-button").addClass("active") if button == "blue"
    $("#pink-button").addClass("active") if button == "pink"
    $("#yellow-button").addClass("active") if button == "yellow"
    $("#green-button").addClass("active") if button == "green"
    $("#gray-button").addClass("active") if button == "gray"
    $("#save-button").addClass("active") if button == "save"

  multipleColorClick: (e) =>
    @isMultiple = $("#multiple-checkbox").is(':checked')
    @multipleClickInterfaceUpdates()
    @intro.nextStep() if @options.tutorialOn

  parseTutorial: (e) =>
    super()
    # console.log @intro.intro._currentStep, e
    if @intro.getCurrentPolygon().multipleactive
      @isMultiple = true
    else
      @isMultiple = false
    document.getElementById("multiple-checkbox").checked = @isMultiple
    @multipleClickInterfaceUpdates()
    t = @
    window.setTimeout( () ->
      t.intro.refresh()
    , 200)

  multipleClickInterfaceUpdates: () ->
    @updateMultipleStatus()
    @resetButtons()
    @clearFlags() if !@isMultiple && @flags.length > 0

  resetButtons: () ->
    super()
    $("#blue-button").removeClass("active inactive pressed")
    $("#pink-button").removeClass("active inactive pressed")
    $("#yellow-button").removeClass("active inactive pressed")
    $("#green-button").removeClass("active inactive pressed")
    $("#gray-button").removeClass("active inactive pressed")
    $("#save-button").removeClass("active inactive pressed")

  submitPinkFlag: (e) =>
    @activateButton("pink") unless @options.tutorialOn || @isMultiple
    if !@isMultiple
      @submitFlag(e, "pink")
    else
      @toggleColor("pink")

  submitBlueFlag: (e) =>
    @activateButton("blue") unless @options.tutorialOn || @isMultiple
    if !@isMultiple
      @submitFlag(e, "blue")
    else
      @toggleColor("blue")

  submitYellowFlag: (e) =>
    @activateButton("yellow") unless @options.tutorialOn || @isMultiple
    if !@isMultiple
      @submitFlag(e, "yellow")
    else
      @toggleColor("yellow")

  submitGreenFlag: (e) =>
    @activateButton("green") unless @options.tutorialOn || @isMultiple
    if !@isMultiple
      @submitFlag(e, "green")
    else
      @toggleColor("green")

  submitGrayFlag: (e) =>
    @activateButton("gray") unless @options.tutorialOn || @isMultiple
    if !@isMultiple
      @submitFlag(e, "gray")
    else
      @toggleColor("gray")

  toggleColor: (color) ->
    if @flags.indexOf(color) == -1
      #not in list, add
      @flags.push(color)
      $("##{color}-button").addClass("pressed")
    else
      @flags.splice(@flags.indexOf(color),1) unless @flags.indexOf(color) == -1
      $("##{color}-button").removeClass("pressed")

  updateMultipleStatus: () ->
    if (@isMultiple)
      $(".secondary").show()
      $("#controls").addClass("multiple")
    else
      $(".secondary").hide()
      $("#controls").removeClass("multiple")

  submitMulticolorFlag: (e) =>
    @activateButton("save") unless @options.tutorialOn
    @submitFlag(e, @flags.join(","))
    @clearFlags()

  clearFlags: () ->
    @flags = []
    @isMultiple = false

$ ->
  tutorialData =
    poly: {"bbox":"","poly":[{"geometry":"[[[-74.00041350010514,40.71075562555572],[-74.00043872602114,40.71075592407098],[-74.00048694656115,40.710770708149596],[-74.00047200899458,40.71080599090039],[-74.00046220038438,40.71081096505221],[-74.00039862451166,40.710806677548995],[-74.00040432704478,40.71075686842555],[-74.00041350010514,40.71075562555572]]]"},{"geometry":"[[[-74.00167200309124,40.71217269958505],[-74.0017258228943,40.712199501394686],[-74.00173324631541,40.71228721633261],[-74.00167200309124,40.71229939895374],[-74.00166272381486,40.71229696242969],[-74.0016590121043,40.71217026305637],[-74.00167200309124,40.71217269958505]]]"},{"geometry":"[[[-74.00135954224791,40.7125011782237],[-74.00137599394264,40.712499214667965],[-74.00137898515986,40.71250314177939],[-74.00139992368044,40.71257775685259],[-74.00135355981347,40.71258757461915],[-74.00134009933595,40.712585611065954],[-74.00131616959817,40.712510996001555],[-74.00135954224791,40.7125011782237]]]"},{"geometry":"[[[-74.0000234701769,40.71199907242701],[-74.00013810701674,40.711987685193925],[-74.00015280130634,40.712046702932405],[-73.9999729442663,40.71207190599898],[-73.99996075420003,40.71200759850303],[-74.0000234701769,40.71199907242701]]]"},{"geometry":"[[[-73.99899076635921,40.70993809970345],[-73.99902012445038,40.70993381690824],[-73.99902991048079,40.70993809970345],[-73.99904622053143,40.71013082520275],[-73.9990429585213,40.710237894683566],[-73.99899076635921,40.71024646023459],[-73.99896793228832,40.71015652189385],[-73.99894836022754,40.70995094808743],[-73.99896140826806,40.70994238249839],[-73.99899076635921,40.70993809970345]]]"},{"geometry":"[[[-74.00128923343982,40.71251542043633],[-74.00130989628322,40.71251115645181],[-74.0013120422146,40.712514492440526],[-74.00133460777533,40.71258861516279],[-74.00127294340406,40.7125998237558],[-74.00124824858894,40.71252506140648],[-74.00128923343982,40.71251542043633]]]"}]}
    steps: [
            {
              element: "#map-highlight"
              intro: "testing the colors tutorial. click NEXT here."
              position: "bottom"
              polygon_index: -1
            }
            {
              element: "#lower-controls"
              intro: "this highlights only the buttons"
              position: "top"
              polygon_index: -1
            }
            {
              element: "#buttons .multiple"
              intro: "now we highlight the checkbox (checking it will prompt the next step)"
              position: "top"
              polygon_index: -1
            }
            {
              element: "#lower-controls"
              intro: "notice how the controls have changed!<br />click some colors and SAVE"
              position: "top"
              polygon_index: -1
              ixactive: true
              multipleactive: true
            }
            {
              element: "#map-highlight"
              intro: "we go back to the map but mention how the checkbox has been deactivated."
              position: "right"
              polygon_index: 0
            }
            {
              element: "#map-highlight"
              intro: "and show some other polygon"
              position: "right"
              polygon_index: 1
            }
            {
              element: "#map-highlight"
              intro: "and another"
              position: "right"
              polygon_index: 2
              ixactive: true
            }
            {
              element: "#map-highlight"
              intro: "and another"
              position: "right"
              polygon_index: 3
            }
            {
              element: "#map-highlight"
              intro: "you get the drill"
              position: "right"
              polygon_index: 4
              ixactive: true
            }
        ]
  new Color({tutorialData:tutorialData})

