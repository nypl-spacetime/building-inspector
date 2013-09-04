class TagBuilding

	polyData: {}
	currentIndex: -1
	currentPolygon: {}
	geo: {}
	popup: L.popup()
	verticalOffset: 100 # pixels to offset the polygon from the center
	tutorialData: {"bbox":"","created_at":"2013-08-28T21:52:04Z","id":2,"map_id":0,"map_url":null,"poly":[{"color":"8","dn":1058779,"geometry":"[[[-74.01163643996117,40.705373592435315],[-74.01183581692376,40.70540152623571],[-74.01188510664997,40.70541321141552],[-74.01189170388928,40.70544866432337],[-74.01196522541925,40.705463218963914],[-74.01196496323853,40.705487611615474],[-74.01160640667229,40.705433975879856],[-74.01160121208241,40.705421779545375],[-74.01160962560948,40.705373009493144],[-74.01161239438042,40.705367497538276],[-74.01163643996117,40.705373592435315]]]","id":419,"sheet_id":2,"status":"unprocessed"},{"color":"8","dn":1065840,"geometry":"[[[-74.01579039224629,40.705372213310966],[-74.01580960069501,40.705351195722685],[-74.01589283730611,40.705368009793844],[-74.01587683026551,40.705431062522855],[-74.01579199295034,40.70541214671042],[-74.01578078802191,40.70539743440814],[-74.01579039224629,40.705372213310966]]]","id":421,"sheet_id":2,"status":"unprocessed"},{"color":"3","dn":111187,"geometry":"[[[-74.01507954408987,40.707671439581645],[-74.01513731790827,40.70769094531328],[-74.0151637287967,40.70768227609993],[-74.01516868083827,40.70767577418917],[-74.0152099478514,40.707686610706745],[-74.01520829717089,40.70770611643395],[-74.01518518764352,40.70775379707638],[-74.01511090701986,40.70772995675943],[-74.01511420838091,40.707712618341745],[-74.0151059549783,40.707697447222564],[-74.01506303728462,40.70768010879641],[-74.01506798932618,40.707669272277776],[-74.01507954408987,40.707671439581645]]]","id":425,"sheet_id":2,"status":"unprocessed"},{"color":"1","dn":1061017,"geometry":"[[[-74.01477946440741,40.705406511119115],[-74.01479858641775,40.70536302347714],[-74.0149859821192,40.705403611943865],[-74.0149974553254,40.705406511119115],[-74.01497833331506,40.705455797079026],[-74.0148062352219,40.70542100699346],[-74.01478328880948,40.705415208644105],[-74.01477946440741,40.705406511119115]]]","id":420,"sheet_id":2,"status":"unprocessed"},{"color":"8","dn":1084906,"geometry":"[[[-74.01218063467412,40.70530959781626],[-74.01237860048177,40.705338457947015],[-74.01235195123843,40.70539040615086],[-74.01218824874364,40.70536443205401],[-74.01218824874364,40.705344229971665],[-74.01218063467412,40.70533268592187],[-74.0121615995003,40.70532979990911],[-74.01216540653506,40.70530671180249],[-74.01218063467412,40.70530959781626]]]","id":422,"sheet_id":2,"status":"unprocessed"},{"color":"8","dn":1084908,"geometry":"[[[-74.01210331972014,40.70530940116011],[-74.01215179979313,40.70531708427822],[-74.01214960863193,40.70534840438459],[-74.01216152153533,40.70536626850229],[-74.01234575499734,40.70539547617312],[-74.01233925846931,40.705417901045266],[-74.01229329539613,40.705499081349956],[-74.01225769071061,40.70550198650754],[-74.012200886164,40.70549666012733],[-74.01216052892464,40.70551643501909],[-74.01202666820885,40.70550483680538],[-74.0120313730737,40.705452900888396],[-74.01205111348513,40.70543170692489],[-74.0120742171671,40.70534770698183],[-74.01209909483936,40.70533536399502],[-74.01210331972014,40.70530940116011]]]","id":423,"sheet_id":2,"status":"unprocessed"},{"color":"12","dn":1095137,"geometry":"[[[-74.01526920828162,40.70529397340648],[-74.0152843755366,40.70528580235537],[-74.01530650551032,40.70529102252848],[-74.01533344245212,40.705288607785036],[-74.01533832512614,40.70531404464626],[-74.01537671608041,40.70532813955143],[-74.01527799547016,40.705309653439734],[-74.01526920828162,40.70529397340648]]]","id":424,"sheet_id":2,"status":"unprocessed"},{"color":"1","dn":1123405,"geometry":"[[[-74.01426264621155,40.705227354983],[-74.01445521173025,40.70526780987857],[-74.01445906304062,40.705272866738795],[-74.0144475091095,40.70529815103412],[-74.01446291435099,40.70531837846347],[-74.01454764317923,40.70533860588669],[-74.01454764317923,40.70535883330374],[-74.0145091300755,40.70543974291057],[-74.01434352372941,40.70539423126883],[-74.0143281184879,40.70539423126883],[-74.01430501062566,40.70538411756644],[-74.01434352372941,40.70529309417582],[-74.0143281184879,40.70528298045807],[-74.01422413310782,40.705257696156984],[-74.01424338965967,40.70522229811933],[-74.01426264621155,40.705227354983]]]","id":426,"sheet_id":2,"status":"unprocessed"},{"color":"3","dn":1123406,"geometry":"[[[-74.01492649669149,40.705240056333196],[-74.0151759806247,40.70528872513145],[-74.01518601031545,40.70529751268902],[-74.01517914846488,40.7053240601134],[-74.01516776735902,40.70533777152381],[-74.01516495370541,40.70536096577319],[-74.01517905073042,40.70537946324473],[-74.01519178771785,40.705382659711894],[-74.01517238043762,40.7054301567037],[-74.01516259034452,40.70543724139148],[-74.0151137524325,40.70542588737818],[-74.01510498433365,40.705419233972385],[-74.01494413439816,40.705391105915915],[-74.01487095746583,40.7053678030157],[-74.01484035853366,40.70536800142054],[-74.0148054369198,40.705360502748455],[-74.01480409461165,40.7053480352169],[-74.0148355320005,40.70528913828501],[-74.01485297668582,40.705231884859536],[-74.01486532635015,40.70522589634643],[-74.01492649669149,40.705240056333196]]]","id":427,"sheet_id":2,"status":"unprocessed"},{"color":"12","dn":1178378,"geometry":"[[[-74.01592715941025,40.705047653818774],[-74.01633448215934,40.70516404836582],[-74.01644220387811,40.70519646200094],[-74.01644108177686,40.70520088204088],[-74.01641639554964,40.70519793534761],[-74.01628847600861,40.70515962832344],[-74.01627501079376,40.70515078823782],[-74.01611455031686,40.70510806114074],[-74.01603600323025,40.705081540859794],[-74.01596082244737,40.70506533401624],[-74.01591706049912,40.705049127168756],[-74.01592715941025,40.705047653818774]]]","id":428,"sheet_id":2,"status":"unprocessed"}],"status":"unprocessed","updated_at":"2013-08-28T21:52:04Z"}
	loadedData: {}
	tutorialOn: $('#tagbuildingjs').data("session")

	constructor: () ->
		$("#map-tutorial").hide()
		$("#buttons").hide()
		@map = L.mapbox.map('map', 'nypllabs.polygonfixer', 
			zoomControl: false
			animate: true
			attributionControl: false
			minZoom: 19
			maxZoom: 19
			# dragging: false
		)

		@map.on('load', @getPolygons)

		$("#link-help").on("click", @invokeTutorial)

		# @map.on('click', @onMapClick)

		window.map = @map

		tagger = @

		@tID = window.setTimeout(
				() ->
					tagger.invokeTutorial()
				, 1000
		) if @tutorialOn
		# console.log @tutorialOn

	invokeTutorial: () =>
		$("#map-tutorial").show()
		$("#map-container").hide()
		$("#link-help").hide()
		$("#buttons").hide()
		$("#map-tutorial").swipeshow
			mouse: true
			autostart: false
		.goTo 0

		fixer = @
		$("#link-exit-tutorial").click () ->
			fixer.hideTutorial()

		# @polyData = @tutorialData
		# @tutorialOn = true
		# @currentIndex = -1
		# @showNextPolygon()
		# introJs().setOptions(
		# 	exitOnOverlayClick: false
		# 	skipLabel: "Exit tutorial"
		# 	steps: [
		# 			{
		# 				element: "#map-tutorial"
		# 				intro: "Polygons show up here"
		# 			}
		# 			{
		# 				element: "#yes-button"
		# 				intro: "This building looks OK. Press YES to tag it as correct and continue to the next one."
		# 			}
		# 			{
		# 				element: "#fix-button"
		# 				intro: "This building needs fixing. Press FIX to indicate so."
		# 			}
		# 			{
		# 				element: "#no-button"
		# 				intro: "This is not a building (it is empty space between buildings). Press NO to indicate so."
		# 			}
		# 			{
		# 				element: "#yes-button"
		# 				intro: "It doesn't matter if buildings have two colors but their polygon is correct. Press YES."
		# 			}
		# 	]
		# )
		# .onexit( () ->
		# 	$("#map-tutorial").hide()
		# 	# console.log "end of tutorial"
		# )
		# .start()

	hideTutorial: () =>
		$("#map-tutorial").hide()
		$("#map-container").show()
		$("#link-help").show()
		$("#buttons").show()

	getPolygons: () =>
		tagger = @
		$.getJSON('/fixer/map.json', (data) ->
			# console.log(data);
			tagger.polyData = tagger.loadedData = data
			$("#yes-button").on("click", tagger.submitYesFlag)
			$("#no-button").on("click", tagger.submitNoFlag)
			$("#fix-button").on("click", tagger.submitFixFlag)
			tagger.showNextPolygon()
		)
	
	submitYesFlag: () =>
		@submitFlag("yes")

	submitNoFlag: () =>
		@submitFlag("no")

	submitFixFlag: () =>
		@submitFlag("fix")

	submitFlag: (type) =>
		$("#buttons").hide()
		if @tutorialOn
			# do not submit the data
			@showNextPolygon()
			return
		tagger = @
		$.get("/fixer/flag", 
			i: @currentPolygon.id
			f: type
			, () ->
				tagger.showNextPolygon()
		# ).done( () ->
		# 	tagger.showNextPolygon()
		# ).fail( () ->
		# 	tagger.showNextPolygon()
		)

	showNextPolygon: () =>
		# console.log @polyData
		@currentIndex++
		@map.removeLayer(@geo)
		if @currentIndex < @polyData.poly.length
			$("#buttons").show()
			@currentPolygon = @polyData.poly[@currentIndex]
			@geo = @makePolygon(@currentPolygon)
			# console.log @currentPolygon #, @currentGeo
			# console.log @geo
			# center on the polygon
			@geo.addTo(@map)
			@map.fitBounds( @geo.getBounds() )

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
	window._is_building = new TagBuilding()
