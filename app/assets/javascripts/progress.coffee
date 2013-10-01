class Progress

	constructor: () ->
		$("#map-tutorial").hide()
		$("#map-about").hide()
		NW = new L.LatLng(40.65563874006115,-74.13093566894531)
		SE = new L.LatLng(40.81640757520087,-73.83087158203125)
		@map = L.mapbox.map('map', 'https://s3.amazonaws.com/maptiles.nypl.org/859/859spec.json', 
			zoomControl: false
			animate: true
			attributionControl: true
			minZoom: 12
			maxZoom: 20
			dragging: true
			maxBounds: new L.LatLngBounds(NW, SE)
		)

		L.control.zoom(
			position: 'topright'
		).addTo(@map)

		@map.on('load', @getPolygons)

		@addEventListeners()

		window.map = @

	addEventListeners: () =>
		p = @

		@map.on('load', @getPolygons)

		$("#link-help").on("click", @invokeTutorial)
		$("#link-help-close").on("click", @hideTutorial)

		$("#link-about").on("click", @invokeAbout)
		$("#link-about-close").on("click", @hideAbout)

		$("#score .total").on 'click', () ->
			location.href = "/fixer/building"

		$("#link-progress-close").on 'click', () ->
			location.href = "/fixer/building"

		$("#link-exit-about").on "click", () ->
			p.hideTutorial()

		$("#link-exit-tutorial").on "click", () ->
			p.hideTutorial()

	hideOthers: () ->
		$("#map-container").hide()
		$("#score").hide()
		$("#buttons").hide()
		$("#map-tutorial").hide()
		$("#map-about").hide()

	showOthers: () ->
		$("#map-container").show()
		$("#score").show()
		$("#buttons").show()

	invokeAbout: () =>
		@hideOthers()
		$("#map-about").show()

	hideAbout: () =>
		@showOthers()
		$("#map-about").hide()

	invokeTutorial: () =>
		@hideOthers()
		$("#map-tutorial").unswipeshow()
		$("#map-tutorial").show()
		$("#map-tutorial").swipeshow
			mouse: true
			autostart: false
		.goTo 0

	hideTutorial: () =>
		@showOthers()
		$("#map-tutorial").hide()

	getPolygons: () =>
		p = @
		no_color = '#AF2228'
		yes_color = '#609846'
		fix_color = '#FFB92D'
		$.getJSON('/fixer/sessionProgress.json', (data) ->
			# console.log(data)
			return if data.fix_poly.features.length==0 && data.no_poly.features.length==0 && data.yes_poly.features.length==0

			p.updateScore(data.all_polygons_session, data.all_polygons)

			m = p.map

			# marker clustering layer
			markers = new L.MarkerClusterGroup
				singleMarkerMode: true
				spiderfyDistanceMultiplier: 2
				disableClusteringAtZoom: 19
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
			
			markers.on 'click', (a) ->
				# console.log a.layer.getLatLng()
				m.panTo a.layer.getLatLng()
				m.setZoom 20

			# marker icons
			# yes_icon = L.icon
			# 	iconUrl: '/assets/images/marker-icon-yes.png'
			# 	iconRetinaUrl: '/assets/images/marker-icon-yes-2x.png'
			# 	iconSize: [25, 41]
			# 	iconAnchor: [12, 41]

			# no_icon = L.icon
			# 	iconUrl: '/assets/images/marker-icon-no.png'
			# 	iconRetinaUrl: '/assets/images/marker-icon-no-2x.png'
			# 	iconSize: [25, 41]
			# 	iconAnchor: [12, 41]
			
			# fix_icon = L.icon
			# 	iconUrl: '/assets/images/marker-icon-fix.png'
			# 	iconRetinaUrl: '/assets/images/marker-icon-fix-2x.png'
			# 	iconSize: [25, 41]
			# 	iconAnchor: [12, 41]
			
			yes_json = L.geoJson(data.yes_poly,
				style: (feature) ->
					fillColor: yes_color
					opacity: 0
					fillOpacity: 0.7
					stroke: false
				onEachFeature: (f,l) ->
					p.addMarker markers, f
					# out = for key, val of f.properties
					# 	"<strong>#{key}:</strong> #{val}"
					# l.bindPopup(out.join("<br />"))
					l.on 'click', ()->
						m.fitBounds(@.getBounds())
			)
			no_json = L.geoJson(data.no_poly,
				style: (feature) ->
					fillColor: no_color
					opacity: 0
					fillOpacity: 0.7
					stroke: false
				onEachFeature: (f,l) ->
					p.addMarker markers, f
					# out = for key, val of f.properties
					# 	"<strong>#{key}:</strong> #{val}"
					# l.bindPopup(out.join("<br />"))
					l.on 'click', ()->
						m.fitBounds(@.getBounds())
			)
			fix_json = L.geoJson(data.fix_poly,
				style: (feature) ->
					fillColor: fix_color
					opacity: 0
					fillOpacity: 0.7
					stroke: false
				onEachFeature: (f,l) ->
					p.addMarker markers, f
					# out = for key, val of f.properties
					# 	"<strong>#{key}:</strong> #{val}"
					# l.bindPopup(out.join("<br />"))
					l.on 'click', ()->
						m.fitBounds(@.getBounds())
			)

			bounds = new L.LatLngBounds()

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
	
	updateScore: (current, total) =>
		mapScore = if total > 0 then Math.round(current*100/total) else 0

		mapDOM = $("#map-bar")
		mapDOM.find(".bar").css("width", mapScore + "%")
		$("#score .total").text(current)
		$("#map-total").text(total + " shapes")

		url = $('#progressjs').data("server")
		tweet = current + " buildings checked! Data mining old maps with the Building Inspector from @NYPLMaps + @nypl_labs"
		twitterurl = "https://twitter.com/share?url=" + url + "&text=" + tweet


		$("#tweet").attr "href", twitterurl

	addMarker: (markers, data) ->
		latlng = L.geoJson(data).getBounds().getCenter()#new L.LatLng(data.geometry.coordinates[0][0][1],data.geometry.coordinates[0][0][0])
		# console.log latlng
		markers.addLayer new L.Marker latlng
			# icon: icon
		markers

	onMapClick: (e) =>
		@popup
			.setLatLng(e.latlng)
			.setContent("You clicked the map at " + e.latlng.toString())
			.openOn(@map)

$ ->
	window._progress = new Progress()
