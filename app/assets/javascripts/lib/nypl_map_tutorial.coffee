class @NYPL_Map_Tutorial

  constructor: (options) ->
    @_parseOptions(options)
    @_currentStep = 0
    @intro = introJs()
    window.onresize = () =>
      @resizeTutorial()
    @

  _parseOptions: (options)=>
    @options = {}
    @options.desktopWidth = 600
    @options = $.extend @options, options

    # required stuff
    @options.highlightElement = $(@options.highlightID)
    @options.showBullets = false

  init: () =>
    if @options.type == "video"
      # always video
      @initVideo()
      @resizeTutorial()
    else if window.innerWidth >= @options.desktopWidth
      @initFancy()
    else if @options.type != "video"
      @initSlideshow()
    @

  resizeTutorial: () ->
    w = window.innerWidth
    maxheight = 300
    return if w >= @options.desktopWidth
    $("#tutorial-video-wrapper").width(w).height(maxheight)
    $("#tutorial-video-wrapper iframe").width(w).height(maxheight)

  initVideo: () ->
    t = @
    html = '<div id="tutorial-video"><div id="tutorial-video-wrapper">
      <div id="tutorial-header"><strong>Welcome!</strong><br />Please take a minute to watch this video and learn to use this tool</div>
      <iframe src="'+@options.url+'" width="600" height="401" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe><a href="javascript:;" class="close" id="tutorial-close"><span>CLOSE</span></a></div></div>'
    el = $(html)
    el.find("#tutorial-close").on "click", (e) ->
      # console.log e
      t.exit()
    $("body").append(el)


  initSlideshow: () ->
    # compact view
    $(@options.tutorialID).unswipeshow()
    $(@options.tutorialID).show()
    $(@options.tutorialID).swipeshow
      mouse: true
      autostart: false
    .goTo 0

  initFancy: () ->
    # fancy pants demo
    t = @
    @intro.setOptions(
      skipLabel: "Exit help"
      tooltipClass: "tutorial"
      showStepNumbers: false
      showBullets: t.options.showBullets
      exitOnOverlayClick: false
      steps: @options.steps
    ).onbeforechange (e) ->
      t._currentStep = t.intro._currentStep
      onOverlay = (t.options.steps[t._currentStep].element == t.options.highlightID)
      # overriding some CSS
      $(".introjs-helperLayer").removeClass("noMap")
      $(".introjs-helperLayer").addClass("noMap") if !onOverlay
      # end CSS stuff
      t.options.highlightElement.unbind('click')
      t.options.changeFunction?(e)
      t.options.highlightElement.on('click', t.options.highlightclickFunction) if t.options.highlightclickFunction? && onOverlay
      t.options.ixinactiveFunction?()
      t.options.ixactiveFunction?() if t.options.steps[t._currentStep].ixactive
    .oncomplete () ->
      t.options.ixinactiveFunction?()
      t.options.ixactiveFunction?()
      t.options.exitFunction?()
    .onexit () ->
      # console.log "onexit"
      t.options.ixinactiveFunction?()
      t.options.ixactiveFunction?()
      t.options.exitFunction?()
    .start()
    @addCloseButton() #adds the X next to the popup

  addCloseButton: () ->
    # console.log "addclose"
    t = @
    html = '<a href="javascript:;" class="close" id="tutorial-close"><span>CLOSE</span></a>'
    el = $(html)
    el.css "right", -9
    el.css "top", -9
    el.on "click", (e) ->
      # console.log e
      t.exit()
    $(".introjs-tooltip.tutorial").append(el)

  exit: () =>
    # console.log "exit", @
    @options.ixinactiveFunction?()
    @options.ixactiveFunction?()
    @options.exitFunction?()
    @intro.exit() if @intro
    $("#tutorial-video").remove()

  nextStep: () ->
    @intro.nextStep()

  refresh: () ->
    @intro.refresh()

  goToStep: (index) ->
    @intro.goToStep(index)

  getCurrentPolygon: () ->
    @options.steps[@intro._currentStep]

  getCurrentPolygonIndex: () ->
    @options.steps[@intro._currentStep].polygon_index

