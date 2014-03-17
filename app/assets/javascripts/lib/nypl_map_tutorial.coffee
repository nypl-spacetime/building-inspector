class @NYPL_Map_Tutorial

  constructor: (options) ->
    @_parseOptions(options)
    @_currentStep = 0
    @intro = introJs()
    @

  _parseOptions: (options)=>
    @opts = {}
    @opts = $.extend @opts, options

    # required stuff
    @opts.highlightElement = $(options.highlightID)
    @opts.showBullets = false

  init: () =>
    t = @
    @intro.setOptions(
      skipLabel: "Exit help"
      tooltipClass: "tutorial"
      showStepNumbers: false
      showBullets: t.opts.showBullets
      exitOnOverlayClick: false
      steps: @opts.steps
    ).onchange () ->
      t._currentStep = t.intro._currentStep
      onOverlay = (t.opts.steps[t._currentStep].element == t.opts.highlightID)
      # overriding some CSS
      $(".introjs-helperLayer").removeClass("noMap")
      $(".introjs-helperLayer").addClass("noMap") if !onOverlay
      # end CSS stuff
      t.opts.highlightElement.unbind('click')
      t.opts.changeFunction?()
      t.opts.highlightElement.on('click', t.opts.highlightclickFunction) if t.opts.highlightclickFunction && onOverlay
      t.opts.ixinactiveFunction?()
      t.opts.ixactiveFunction?() if t.opts.steps[t._currentStep].ixactive
    .oncomplete () ->
      t.opts.ixinactiveFunction?()
      t.opts.ixactiveFunction?()
      t.opts.exitFunction()
    .onexit () ->
      # console.log "onexit"
      t.opts.ixinactiveFunction?()
      t.opts.ixactiveFunction?()
      t.opts.exitFunction?()
    .start()
    @addCloseButton() #adds the X next to the popup
    @

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
    @opts.ixinactiveFunction?()
    @opts.ixactiveFunction?()
    @opts.exitFunction?()
    @intro.exit() if @intro

  goToStep: (index) ->
    @intro.goToStep(index)

  getCurrentPolygonIndex: () ->
    @opts.steps[@intro._currentStep].polygon_index
