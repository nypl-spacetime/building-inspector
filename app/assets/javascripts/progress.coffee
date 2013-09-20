class Progress

	constructor: () ->
		@map = L.mapbox.map('map', 'https://s3.amazonaws.com/maptiles.nypl.org/859/859spec.json', 
			zoomControl: false
			animate: true
			attributionControl: false
			minZoom: 13
			maxZoom: 20
			dragging: true
		)

		@map.on('load', @getPolygons)


		# @map.on('click', @onMapClick)

		window.map = @

	getPolygons: () =>
		p = @
		no_color = '#AF2228'
		yes_color = '#609846'
		fix_color = '#FFB92D'
		$.getJSON('/fixer/sessionProgress.json', (data) ->
			# console.log(data)
			return if data.fix_poly.features.length==0 && data.no_poly.features.length==0 && data.yes_poly.features.length==0
			m = p.map

			# marker clustering layer
			markers = new L.MarkerClusterGroup
				iconCreateFunction: (c) ->
					count = c.getChildCount()
					c = 'cluster-large'
					if count < 10
						c = 'cluster-small'
					else if count < 30
						c = 'cluster-medium'
					new L.DivIcon
						html: count
						className: c
						iconSize: L.point(30, 30)
				polygonOptions:
					stroke: false
			
			# marker icons
			yes_icon = L.icon
				iconUrl: '/assets/images/marker-icon-yes.png'
				iconRetinaUrl: '/assets/images/marker-icon-yes-2x.png'
				iconSize: [25, 41]
				iconAnchor: [12, 41]

			no_icon = L.icon
				iconUrl: '/assets/images/marker-icon-no.png'
				iconRetinaUrl: '/assets/images/marker-icon-no-2x.png'
				iconSize: [25, 41]
				iconAnchor: [12, 41]
			
			fix_icon = L.icon
				iconUrl: '/assets/images/marker-icon-fix.png'
				iconRetinaUrl: '/assets/images/marker-icon-fix-2x.png'
				iconSize: [25, 41]
				iconAnchor: [12, 41]
			
			yes_json = L.geoJson(data.yes_poly,
				style: (feature) ->
					fillColor: yes_color
					opacity: 0
					fillOpacity: 0.7
					stroke: false
				onEachFeature: (f,l) ->
					p.addMarker markers, f, yes_icon
					out = for key, val of f.properties
						"<strong>#{key}:</strong> #{val}"
					l.bindPopup(out.join("<br />"))
			)
			no_json = L.geoJson(data.no_poly,
				style: (feature) ->
					fillColor: no_color
					opacity: 0
					fillOpacity: 0.7
					stroke: false
				onEachFeature: (f,l) ->
					p.addMarker markers, f, no_icon
					out = for key, val of f.properties
						"<strong>#{key}:</strong> #{val}"
					l.bindPopup(out.join("<br />"))
			)
			fix_json = L.geoJson(data.fix_poly,
				style: (feature) ->
					fillColor: fix_color
					opacity: 0
					fillOpacity: 0.7
					stroke: false
				onEachFeature: (f,l) ->
					p.addMarker markers, f, fix_icon
					out = for key, val of f.properties
						"<strong>#{key}:</strong> #{val}"
					l.bindPopup(out.join("<br />"))
			)

			bounds = new L.LatLngBounds(new L.LatLng(40.712, -74.227))

			if data.yes_poly.features.length>0
				yes_json.addTo(m)
				bounds.extend(yes_json.getBounds())

			if data.no_poly.features.length>0
				no_json.addTo(m)
				bounds.extend(no_json.getBounds())

			if data.fix_poly.features.length>0
				fix_json.addTo(m)
				bounds.extend(fix_json.getBounds())

			m.addLayer(markers)
			
			m.fitBounds(bounds)
		)
	
	addMarker: (markers, data, icon) ->
		latlng = L.geoJson(data).getBounds().getCenter()#new L.LatLng(data.geometry.coordinates[0][0][1],data.geometry.coordinates[0][0][0])
		# console.log latlng
		markers.addLayer new L.Marker latlng,
			icon: icon
		markers

	showPolygon: () =>
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
	window._progress = new Progress()
