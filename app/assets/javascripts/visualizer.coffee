class Visualizer

	constructor: () ->
		@map = L.mapbox.map('map', 'https://s3.amazonaws.com/maptiles.nypl.org/859-final/859spec.json', 
			animate: true
			attributionControl: true
			minZoom: 13
			maxZoom: 21
		)

		@no_color = '#AF2228'
		@yes_color = '#609846'
		@fix_color = '#FFB92D'
		@nil_color = '#AAAAAA'

		@resetSheet()

		s = @
		@map.on
			load: () ->
				s.getSheets()

	resetSheet: () ->
		@map.removeLayer @sheet if @map.hasLayer @sheet
		@sheet = L.geoJson({features:[]},
			style: (feature) ->
				color: @nil_color
				opacity: 0
				fillOpacity: 0.5
				stroke: false
		).addTo @map

	getSheets: () ->
		data = $('#vizdata').data("map")

		@geo = L.geoJson({features:[]},
			style: (feature) ->
				color: '#fff'
				weight: 1
				stroke: false
				fillOpacity: 0.005
			onEachFeature: @onEachFeature
		)

		@parse sheet for sheet in data

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
		@map.panTo(l.getBounds().getCenter())
		@startPlayback()

	getPolygons: () ->
		v = @
		$.getJSON('/viz/sheet/' + @sheet_id + '.json', (data) ->
			v.processPolygons(data)
		)

	processPolygons: (data) ->
		return if data.polygons.length==0

		m = @map

		for polygon in data.polygons
			json = 
				type : "Feature"
				properties:
					id: polygon.id
				geometry:
					type: "Polygon"
					coordinates: $.parseJSON(polygon.geometry)

			@sheet.addData json

		@map.fitBounds(@sheet.getBounds())

	stopPlayback: () ->
		@resetSheet()

	startPlayback: () ->
		@resetSheet()
		@getPolygons()

$ ->
	window._viz = new Visualizer







