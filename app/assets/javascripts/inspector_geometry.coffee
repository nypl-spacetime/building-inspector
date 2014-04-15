class Geometry extends Inspector

  constructor: (options) ->
    options =
      draggableMap: true
      tutorialType:"video"
      tutorialURL: "//player.vimeo.com/video/91450313?title=0&amp;byline=0&amp;portrait=0"
      jsdataID: '#geometryjs'
      task: 'geometry'
    super(options)

  clearScreen: () =>
    super()

  addEventListeners: () =>
    super()

  addButtonListeners: () =>
    super()
    inspector = @
    $("#yes-button").on("click", @submitYesFlag)
    $("#no-button").on("click", @submitNoFlag)
    $("#fix-button").on("click", @submitFixFlag)

    $("#yes-button").on("dblclick", (e) ->
      e.preventDefault()
    )
    $("#no-button").on("dblclick", (e) ->
      e.preventDefault()
    )
    $("#fix-button").on("dblclick", (e) ->
      e.preventDefault()
    )

    $("body").keyup (e)->
      # console.log "key", e.which
      switch e.which
        # IMPORTANT:
        # a listener to key 32 (space)
        # is already present in superclass
        when 49 then inspector.submitNoFlag(e)
        when 97 then inspector.submitNoFlag(e)
        when 50 then inspector.submitFixFlag(e)
        when 98 then inspector.submitFixFlag(e)
        when 51 then inspector.submitYesFlag(e)
        when 99 then inspector.submitYesFlag(e)

  removeButtonListeners: () =>
    super()
    $("#yes-button").unbind()
    $("#no-button").unbind()
    $("#fix-button").unbind()

  activateButton: (button) ->
    $("#no-button").addClass("inactive") if button != "no"
    $("#yes-button").addClass("inactive") if button != "yes"
    $("#fix-button").addClass("inactive") if button != "fix"
    $("#no-button").addClass("active") if button == "no"
    $("#yes-button").addClass("active") if button == "yes"
    $("#fix-button").addClass("active") if button == "fix"

  resetButtons: () ->
    super()
    $("#no-button").removeClass("active inactive")
    $("#yes-button").removeClass("active inactive")
    $("#fix-button").removeClass("active inactive")

  submitYesFlag: (e) =>
    @activateButton("yes") unless @options.tutorialOn
    @submitFlag(e, "yes")

  submitNoFlag: (e) =>
    @activateButton("no") unless @options.tutorialOn
    @submitFlag(e, "no")

  submitFixFlag: (e) =>
    @activateButton("fix") unless @options.tutorialOn
    @submitFlag(e, "fix")

$ ->
  new Geometry()

