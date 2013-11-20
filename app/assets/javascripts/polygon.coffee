class Polygon
	constructor: () ->
		@map = L.mapbox.map('map', 'https://s3.amazonaws.com/maptiles.nypl.org/859-final/859spec.json', 
			animate: true
			attributionControl: true
			minZoom: 16
			maxZoom: 21
		)

		@overlay2 = L.mapbox.tileLayer('https://s3.amazonaws.com/maptiles.nypl.org/860/860spec.json',
			zIndex: 3
		).addTo(@map)

		p = @
		@map.on 'load', () ->
			p.showPolygon()

	showPolygon: () =>
		data = $('#polydata').data("map")

		m = @map

		console.log data

		json = L.geoJson(data,
			style: (feature) ->
				color: '#b00'
				weight: 5
				opacity: 1
				dashArray: '1,16'
				fill: false
		)

		bounds = new L.LatLngBounds()

		if data.features.length>0
			json.addTo(m)
			bounds.extend(json.getBounds())

		m.fitBounds(bounds)

$ ->
	window._p = new Polygon