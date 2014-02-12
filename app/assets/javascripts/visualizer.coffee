class Visualizer

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


		@no_color = '#AF2228'
		@yes_color = '#609846'
		@fix_color = '#FFB92D'
		@nil_color = '#AAAAAA'

		v = @
		@map.on 'load', () ->
			v.getPolygons()

	getPolygons: () =>
		data = $('#vizdata').data("map")

		no_color = '#AF2228'
		yes_color = '#609846'
		fix_color = '#FFB92D'
		nil_color = '#AAAAAA'

		console.log data

		return if data.poly.features.length==0

		m = @map

		p_json = L.geoJson(data.poly,
			style: (feature) ->
				color: fix_color
				fillColor: false
				stroke: false
				opacity: 0
				fillOpacity: 0.7
			onEachFeature: (f,l) ->
				out = for key, val of f.properties
					val = "<a href='/polygons/#{val}'>#{val}</a>" if key == "id"
					"<strong>#{key}:</strong> #{val}"
				l.bindPopup(out.join("<br />"))
				l.on 'click', ()->
					m.fitBounds(@.getBounds())
		)

		bounds = new L.LatLngBounds()

		if data.poly.features.length>0
			p_json.addTo(m)
			bounds.extend(p_json.getBounds())

		m.fitBounds(bounds)

$ ->
	window._viz = new Visualizer







