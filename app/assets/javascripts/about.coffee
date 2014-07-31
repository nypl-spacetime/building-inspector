class About

  constructor: () ->
    h = @

    $(window).on('resize', () ->
      h.resize()
    )

    @resize()

  resize: () ->
    maxWidth = 960
    maxHeight = 300
    el = $("#intro h3.major.inspector")
    w = el.width()
    # console.log "size:", w, el.offset()
    el.css("background-position", "#{el.offset().left}px 0")



$ ->
  new About()
