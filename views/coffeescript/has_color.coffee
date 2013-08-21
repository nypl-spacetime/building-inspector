class HasColor

	polyData: {}
	currentIndex: -1
	currentPolygon: {}
	geo: {}
	popup: L.popup()

	constructor: () ->
		@map = L.mapbox.map('map', 'nypllabs.map-ad8d242u', 
			zoomControl: false
			, animate: true
			, attributionControl: false
			, minZoom: 19
			, maxZoom: 19
		)

		@geo = @newGeo()

		@map.on('load', @getPolygons)

		@map.on('click', @onMapClick)

		window.map = @map

	newGeo: () ->
		return L.geoJson({features:[]},
			style: (feature) ->
				return {
					color: '#900'
					,weight: 5
					,opacity: 1
					,dashArray: '5,10'
					,fill: false
				}
			,onEachFeature: (f,l) ->
				out = for key, val of f.properties
					"<strong>#{key}:</strong> #{val}"
				l.bindPopup(out.join("<br />"))
		)

	getPolygons: () =>
		fixer = @
		$.getJSON('/files/7130-traced.shp.json', (data) ->
			# console.log(data);
			fixer.polyData = data
			$("#red-button").on("click", fixer.showNextPolygon)
			$("#green-button").on("click", fixer.showNextPolygon)
			$("#blue-button").on("click", fixer.showNextPolygon)
			$("#yellow-button").on("click", fixer.showNextPolygon)
			fixer.showNextPolygon()
		)
	
	showNextPolygon: () =>
		@currentIndex++
		@map.removeLayer(@geo)
		if @currentIndex < @polyData.features.length
			@currentPolygon = @polyData.features[@currentIndex]
			@geo = @newGeo()
			@geo.addData(@currentPolygon)
			# center on the polygon
			l = @currentPolygon.geometry.coordinates[0].length
			midpoint = Math.floor(l/2)
			centroid = [@currentPolygon.geometry.coordinates[0][midpoint][0], @currentPolygon.geometry.coordinates[0][midpoint][1]]
			@geo.addTo(@map)
			# console.log(geo, centroid);
			@map.panTo( [ centroid[1], centroid[0] ] )

	onMapClick: (e) =>
		@popup
			.setLatLng(e.latlng)
			.setContent("You clicked the map at " + e.latlng.toString())
			.openOn(@map)

$ ->
	window._has_color = new HasColor()