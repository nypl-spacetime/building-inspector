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
				"#link-try"
				"#link-back"
			]
			@mobileClick id for id in overrides

	mobileClick: (id) ->
		elem = $(id)
		link = elem.attr("href")
		elem.click (e) ->
			# if (link.indexOf("/")==0) #only for relative links
			e.preventDefault()
			window.location.href = link;

	toggleBottomSigninOptions: (e) ->
		$('#score-save .sign-in-options').toggle()
		e.stopPropagation()

	toggleTopSigninOptions: (e) ->
		$('#links-account .sign-in-options').toggle()
		e.stopPropagation()

	onBodyClick: (e) ->
		if !$(e.target).closest('.sign-in-options').length
			$('.sign-in-options').hide()

$ ->
	window._gen = new General()
