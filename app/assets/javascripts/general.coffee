class General

  constructor: () ->
    h = @

    # // scroll to top (hide bar in ios)
    window.scrollTo(0, 1)

    @checkCookie()

    $(window).on('resize', () ->
      h.trimTitle()
    )

    $("#link-nav-menu").on("click", @toggleAppMenu)
    $("#link-login").on("click", @toggleSigninPopup)
    $("#link-view-inspections").on("click", @toggleProgressPopup)
    $("#task-container .shown").on("click", @onTaskClick)
    $("body").on("click", @onBodyClick)
    $("code.json").on("click", @onSampleCodeClick)

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
      "#link-random-task"
    ]
    @mobileClick id for id in overrides

  checkCookie: () ->
    $("#cookies").remove() if Utils.readCookie("cookie_test") != null

  trimTitle: () ->
    if (window.innerWidth > 500)
      document.title = document.title.replace("Bldg Inspector", "Building Inspector")
    else
      document.title = document.title.replace("Building Inspector", "Bldg Inspector")

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

  onSampleCodeClick: (e) ->
    clicked = $(e.target)
    console.log clicked
    s = window.getSelection()
    s.removeAllRanges() if (s.rangeCount > 0)

    for element in clicked
      range = document.createRange()
      range.selectNode(element)
      s.addRange(range)

$ ->
  window._gen = new General()
