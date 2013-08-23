class IsBuilding

	polyData: {}
	currentIndex: -1
	currentPolygon: {}
	geo: {}
	popup: L.popup()
	verticalOffset: 100 # pixels to offset the polygon from the center

	constructor: () ->
		@map = L.mapbox.map('map', 'nypllabs.singlesheet-fix', 
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
					color: '#b00'
					,weight: 4
					,opacity: 1
					,dashArray: '5,15'
					,fill: false
				}
			,onEachFeature: (f,l) ->
				out = for key, val of f.properties
					"<strong>#{key}:</strong> #{val}"
				l.bindPopup(out.join("<br />"))
		)

	getPolygons: () =>
		fixer = @
		$.getJSON('/fixer/map.json', (data) ->
			# console.log(data);
			fixer.polyData = data
			$("#yes-button").on("click", fixer.showNextPolygon)
			$("#no-button").on("click", fixer.showNextPolygon)
			$("#fix-button").on("click", fixer.showNextPolygon)
			fixer.showNextPolygon()
		)
	
	showNextPolygon: () =>
		@currentIndex++
		@map.removeLayer(@geo)
		if @currentIndex < @polyData.poly.length
			@currentPolygon = @polyData.poly[@currentIndex]
			@currentGeo = 
				type : "Feature"
				properties:
					DN: @currentPolygon.dn
					color: @currentPolygon.color
					id: @currentPolygon.id
					sheet_id: @currentPolygon.sheet_id
					status: @currentPolygon.status
				geometry:
					type: "Polygon"
					coordinates: $.parseJSON(@currentPolygon.geometry)
			# console.log @currentPolygon, @currentGeo
			@geo = @newGeo()
			@geo.addData(@currentGeo)
			# center on the polygon
			l = @currentGeo.geometry.coordinates[0].length
			midpoint = Math.floor(l/2)
			centroid = [@currentGeo.geometry.coordinates[0][midpoint][0], @currentGeo.geometry.coordinates[0][midpoint][1]]
			@geo.addTo(@map)
			latlng = new L.LatLng(centroid[1], centroid[0])
			xy = @map.latLngToLayerPoint(latlng)
			# console.log(latlng, xy)
			xy.y += @verticalOffset
			# console.log(xy)
			latlng = @map.layerPointToLatLng(xy)
			@map.panTo( latlng )

	onMapClick: (e) =>
		@popup
			.setLatLng(e.latlng)
			.setContent("You clicked the map at " + e.latlng.toString())
			.openOn(@map)

$ ->
	window._is_building = new IsBuilding()