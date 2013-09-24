class TagBuilding

	polyData: {}
	currentIndex: -1
	currentPolygon: {}
	geo: {}
	popup: L.popup()
	verticalOffset: 100 # pixels to offset the polygon from the center
	loadedData: {}
	tutorialOn: $('#tagbuildingjs').data("session")
	mapPolygons: 0
	mapPolygonsSession: 0
	allPolygons: 0
	allPolygonsSession: 0
	level: 0

	constructor: () ->
		$("#map-tutorial").hide()
		$("#buttons").hide()
		@map = L.mapbox.map('map', 'https://s3.amazonaws.com/maptiles.nypl.org/859/859spec.json', 
			zoomControl: false
			animate: true
			attributionControl: false
			minZoom: 20
			maxZoom: 20
			dragging: false
		)

		@map.on('load', @getPolygons)

		$("#link-help").on("click", @invokeTutorial)

		$("#yes-button").on("click", @submitYesFlag)
		$("#no-button").on("click", @submitNoFlag)
		$("#fix-button").on("click", @submitFixFlag)

		$("#score .total").on 'click', () ->
			location.href = "/fixer/progress"

		# @map.on('click', @onMapClick)

		window.map = @

		tagger = @

		@tID = window.setTimeout(
				() ->
					tagger.invokeTutorial()
				, 1000
		) if @tutorialOn
		# console.log @tutorialOn

	updateScore: () =>
		if @mapPolygons == 0 && @allPolygons == 0
			@mapPolygons = @loadedData.status.map_polygons
			@mapPolygonsSession = @loadedData.status.map_polygons_session
			@allPolygons = @loadedData.status.all_polygons
			@allPolygonsSession = @loadedData.status.all_polygons_session
		
		levelfloat = if @allPolygonsSession > 1 then Math.log(@allPolygonsSession) / Math.LN2 else Math.LN2
		levelfloat = 0 if @allPolygonsSession == 0
		level = Math.floor(levelfloat)
		level = 0 if @allPolygonsSession == 0
		maximumLevel = 16
		levelScore = Math.round(100 * (level / maximumLevel)) #Math.round(100 * (@allPolygonsSession / @allPolygons))
		levelScore = 100 if levelScore > 100

		# mapScore = Math.round(100 * ((@mapPolygons - @mapPolygonsSession) / @mapPolygons))
		# mapScore = if @allPolygonsSession > 0 then Math.round((levelfloat-level)*100) else 0
		mapScore = if @mapPolygons > 0 then Math.round(@allPolygonsSession*100/@allPolygons) else 0

		if @level != level
			@level = level
			@animateLevel()

		# console.log "level:", level, mapScore
		
		$("#score .total").text(@allPolygonsSession)

		levelDOM = $("#level-bar")
		levelDOM.find(".percent").text("Level: " + @level)
		levelDOM.find(".bar").css("width",levelScore + "%")
		
		mapDOM = $("#map-bar")
		mapDOM.find(".percent").text( "Next level: " + mapScore + "%")
		mapDOM.find(".bar").css("width", mapScore + "%")

	animateLevel: () =>
		el = $("#score .level-animation")
		el.text("Level " + @level + "!")
		.show().fadeOut(1000)

	invokeTutorial: () =>
		$("#map-tutorial").unswipeshow()
		$("#map-tutorial").show()
		$("#map-container").hide()
		$("#score").hide()
		$("#link-help").hide()
		$("#buttons").hide()
		$("#map-tutorial").swipeshow
			mouse: true
			autostart: false
		.goTo 0

		fixer = @
		$("#link-exit-tutorial").on "click", () ->
			console.log "hi"
			fixer.hideTutorial()

	hideTutorial: () =>
		$("#map-tutorial").hide()
		$("#score").show()
		$("#map-container").show()
		$("#link-help").show()
		$("#buttons").show()

	getPolygons: () =>
		tagger = @
		$.getJSON('/fixer/map.json', (data) ->
			# console.log(data);
			$("#loader").remove()
			data.poly = tagger.shufflePolygons(data.poly)
			tagger.loadedData = data
			tagger.polyData = data.poly
			tagger.updateScore()
			tagger.showNextPolygon()
		)
	
	shufflePolygons: (a) ->
		# from: http://coffeescriptcookbook.com/chapters/arrays/shuffling-array-elements
		# From the end of the list to the beginning, pick element `i`.
		for i in [a.length-1..1]
			# Choose random element `j` to the front of `i` to swap with.
			j = Math.floor Math.random() * (i + 1)
			# Swap `j` with `i`, using destructured assignment
			[a[i], a[j]] = [a[j], a[i]]
		# Return the shuffled array.
		a

	submitYesFlag: () =>
		@submitFlag("yes")

	submitNoFlag: () =>
		@submitFlag("no")

	submitFixFlag: () =>
		@submitFlag("fix")

	submitFlag: (type) =>
		$("#buttons").hide()
		@mapPolygonsSession--
		@allPolygonsSession++
		@updateScore()
		# if @tutorialOn
		# 	# do not submit the data
		# 	@showNextPolygon()
		# 	return
		tagger = @
		$.get("/fixer/flag", 
			i: @currentPolygon.id
			f: type
			, () ->
				tagger.showNextPolygon()
		# ).done( () ->
		# 	tagger.showNextPolygon()
		# ).fail( () ->
		# 	tagger.showNextPolygon()
		)
	
	showNextPolygon: () =>
		# console.log @polyData
		@currentIndex++
		@map.removeLayer(@geo)
		if @currentIndex < @polyData.length
			$("#buttons").show()
			@currentPolygon = @polyData[@currentIndex]
			@geo = @makePolygon(@currentPolygon)
			# console.log @currentPolygon #, @currentGeo
			# console.log @geo
			# center on the polygon
			@geo.addTo(@map)
			@map.fitBounds( @geo.getBounds() )
		else
			console.log "Loading more polygons..."
			@mapPolygons = 0
			@mapPolygonsSession = 0
			@allPolygons = 0
			@allPolygonsSession = 0
			@getPolygons()

	makePolygon: (poly) ->
		json = 
			type : "Feature"
			properties:
				DN: poly.dn
				color: poly.color
				id: poly.id
				sheet_id: poly.sheet_id
				status: poly.status
			geometry:
				type: "Polygon"
				coordinates: $.parseJSON(poly.geometry)
		geo = L.geoJson({features:[]},
			style: (feature) ->
				color: '#b00'
				weight: 4
				opacity: 1
				dashArray: '4,12'
				fill: false
			onEachFeature: (f,l) ->
				out = for key, val of f.properties
					"<strong>#{key}:</strong> #{val}"
				l.bindPopup(out.join("<br />"))
		).addData json

	onMapClick: (e) =>
		@popup
			.setLatLng(e.latlng)
			.setContent("You clicked the map at " + e.latlng.toString())
			.openOn(@map)

$ ->
	window._is_building = new TagBuilding()
