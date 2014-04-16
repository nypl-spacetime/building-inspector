class Home

  constructor: () ->
    $(".learn-more").click( ()->
      $.scrollTo("#home-slideshow",
        easing:   "swing"
        duration: 400
      )
    )
    @setWaypoints()

  setWaypoints: () ->
    $("#intro").waypoint( (direction)->
      $("#intro").waypoint('destroy')
      $.get('/general/home_explained', (data) ->
        d = $(data)
        $("#waypoint").append(d)
        .hide()
        .fadeIn(1000)
      )
    )

$ ->
  new Home()
