class Status

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

		@addEventListeners()

		window.map = @

	addEventListeners: () =>
		p = @

		@map.on('load', @getPolygons)

	getPolygons: () =>
		p = @
		$.getJSON('/fixer/allPolygons.json', (data) ->
			# console.log(data[0])
			# p.updateScore(data.length)

			m = p.map
			color = '#009900'

			geo = L.geoJson({features:[]},
				style: (feature) ->
					fillColor: color
					opacity: 0
					fillOpacity: 0.7
					stroke: false
				onEachFeature: (f,l) ->
					out = for key, val of f.properties
						"<strong>#{key}:</strong> #{val}"
					l.bindPopup(out.join("<br />"))
					l.on 'click', ()->
						m.fitBounds(@.getBounds())
			)

			for poly in data
				geo.addData p.makePolygon(poly)

			# console.log geo

			geo.addTo(m)
		)
	
	makePolygon: (poly) ->
		json = 
			type : "Feature"
			properties:
				DN: poly.dn
				id: poly.id
				sheet_id: poly.sheet_id
				status: poly.status
			geometry:
				type: "Polygon"
				coordinates: $.parseJSON(poly.geometry)
		json

	updateScore: (total) =>
		mapScore = if total > 0 then Math.round(current*100/total) else 0

		mapDOM = $("#map-bar")
		mapDOM.find(".bar").css("width", mapScore + "%")
		$("#score .total").text(current)
		$("#map-total").text(total + " shapes")

		url = $('#progressjs').data("server")
		tweet = current + " buildings checked! Data mining old maps with the Building Inspector from @NYPLMaps + @nypl_labs"
		twitterurl = "https://twitter.com/share?url=" + url + "&text=" + tweet


		$("#tweet").attr "href", twitterurl

	onMapClick: (e) =>
		@popup
			.setLatLng(e.latlng)
			.setContent("You clicked the map at " + e.latlng.toString())
			.openOn(@map)

$ ->
	window._status = new Status()
