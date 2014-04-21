class About

  constructor: () ->
    h = @
    @setWaypoints()

  setWaypoints: () ->
    h = @
    $("#waypoint").waypoint( (direction)->
      $("#waypoint").waypoint('destroy')
      $.get('/general/home_explained', (data) ->
        d = $(data)
        $("#waypoint-dest").append(d)
        .hide()
        .fadeIn(1000)
        $("#waypoint-dest .learn-more").click( ()->
          h.getStarted()
        )
      )
    )

$ ->
  new About()
