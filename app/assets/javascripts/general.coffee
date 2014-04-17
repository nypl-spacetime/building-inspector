class General

  constructor: () ->
    # // scroll to top (hide bar in ios)
    window.scrollTo(0, 1)

    window.onresize = () =>
      @resizeSVG()

    $("#link-nav-menu").on("click", @toggleAppMenu)
    $("#link-login").on("click", @toggleSigninPopup)
    $("#link-view-inspections").on("click", @toggleProgressPopup)
    $("#task-container .shown").on("click", @onTaskClick)
    $("body").on("click", @onBodyClick)


    overrides = [
      ".link-task"
      ".slide a"
      ".popup-link"
      "#home-logo"
      "#link-data"
      "#link-help"
      "#link-about"
      "#logout-link"
      ".home-link"
      "#top-nav .task-link"
      ".score-save-link"
      ".sign-in-link"
      ".score-link"
      ".legend-link"
      "#link-try"
      "#link-back"
      "#toc a"
    ]
    @mobileClick id for id in overrides

  resizeSVG: () =>

    if (window.innerWidth < 500)
      document.title = document.title.replace("Building Inspector", "Bldg Inspector")
    else
      document.title = document.title.replace("Bldg Inspector", "Building Inspector")

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
    $("#nav-toggle").toggleClass("open")
    e.stopPropagation() if e

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
      $("#task-toggle").removeClass("open")
    if !$(e.target).closest('#task-container').length
      $("#task-container .hidden").hide()
    if !$(e.target).closest('.popup').length
      $('.popup').hide()
      $("#task-toggle").removeClass("open")

  onTaskClick: (e) ->
    $('.popup').hide()
    e.preventDefault()
    e.stopPropagation()
    $("#task-container .hidden").toggle()
    $("#task-toggle").addClass("open")

$ ->
  window._gen = new General()
