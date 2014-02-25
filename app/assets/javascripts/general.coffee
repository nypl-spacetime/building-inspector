class General

  constructor: () ->
    # // scroll to top (hide bar in ios)
    window.scrollTo(0, 1)

    window.onresize = () =>
      @resizeSVG()

    window.setTimeout(
        () ->
          $("#top-nav").removeClass("hidden")
        , 1000
    )
    $("#link-nav-menu").on("click", @toggleAppMenu)
    $("#link-login").on("click", @toggleSigninPopup)
    $("#link-view-inspections").on("click", @toggleProgressPopup)
    $("#task-container .shown").on("click", @onTaskClick)
    $("body").on("click", @onBodyClick)

    $("#home-slideshow").swipeshow(
      autostart: true
      mouse: false
      initial: 0
      speed: 700
      interval: 6000
      onactivate: (slide, index) ->
        console.log "activate", slide, index
        $("#slide-buttons a").removeClass("active")
        $("#link-building").addClass("active") if index==0
        $("#link-numbers").addClass("active") if index==1
        $("#link-polygonfix").addClass("active") if index==2
    )

    if (window.innerWidth < 500)
      document.title = "Bldg Inspector"

    overrides = [
      "#home-logo"
      "#link-help"
      "#link-about"
      "#logout-link"
      ".score-save-link"
      ".sign-in-link"
      ".score-link"
      ".legend-link"
      "#link-try"
      "#link-back"
    ]
    @mobileClick id for id in overrides

  resizeSVG: () =>
    maxWidth = 960
    maxHeight = 300
    w = $("#home-slideshow").width()
    # console.log "size:", w
    return if !(w > 0 && w < maxWidth)
    offset = (maxWidth - w) / 2
    svgs = document.getElementsByClassName("intro-path");
    for svg in svgs
      svg.setAttribute("viewBox", "#{offset} 0 #{w} #{maxHeight}");

  mobileClick: (id) ->
    elem = $(id)
    elem.click (e) ->
      e.preventDefault()
      window.location.href = e.currentTarget.href;

  toggleAppMenu: (e) ->
    $("#top-nav").toggleClass("open")
    e.stopPropagation()

  toggleSigninPopup: (e) ->
    $("#task-container .hidden").hide()
    $('#score-progress').hide()
    $('#links-account .popup').toggle()
    e.stopPropagation()

  toggleProgressPopup: (e) ->
    $("#task-container .hidden").hide()
    $('#links-account .popup').hide()
    $('#score-progress').toggle()
    e.stopPropagation()

  onBodyClick: (e) ->
    if !$(e.target).closest('#top-nav.open').length
      $("#top-nav.open").removeClass("open")
    if !$(e.target).closest('#task-container').length
      $("#task-container .hidden").hide()
    if !$(e.target).closest('.popup').length
      $('.popup').hide()

  onTaskClick: (e) ->
    $('.popup').hide()
    e.preventDefault()
    e.stopPropagation()
    $("#task-container .hidden").toggle()

  # deep copy method
  # see: http://coffeescriptcookbook.com/chapters/classes_and_objects/cloning
  clone: (obj) ->
    if not obj? or typeof obj isnt 'object'
      return obj

    if obj instanceof Date
      return new Date(obj.getTime())

    if obj instanceof RegExp
      flags = ''
      flags += 'g' if obj.global?
      flags += 'i' if obj.ignoreCase?
      flags += 'm' if obj.multiline?
      flags += 'y' if obj.sticky?
      return new RegExp(obj.source, flags)

    newInstance = new obj.constructor()

    for key of obj
      newInstance[key] = @clone obj[key]

    return newInstance

  _spinner: () ->
    opts =
      lines: 11, # The number of lines to draw
      length: 0, # The length of each line
      width: 4, # The line thickness
      radius: 8, # The radius of the inner circle
      corners: 1, # Corner roundness (0..1)
      rotate: 0, # The rotation offset
      color: '#3f3a34', # #rgb or #rrggbb
      speed: 1, # Rounds per second
      trail: 60, # Afterglow percentage
      shadow: false, # Whether to render a shadow
      hwaccel: false, # Whether to use hardware acceleration
      className: 'spinner', # The CSS class to assign to the spinner
      zIndex: 9, # The z-index (defaults to 2000000000)
      top: 'auto', # Top position relative to parent in px
      left: 'auto' # Left position relative to parent in px

    new Spinner(opts).spin()

$ ->
  window._gen = new General()
