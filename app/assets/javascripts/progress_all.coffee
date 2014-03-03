class Progress

	_SW: new L.LatLng(40.62563874006115,-74.13093566894531)
	_NE: new L.LatLng(40.81640757520087,-73.83087158203125)

	constructor: () ->
		$("#map-tutorial").hide()
		$("#map-about").hide()
		$("#tweet").hide()
		@ids = []
		bounds = new L.LatLngBounds(@_SW, @_NE).pad(1)
		@map = L.mapbox.map('map', 'nypllabs.g6ei9mm0', #'https://s3.amazonaws.com/maptiles.nypl.org/859-final/859spec.json', 
			zoomControl: false
			animate: true
			scrollWheelZoom: true
			attributionControl: false
			minZoom: 12
			maxZoom: 20
			dragging: true
			maxBounds: bounds
		)

		@addEventListeners()

		@overlay = L.mapbox.tileLayer('https://s3.amazonaws.com/maptiles.nypl.org/859-final/859spec.json',
			zIndex: 2
		).addTo(@map)

		@overlay2 = L.mapbox.tileLayer('https://s3.amazonaws.com/maptiles.nypl.org/860/860spec.json',
			zIndex: 3
		).addTo(@map)

		# @attributionControl = L.control.attribution(
		# 	position: 'bottomright'
		# 	prefix: "From: <a href='http://digitalcollections.nypl.org/search/index?filters[title_uuid_s][]=Maps%20of%20the%20city%20of%20New%20York.||06fd4630-c603-012f-17f8-58d385a7bc34&keywords=&layout=false%22%3E'>NYPL Digital Collections</a> | <a href='http://maps.nypl.org/warper/layers/859/'>Warper</a>"
		# ).addTo(@map)

		@zoomControl = L.control.zoom(
			position: 'topright'
		).addTo(@map)

		L.InspectorMarker = L.Marker.extend
			options:
				polygon_count: 0
				sheet_id: 0
				bounds: []

		# @map.on('load', @getPolygons)
		@no_color = '#AF2228'
		@yes_color = '#609846'
		@fix_color = '#FFB92D'
		@nil_color = '#AAAAAA'

		@resetSheet()

		window.map = @

	addEventListeners: () =>
		p = @

		@map.on('load', @getCounts)


	resetSheet: () ->
		# console.log "reset"
		@map.removeLayer @sheet if @map.hasLayer @sheet
		@sheet = L.geoJson({features:[]},
			style: (feature) ->
				color: @nil_color
				opacity: 0
				fillOpacity: 0.5
				stroke: false
		).addTo @map

	getCounts: () =>
		$("#loader").remove()
		data = $('#progressjs').data("progress")

		# console.log data

		bounds = new L.LatLngBounds(@_SW, @_NE)
		@map.fitBounds bounds

		# marker clustering layer
		markers = new L.MarkerClusterGroup
			singleMarkerMode: true
			disableClusteringAtZoom: 19
			iconCreateFunction: (c) ->
				count = 0
				for child in c.getAllChildMarkers()
					count = count + parseInt(child.options.polygon_count)
				c = 'cluster-large'
				if count < 10
					c = 'cluster-small'
				else if count < 30
					c = 'cluster-medium'
				new L.DivIcon
					html: Humanize.compactInteger(count)
					className: c
					iconSize: L.point(30, 30)
			polygonOptions:
				stroke: false

		p = @

		markers.on("click", (e) ->
			p.resetSheet()
			p.getPolygons(e)
		)

		markers.on("clusterclick", (e) ->
			p.resetSheet()
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
			polygon_count: data.polygon_count
			sheet_id: data.sheet_id
			bounds: bounds
		@

	getPolygons: (e) ->
		v = @
		el = $(e.originalEvent.target)
		sheet_id = e.layer.options.sheet_id
		console.log sheet_id
		# spinner available in general.coffee
		spinner_xy = @map.layerPointToContainerPoint(e.layer.getLatLng())
		el.append(_gen._spinner().el)
		$.getJSON('/fixer/progress_sheet.json?id=' + sheet_id, (data) ->
			v.processPolygons(data)
			el.find('.spinner').remove()
		)

	processPolygons: (data) ->
		no_color = '#AF2228'
		yes_color = '#609846'
		fix_color = '#FFB92D'
		nil_color = '#908b85'

		# console.log data

		return if data.nil_poly.features.length==0 && data.fix_poly.features.length==0 && data.no_poly.features.length==0 && data.yes_poly.features.length==0

		m = @sheet

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
		nil_json = L.geoJson(data.nil_poly,
			style: (feature) ->
				fillColor: nil_color
				opacity: 0
				fillOpacity: 0.9
				stroke: false
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

		if data.nil_poly.features.length>0
			nil_json.addTo(m)
			bounds.extend(nil_json.getBounds())

		@map.fitBounds(bounds)

$ ->
	window._progress = new Progress()
