class Home

  constructor: () ->
    $("#link-learn-more").click( ()->
      $.scrollTo("#home-slideshow",
        easing:   "swing"
        duration: 400
      )
    )

$ ->
  new Home()
