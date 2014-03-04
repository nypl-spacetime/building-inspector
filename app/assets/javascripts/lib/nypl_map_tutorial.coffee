class @NYPL_Map_Tutorial
  constructor: (options) ->
    @_parseOptions(options)
    @_currentStep = 0
    @intro = introJs()
    @

  _parseOptions: (options)=>
    @opts = {}

    # required stuff
    @opts.highlightID = options.highlightID
    @opts.highlightElement = $(options.highlightID)
    @opts.steps = options.steps

    # optional stuff
    @opts.highlightclickFunction = options.highlightclickFunction if options.highlightclickFunction
    @opts.changeFunction = options.changeFunction if options.changeFunction
    @opts.exitFunction = options.exitFunction if options.exitFunction
    @opts.ixactiveFunction = options.ixactiveFunction if options.ixactiveFunction
    @opts.ixinactiveFunction = options.ixinactiveFunction if options.ixinactiveFunction

  init: () =>
    t = @
    @intro.setOptions(
      skipLabel: "Exit tutorial"
      tooltipClass: "tutorial"
      showStepNumbers: false
      exitOnOverlayClick: false
      steps: @opts.steps
    ).onchange () ->
      t._currentStep = t.intro._currentStep
      onOverlay = (t.opts.steps[t._currentStep].element == t.opts.highlightElement[0])
      # overriding some CSS
      $(".introjs-helperLayer").removeClass("noMap")
      $(".introjs-helperLayer").addClass("noMap") if !onOverlay
      # end CSS stuff
      t.opts.highlightElement.unbind('click')
      t.opts.changeFunction() if t.opts.changeFunction
      t.opts.highlightElement.on('click', t.opts.highlightclickFunction) if t.opts.highlightclickFunction && onOverlay
      t.opts.ixinactiveFunction() if t.opts.ixinactiveFunction
      t.opts.ixactiveFunction() if t.opts.steps[t._currentStep].ixactive && t.opts.ixactiveFunction
    .oncomplete () ->
      t.opts.ixinactiveFunction() if t.opts.ixinactiveFunction
      t.opts.ixactiveFunction() if t.opts.ixactiveFunction
      t.opts.exitFunction()
    .onexit () ->
      t.opts.ixinactiveFunction() if t.opts.ixinactiveFunction
      t.opts.ixactiveFunction() if t.opts.ixactiveFunction
      t.opts.exitFunction()
    .start()
    @

  exit: () ->
    @intro.exit() if @intro

  goToStep: (index) ->
    @intro.goToStep(index)

  getCurrentPolygonIndex: () ->
    @opts.steps[@intro._currentStep].polygon_index

#1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27