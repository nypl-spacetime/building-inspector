class Progress

	constructor: () ->
		$("#map-tutorial").hide()
		$("#map-about").hide()
		$("#tweet").hide()
		@ids = []
		NW = new L.LatLng(40.65563874006115,-74.13093566894531)
		SE = new L.LatLng(40.81640757520087,-73.83087158203125)
		@map = L.mapbox.map('map', 'nypllabs.g6ei9mm0', 
			zoomControl: false
			animate: true
			scrollWheelZoom: true
			attributionControl: true
			minZoom: 12
			maxZoom: 20
			dragging: true
			maxBounds: new L.LatLngBounds(NW, SE)
		)


		overlay = L.mapbox.tileLayer('https://s3.amazonaws.com/maptiles.nypl.org/859-final/859spec.json',
			zIndex: 2
		).addTo(@map)

		overlay2 = L.mapbox.tileLayer('https://s3.amazonaws.com/maptiles.nypl.org/860/860spec.json',
			zIndex: 3
		).addTo(@map)

		L.control.zoom(
			position: 'topright'
		).addTo(@map)

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

	clearTimers: () ->
		# console.log "clear"
		clearTimeout id for id in @ids

	resetSheet: () ->
		@clearTimers()
		@map.off 'moveend', @applyHighlights
		$(".polygon-highlight").remove()
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

		NW = new L.LatLng(40.65563874006115,-74.13093566894531)
		SE = new L.LatLng(40.81640757520087,-73.83087158203125)
		bounds = new L.LatLngBounds(NW, SE)
		@map.fitBounds bounds

		@updateScore(data.all_polygons_session)

		# marker clustering layer
		markers = new L.MarkerClusterGroup
			singleMarkerMode: true
			disableClusteringAtZoom: 19
			iconCreateFunction: (c) ->
				count = 0
				for child in c.getAllChildMarkers()
					count = count + parseInt(child.options.flag_count)
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
			# console.log "click:", e.layer
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
			flag_count: data.flag_count
			sheet_id: data.id
			bounds: bounds
		@

	getPolygons: (e) =>
		p = @
		no_color = '#AF2228'
		yes_color = '#609846'
		fix_color = '#FFB92D'

		el = $(e.originalEvent.target)
		sheet_id = e.layer.options.sheet_id

		# spinner available in general.coffee
		spinner_xy = @map.layerPointToContainerPoint(e.layer.getLatLng())
		el.append(_gen._spinner().el)

		$.getJSON('/fixer/sheet.json?id=' + sheet_id, (data) ->
			p.map.off 'moveend', p.applyHighlights
			el.find('.spinner').remove()

			return if data.fix_poly.features.length==0 && data.no_poly.features.length==0 && data.yes_poly.features.length==0

			m = p.sheet

			p.highlights = []

			yes_json = L.geoJson(data.yes_poly,
				style: (feature) ->
					fillColor: yes_color
					opacity: 0
					fillOpacity: 0.9
					stroke: false
				onEachFeature: (f, l) ->
					p.highlights.push(l)
			)
			no_json = L.geoJson(data.no_poly,
				style: (feature) ->
					fillColor: no_color
					opacity: 0
					fillOpacity: 0.9
					stroke: false
				onEachFeature: (f, l) ->
					p.highlights.push(l)
			)
			fix_json = L.geoJson(data.fix_poly,
				style: (feature) ->
					fillColor: fix_color
					opacity: 0
					fillOpacity: 0.9
					stroke: false
				onEachFeature: (f, l) ->
					p.highlights.push(l)
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

			p.map.fitBounds(bounds)

			p.map.on 'moveend', p.applyHighlights
		)

	applyHighlights: (e) =>
		@map.off 'moveend', @applyHighlights
		@map.panBy [0, 20]
		@ids = (setTimeout @showHighlight, i*30, poly for poly, i in @highlights)
		# console.log @ids

	showHighlight: (polygon) =>
		point = @map.latLngToContainerPoint polygon.getBounds().getCenter()
		# console.log "highlighting:", point
		elem = $('<div><div class="polygon-highlight"></div></div>')
		elem.css("position", "absolute")
		elem.css("top", point.y)
		elem.css("left", point.x)
		$("#map-container").append(elem)
		setTimeout @killHighlight, 10, elem
		@

	killHighlight: (elem) =>
		elem.find(".polygon-highlight").addClass("scaled")
		elem.fadeOut 500, () -> 
			$(@).remove()

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


$ ->
	window._progress = new Progress()
