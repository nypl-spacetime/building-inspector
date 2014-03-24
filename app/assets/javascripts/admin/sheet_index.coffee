class Sheet
	constructor: () ->
		@map = L.mapbox.map('map', 'https://s3.amazonaws.com/maptiles.nypl.org/859-final/859spec.json', 
			animate: true
			minZoom: 13
			maxZoom: 21
		)

		@overlay2 = L.mapbox.tileLayer('https://s3.amazonaws.com/maptiles.nypl.org/860/860spec.json',
			zIndex: 3
		).addTo(@map)

		s = @

		@map.on
			load: () ->
				s.getSheets()
			moveend: () ->
				if s.wasClick
					s.wasClick = false
					window.location.href = "/sheets/" + s.sheet_id
					console.log "end move"

	getSheets: () ->
		data = $('#sheetdata').data("map")

		@geo = L.geoJson({features:[]},
			style: (feature) ->
				color: '#00b'
				weight: 1
				stroke: false
				fillOpacity: 0.05
			onEachFeature: @onEachFeature
		)

		@parse sheet for sheet in data


		_SW = new L.LatLng(40.62563874006115,-74.13093566894531)
		_NE = new L.LatLng(40.81640757520087,-73.83087158203125)
		bounds = new L.LatLngBounds(_SW, _NE)
		
		@map.fitBounds bounds

		@geo.addTo @map

	parse: (sheet) ->
		# define rectangle geographical bounds
		# data comes: W, S, E, N
		bbox = sheet["bbox"].split ","
		
		W = parseFloat(bbox[0])
		S = parseFloat(bbox[1])
		E = parseFloat(bbox[2])
		N = parseFloat(bbox[3])

		SW = new L.LatLng(S, W)
		NW = new L.LatLng(N, W)
		NE = new L.LatLng(N, E)
		SE = new L.LatLng(S, E)

		bounds = new L.LatLngBounds(SW, NE)

		json = 
			type : "Feature"
			properties:
				id: sheet.id
				map_id: sheet.map_id
			geometry:
				type: "Polygon"
				coordinates: [[[W,S],[W,N],[E,N],[E,S]]]
		@geo.addData json

	onEachFeature: (f,l) =>
		s = @

		l.on
			mouseover: s.highlightFeature
			mouseout: s.resetHighlight
			click: s.zoomToFeature

	highlightFeature: (e) =>
		l = e.target

		$("#info").text("Sheet: " + l.feature.properties.map_id)

		l.setStyle
			weight: 1
			stroke: true
			color: '#b00'
			fillOpacity: 0.1
		
		l.bringToFront()

	resetHighlight: (e) =>
		$("#info").text("")
		@geo.resetStyle(e.target)

	zoomToFeature: (e) =>
		l = e.target
		@sheet_id = l.feature.properties.id
		@wasClick = true
		@map.fitBounds(l.getBounds())

$ ->
	window._s = new Sheet