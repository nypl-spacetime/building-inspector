class General

	constructor: () ->

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
			]
			@mobileClick id for id in overrides

	mobileClick: (id) ->
		elem = $(id)
		link = elem.attr("href")
		elem.click (e) ->
			# if (link.indexOf("/")==0) #only for relative links
			e.preventDefault()
			window.location.href = link;

$ ->
	window._general = new General()
