class General

	constructor: () ->
		# // scroll to top (hide bar in ios)
		window.scrollTo(0, 1)
		
		$("#link-score-save").on("click", @toggleBottomSigninOptions)
		$("#link-login").on("click", @toggleTopSigninOptions)
		$("body").on("click", @onBodyClick)

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

	mobileClick: (id) ->
		elem = $(id)
		elem.click (e) ->
			e.preventDefault()
			window.location.href = e.currentTarget.href;

	toggleBottomSigninOptions: (e) ->
		$('#score-save .sign-in-options').toggle()
		e.stopPropagation()

	toggleTopSigninOptions: (e) ->
		$('#links-account .sign-in-options').toggle()
		e.stopPropagation()

	onBodyClick: (e) ->
		if !$(e.target).closest('.sign-in-options').length
			$('.sign-in-options').hide()

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
