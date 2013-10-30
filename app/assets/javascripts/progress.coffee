class Progress

	constructor: () ->
		$("#map-tutorial").hide()
		$("#map-about").hide()
		$("#tweet").hide()
		NW = new L.LatLng(40.65563874006115,-74.13093566894531)
		SE = new L.LatLng(40.81640757520087,-73.83087158203125)
		@map = L.mapbox.map('map', 'https://s3.amazonaws.com/maptiles.nypl.org/859-final/859spec.json', 
			zoomControl: false
			animate: true
			scrollWheelZoom: true
			attributionControl: true
			minZoom: 12
			maxZoom: 20
			dragging: true
			maxBounds: new L.LatLngBounds(NW, SE)
		)

		L.control.zoom(
			position: 'topright'
		).addTo(@map)

		# @map.on('load', @getPolygons)

		@addEventListeners()

		@resetSheet()

		L.InspectorMarker = L.Marker.extend
			options:
				flag_count: 0
				sheet_id: 0
				bounds: []

		window.map = @

	addEventListeners: () =>
		p = @

		@map.on('load', @getCounts)

	resetSheet: () ->
		@map.removeLayer @sheet if @map.hasLayer @sheet
		@sheet = L.geoJson({features:[]},
			style: (feature) ->
				color: @nil_color
				opacity: 0
				fillOpacity: 0.5
				stroke: false
		).addTo @map

	getCounts: () =>
		data = $('#progressjs').data("progress")

		@updateScore(data.all_polygons_session)

		# marker clustering layer
		markers = new L.MarkerClusterGroup
			singleMarkerMode: true
			disableClusteringAtZoom: 19
			iconCreateFunction: (c) ->
				count = 0
				for child in c.getAllChildMarkers()
					count = count + child.options.flag_count
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
		
		p = @

		markers.on("click", (e) ->
			console.log "click:", e.layer
			p.resetSheet()
			p.map.fitBounds(e.layer.options.bounds)
			p.getPolygons(e.layer.options.sheet_id)
		)

		counts = data.counts
		@addMarker markers, count for count in counts

		markers.addTo @map
		@

	addMarker: (markers, data) ->
		# console.log data

		bbox = data.bbox.split ","
		
		W = parseFloat(bbox[0])
		S = parseFloat(bbox[1])
		E = parseFloat(bbox[2])
		N = parseFloat(bbox[3])

		SW = new L.LatLng(S, W)
		NW = new L.LatLng(N, W)
		NE = new L.LatLng(N, E)
		SE = new L.LatLng(S, E)

		bounds = new L.LatLngBounds(SW, NE)
		latlng = bounds.getCenter()

		markers.addLayer new L.InspectorMarker latlng,
			flag_count: data.flag_count
			sheet_id: data.id
			bounds: bounds
		@

	getPolygons: (sheet_id) =>
		p = @
		no_color = '#AF2228'
		yes_color = '#609846'
		fix_color = '#FFB92D'
		$.getJSON('/fixer/sheet.json?id=' + sheet_id, (data) ->
			return if data.fix_poly.features.length==0 && data.no_poly.features.length==0 && data.yes_poly.features.length==0

			m = p.sheet

			yes_json = L.geoJson(data.yes_poly,
				style: (feature) ->
					fillColor: yes_color
					opacity: 0
					fillOpacity: 0.9
					stroke: false
			)
			no_json = L.geoJson(data.no_poly,
				style: (feature) ->
					fillColor: no_color
					opacity: 0
					fillOpacity: 0.9
					stroke: false
			)
			fix_json = L.geoJson(data.fix_poly,
				style: (feature) ->
					fillColor: fix_color
					opacity: 0
					fillOpacity: 0.9
					stroke: false
			)

			yes_json.addTo(m)

			no_json.addTo(m)

			fix_json.addTo(m)
		)
	
	updateScore: (current) =>
		# mapScore = if total > 0 then Math.round(current*100/total) else 0

		# mapDOM = $("#map-bar")
		# mapDOM.find(".bar").css("width", mapScore + "%")
		$("#score .total").text(current)
		# $("#map-total").text("of " + total.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + " shapes")

		url = $('#progressjs').data("server")
		tweet = current + " buildings checked! Data mining old maps with the Building Inspector from @NYPLMaps @nypl_labs"
		twitterurl = "https://twitter.com/share?url=" + url + "&text=" + tweet

		$("#tweet").show()

		$("#tweet").attr "href", twitterurl

	onMapClick: (e) =>
		@popup
			.setLatLng(e.latlng)
			.setContent("You clicked the map at " + e.latlng.toString())
			.openOn(@map)

$ ->
	window._progress = new Progress()
