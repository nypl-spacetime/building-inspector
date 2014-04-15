class Color extends Inspector

  constructor: (options) ->
    options =
      draggableMap: true
      tutorialType:"video"
      tutorialURL: "//player.vimeo.com/video/91450313?title=0&amp;byline=0&amp;portrait=0"
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
  new Color()

