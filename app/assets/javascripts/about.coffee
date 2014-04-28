class About

  constructor: () ->
    h = @

    $(window).on('resize', () ->
      h.resize()
    )

    @resize()

  #   @setWaypoints()

  # setWaypoints: () ->
  #   h = @
  #   $("#waypoint").waypoint( (direction)->
  #     $("#waypoint").waypoint('destroy')
  #     $.get('/general/home_explained', (data) ->
  #       d = $(data)
  #       $("#waypoint-dest").append(d)
  #       .hide()
  #       .fadeIn(1000)
  #       $("#waypoint-dest .learn-more").click( ()->
  #         h.getStarted()
  #       )
  #     )
  #   )

  resize: () ->
    maxWidth = 960
    maxHeight = 300
    el = $("#intro h3.major.inspector")
    w = el.width()
    # console.log "size:", w, el.offset()
    el.css("background-position", "#{el.offset().left}px 0")
    # return if !(w > 0 && w < maxWidth)
    # offset = (maxWidth - w) / 2
    # svgs = document.getElementsByClassName("intro-path");
    # for svg in svgs
    #   svg.setAttribute("viewBox", "#{offset} 0 #{w} #{maxHeight}");



$ ->
  new About()
