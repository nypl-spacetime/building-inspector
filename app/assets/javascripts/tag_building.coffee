class TagBuilding

	polyData: {}
	currentIndex: -1
	currentPolygon: {}
	geo: {}
	popup: L.popup()
	verticalOffset: 100 # pixels to offset the polygon from the center
	loadedData: {}
	tutorialOn: $('#tagbuildingjs').data("session")

	constructor: () ->
		$("#map-tutorial").hide()
		$("#buttons").hide()
		@map = L.mapbox.map('map', 'https://s3.amazonaws.com/maptiles.nypl.org/859/859spec.json', 
			zoomControl: false
			animate: true
			attributionControl: false
			minZoom: 19
			maxZoom: 19
			# dragging: false
		)

		@map.on('load', @getPolygons)

		$("#link-help").on("click", @invokeTutorial)

		# @map.on('click', @onMapClick)

		window.map = @map

		tagger = @

		@tID = window.setTimeout(
				() ->
					tagger.invokeTutorial()
				, 1000
		) if @tutorialOn
		# console.log @tutorialOn

	invokeTutorial: () =>
		$("#map-tutorial").unswipeshow
		$("#map-tutorial").show()
		$("#map-container").hide()
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
		$("#map-container").show()
		$("#link-help").show()
		$("#buttons").show()

	getPolygons: () =>
		tagger = @
		$.getJSON('/fixer/map.json', (data) ->
			# console.log(data);
			tagger.polyData = tagger.loadedData = data
			$("#yes-button").on("click", tagger.submitYesFlag)
			$("#no-button").on("click", tagger.submitNoFlag)
			$("#fix-button").on("click", tagger.submitFixFlag)
			tagger.showNextPolygon()
		)
	
	submitYesFlag: () =>
		@submitFlag("yes")

	submitNoFlag: () =>
		@submitFlag("no")

	submitFixFlag: () =>
		@submitFlag("fix")

	submitFlag: (type) =>
		$("#buttons").hide()
		if @tutorialOn
			# do not submit the data
			@showNextPolygon()
			return
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
		if @currentIndex < @polyData.poly.length
			$("#buttons").show()
			@currentPolygon = @polyData.poly[@currentIndex]
			@geo = @makePolygon(@currentPolygon)
			# console.log @currentPolygon #, @currentGeo
			# console.log @geo
			# center on the polygon
			@geo.addTo(@map)
			@map.fitBounds( @geo.getBounds() )

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
