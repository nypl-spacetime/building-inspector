class TagBuilding

	polyData: {}
	_polyData: {}
	currentIndex: -1
	_currentIndex: -1
	currentPolygon: {}
	_currentPolygon: {}
	geo: {}
	popup: L.popup()
	verticalOffset: 100 # pixels to offset the polygon from the center
	loadedData: {}
	tutorialOn: $('#tagbuildingjs').data("session")
	mapPolygons: 0
	mapPolygonsSession: 0
	allPolygons: 0
	allPolygonsSession: 0
	level: 0
	firstLoad: true
	tutorialData: {"bbox":"","created_at":"2013-08-28T21:52:04Z","id":2,"map_id":0,"map_url":null,"poly":[{"color":"8","dn":1058779,"geometry":"[[[-73.98395996633302,40.756224369909674],[-73.98396392100888,40.75621918130276],[-73.98397380769846,40.756221775606264],[-73.98401928647063,40.75624512433331],[-73.98394217029175,40.75635149065273],[-73.98393030626423,40.75635667924933],[-73.98388087281621,40.75633333056147],[-73.98395996633302,40.756224369909674]]]","id":1488,"sheet_id":2,"status":"unprocessed"},{"color":"8","dn":1065840,"geometry":"[[[-73.98365637745785,40.756781647437],[-73.98369123618313,40.75677946958463],[-73.98369621600102,40.75677293602709],[-73.98370949551541,40.75677729173219],[-73.98364475788276,40.75686222792444],[-73.98363479824697,40.756879650719696],[-73.98364143800416,40.75689707351037],[-73.98363479824697,40.756905784904],[-73.9835800202501,40.75688182856877],[-73.98365637745785,40.756781647437]]]","id":2101,"sheet_id":2,"status":"unprocessed"},{"color":"3","dn":111187,"geometry":"[[[-74.00221835769625,40.70964367838799],[-74.0023501667551,40.70970475730078],[-74.00234629001807,40.709720027020225],[-74.00231527612186,40.70976074625494],[-74.00231527612186,40.70977092605974],[-74.00228038548865,40.70981673516205],[-74.00228038548865,40.709826914958285],[-74.00206328821527,40.709745476544846],[-74.00204778126715,40.709735296736156],[-74.00209430211146,40.70966403803181],[-74.00212919274469,40.709679307760595],[-74.00215632990384,40.70967421785139],[-74.00217183685194,40.70964367838799],[-74.00218734380005,40.70963349856375],[-74.00221835769625,40.70964367838799]]]","id":69407,"sheet_id":2,"status":"unprocessed"},{"color":"1","dn":1061017,"geometry":"[[[-74.00108703742951,40.70813220875797],[-74.0011494290151,40.70810148946914],[-74.00116502691151,40.70812196899659],[-74.0011767253338,40.708127088877475],[-74.00123131797122,40.70819876716846],[-74.0012547148158,40.70821924666601],[-74.00128201113452,40.708224366539405],[-74.00129760903091,40.708244846029075],[-74.00130930745321,40.708249965900514],[-74.00130930745321,40.70827044538231],[-74.00132880482371,40.708285804989515],[-74.0013366037719,40.708285804989515],[-74.00133270429781,40.7082909248578],[-74.00124691586761,40.7083318837899],[-74.00123131797122,40.708311404327],[-74.0012040216525,40.70830628446029],[-74.0011767253338,40.70832164405924],[-74.00116502691151,40.70830628446029],[-74.00113773059282,40.70830116459319],[-74.0010246458439,40.70816292803262],[-74.00108703742951,40.70813220875797]]]","id":69664,"sheet_id":2,"status":"unprocessed"},{"color":"8","dn":1084906,"geometry":"[[[-74.00348923441064,40.70902308140003],[-74.00350806906381,40.709031324381094],[-74.00353946015244,40.709072539271126],[-74.00355829480561,40.709080782246076],[-74.00358968589426,40.7091219971055],[-74.00360852054742,40.70913024007433],[-74.00363991163604,40.70917145490314],[-74.00365874628923,40.70917969786584],[-74.00369013737786,40.70922091266405],[-74.00370897203103,40.70922915562063],[-74.00374036311966,40.709270370388225],[-74.00373408490194,40.70927861333868],[-74.00358968589426,40.70935279984689],[-74.00351434728154,40.709402257473116],[-74.00347667797517,40.70941874334035],[-74.00345156510427,40.70941874334035],[-74.00342645223337,40.70938577160178],[-74.0034829561929,40.709361042787144],[-74.00349551262836,40.70932807102001],[-74.00346412153974,40.70928685628812],[-74.00344528688655,40.70927861333868],[-74.00341389579793,40.709237398576185],[-74.00339506114474,40.70922915562063],[-74.00336367005612,40.709187940827526],[-74.00334483540294,40.70917969786584],[-74.00331972253203,40.70914672600892],[-74.00330088787885,40.70913848304213],[-74.00328205322567,40.70911375413566],[-74.00333227896749,40.709080782246076],[-74.00341389579793,40.70903956736114],[-74.00347039975746,40.70901483841793],[-74.0034829561929,40.70901483841793],[-74.00348923441064,40.70902308140003]]]","id":69495,"sheet_id":2,"status":"unprocessed"},{"color":"8","dn":1084908,"geometry":"[[[-73.98418800995374,40.75712235765245],[-73.98420131681875,40.75710988721315],[-73.98424694035592,40.7571298399149],[-73.98415759426229,40.757252050082506],[-73.9841100697444,40.7572345915009],[-73.98418800995374,40.75712235765245]]]","id":2018,"sheet_id":2,"status":"unprocessed"},{"color":"12","dn":1095137,"geometry":"[[[-74.00454310505249,40.70815510738579],[-74.00458593251801,40.708203804863125],[-74.00438607101226,40.70828496724622],[-74.00437179519042,40.70830661053167],[-74.00448600176513,40.70845270252448],[-74.00441462265594,40.708479756562056],[-74.00425758861572,40.70829037806824],[-74.00427186443756,40.70826873477752],[-74.00426472652664,40.708257913129515],[-74.00427186443756,40.70825250230486],[-74.00437893310134,40.708214626519926],[-74.00439320892318,40.708203804863125],[-74.00440748474503,40.708203804863125],[-74.00442176056686,40.708192983204576],[-74.00454310505249,40.70814969655278],[-74.00454310505249,40.70815510738579]]]","id":69655,"sheet_id":2,"status":"unprocessed"},{"color":"1","dn":1123405,"geometry":"[[[-74.00501889557988,40.70880948768108],[-74.00505393966343,40.70879798486693],[-74.0050911740022,40.70884687181333],[-74.00490938281875,40.70891301291898],[-74.00488967052176,40.70891013722009],[-74.00487214847999,40.70889863442333],[-74.00491157307398,40.70889288302421],[-74.00492252435009,40.708872753123366],[-74.00491376332921,40.70886700172199],[-74.00490938281875,40.70884974751494],[-74.00501889557988,40.70880948768108]]]","id":69530,"sheet_id":2,"status":"unprocessed"},{"color":"3","dn":1123406,"geometry":"[[[-74.00425213504737,40.70791363421757],[-74.00427097013254,40.707907923086026],[-74.00427473714957,40.70791648978315],[-74.00424836803033,40.707925056479176],[-74.00422953294517,40.707939334303425],[-74.0042332999622,40.70796503437937],[-74.00420693084297,40.707996445569826],[-74.00418432874076,40.70800786781724],[-74.00417302768966,40.70797931219506],[-74.00415042558745,40.70797360106915],[-74.00413159050228,40.70797645663216],[-74.00410898840008,40.70799359000767],[-74.00410898840008,40.70800786781724],[-74.00413912453637,40.70805355678725],[-74.00413535751933,40.70805070122754],[-74.00410522138306,40.70806212346564],[-74.00409768734899,40.70807640126051],[-74.00410145436602,40.70809067905231],[-74.00414665857043,40.70813065685308],[-74.00418056172373,40.70814779018892],[-74.00418056172373,40.70816206796541],[-74.00419562979185,40.70817349018441],[-74.00421446487702,40.708176345738856],[-74.00421069786,40.70819347906294],[-74.00419186277483,40.708202045723326],[-74.0041767947067,40.708196334616524],[-74.00401857999128,40.70800786781724],[-74.0041993968089,40.707936478738816],[-74.00421069786,40.70791648978315],[-74.00423706697923,40.707919345348614],[-74.00425213504737,40.70791363421757]]]","id":69712,"sheet_id":2,"status":"unprocessed"},{"color":"12","dn":1178378,"geometry":"[[[-73.98740085109932,40.75644049237238],[-73.98725365424653,40.75664465205801],[-73.98716954175924,40.75661375225396],[-73.98714262576328,40.75661816651256],[-73.9871300088902,40.75659499165165],[-73.98722926162522,40.756634719979715],[-73.98725617762116,40.756630305722204],[-73.98738991647598,40.756446010209956],[-73.98740085109932,40.75644049237238]]]","id":1457,"sheet_id":2,"status":"unprocessed"}],"status":"unprocessed","updated_at":"2013-08-28T21:52:04Z"}
	intro: null

	constructor: () ->
		$("#map-tutorial").hide()
		$("#map-about").hide()
		$("#buttons").hide()
		@map = L.mapbox.map('map', 'https://s3.amazonaws.com/maptiles.nypl.org/859/859spec.json', 
			zoomControl: false
			scrollWheelZoom: false
			animate: true
			attributionControl: true
			minZoom: 18
			maxZoom: 21
			dragging: false
		)

		L.control.zoom(
			position: 'topright'
		).addTo(@map)

		# @map.on('click', @onMapClick)

		window.map = @

		@addEventListeners()

		tagger = @

		@map.on('load', () ->
			tagger.getPolygons()
			if (tagger.tutorialOn)
				tagger.tID = window.setTimeout(
						() ->
							tagger.invokeTutorial()
						, 1000
				)
		)

		# console.log @tutorialOn

	addEventListeners: () =>
		tagger = @

		$("#link-help").on("click", @invokeTutorial)
		$("#link-help-close").on("click", @hideTutorial)

		@addButtonListeners()

		$("#link-exit-tutorial").on "click", () ->
			tagger.hideTutorial()
			
		$(".score-save-link").on("click", @toggleSigninOptions)
		$("body").on("click", @onBodyClick)

	addButtonListeners: () =>
		$("#yes-button").on("click", @submitYesFlag)
		$("#no-button").on("click", @submitNoFlag)
		$("#fix-button").on("click", @submitFixFlag)

		$("body").keyup (e)->
			# console.log "key", e.which
			switch e.which
				when 49 then tagger.submitNoFlag()
				when 97 then tagger.submitNoFlag()
				when 50 then tagger.submitFixFlag()
				when 98 then tagger.submitFixFlag()
				when 51 then tagger.submitYesFlag()
				when 99 then tagger.submitYesFlag()

	removeButtonListeners: () =>
		$("#yes-button").unbind()
		$("#no-button").unbind()
		$("#fix-button").unbind()
		$("body").unbind("keyup")

	updateScore: () =>
		if @mapPolygons == 0 && @allPolygons == 0
			@mapPolygons = @loadedData.status.map_polygons
			@mapPolygonsSession = @loadedData.status.map_polygons_session
			@allPolygons = @loadedData.status.all_polygons
			@allPolygonsSession = @loadedData.status.all_polygons_session
		
		levelfloat = if @allPolygonsSession > 1 then Math.log(@allPolygonsSession) / Math.LN2 else Math.LN2
		levelfloat = 0 if @allPolygonsSession == 0
		level = Math.floor(levelfloat)
		level = 0 if @allPolygonsSession == 0
		maximumLevel = 16
		levelScore = Math.round(100 * (level / maximumLevel)) #Math.round(100 * (@allPolygonsSession / @allPolygons))
		levelScore = 100 if levelScore > 100

		# mapScore = Math.round(100 * ((@mapPolygons - @mapPolygonsSession) / @mapPolygons))
		# mapScore = if @allPolygonsSession > 0 then Math.round((levelfloat-level)*100) else 0
		mapScore = if @mapPolygons > 0 then Math.round(@allPolygonsSession*100/@allPolygons) else 0

		if @level != level
			@level = level
			@animateLevel()

		# console.log "level:", level, mapScore
		
		$("#score .total").text(@allPolygonsSession)

		levelDOM = $("#level-bar")
		levelDOM.find(".percent").text("Level: " + @level)
		levelDOM.find(".bar").css("width",levelScore + "%")
		
		mapDOM = $("#map-bar")
		mapDOM.find(".percent").text( "Next level: " + mapScore + "%")
		mapDOM.find(".bar").css("width", mapScore + "%")

	animateLevel: () =>
		el = $("#score .level-animation")
		el.text("Level " + @level + "!")
		.show().fadeOut(1000)

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

	invokeAbout: () ->
		@hideOthers()
		$("#map-about").show()

	hideAbout: () ->
		@showOthers()
		$("#map-about").hide()

	invokeTutorial: () =>
		# @hideOthers()
		# $("#map-tutorial").unswipeshow()
		# $("#map-tutorial").show()
		# $("#map-tutorial").swipeshow
		# 	mouse: true
		# 	autostart: false
		# .goTo 0
		@_polyData = @clone @polyData
		@polyData = @clone @tutorialData.poly
		@_currentIndex = @currentIndex - 1
		# @_currentPolygon = @currentPolygon
		@currentIndex = -1
		@showNextPolygon()
		@buildTutorial()
		@tutorialOn = true

	buildTutorial: () =>
		tagger = @
		if @intro == null
			@intro = introJs()
			@intro.setOptions(
				skipLabel: "Exit tutorial"
				tooltipClass: "tutorial"
				steps: [
						{
							element: "#map-highlight"
							intro: "<strong>Here's how the app works</strong><br />We'll show you one computer-generated building outline at a time, laid over the original map."
							position: "bottom"
						}
						{
							element: "#buttons .wrapper"
							intro: "Along with 3 buttons:<br /><strong>YES</strong> (keyboard 3) for when the outline matches a building footprint<br /><strong>FIX</strong> (keyboard 2) for when the outline mostly matches, but needs correcting<br /><strong>NO</strong> (keyboard 1) for when the outline is not around a building"
							position: "top"
						}
						{
							element: "#buttons .wrapper"
							intro: "Let's walk through a few examples…"
							position: "top"
						}
						{
							element: "#map-highlight"
							intro: "This outline matches the original building footprint."
							position: "top"
						}
						{
							element: "#yes-button"
							intro: "Press YES to tag it as correct and continue to the next one."
							position: "top"
						}
						{
							element: "#map-highlight"
							intro: "This outline does't match a building at all, but rather the <strong>space between buildings</strong>."
							position: "top"
						}
						{
							element: "#no-button"
							intro: "Press NO to tag it."
							position: "top"
						}
						{
							element: "#map-highlight"
							intro: "Sometimes the computer is just a little bit off (e.g. here it missed a skylight). Your input can help us to train it to recognize these in the future."
							position: "top"
						}
						{
							element: "#fix-button"
							intro: "Press FIX to indicate so."
							position: "top"
						}
						{
							element: "#map-highlight"
							intro: "But don't let perfect be the enemy of good."
							position: "top"
						}
						{
							element: "#yes-button"
							intro: "Press YES continue to the next one."
							position: "top"
						}
						{
							element: "#map-highlight"
							intro: "Some buildings have multiple parts. When in doubt, refer to the original map. <strong>Broken lines mean connected structures.</strong> Solid lines mean separate ones."
							position: "top"
						}
						{
							element: "#fix-button"
							intro: "Press FIX."
							position: "top"
						}
						{
							element: "#map-highlight"
							intro: "Same goes for <strong>multi-colored buildings</strong>. Again, defer to those original lines (broken vs. solid)."
							position: "top"
						}
						{
							element: "#yes-button"
							intro: "Press YES continue to the next one."
							position: "top"
						}
						{
							element: "#map-highlight"
							intro: "Good!<br />This one is actually <strong>two separate</strong> buildings."
							position: "top"
						}
						{
							element: "#fix-button"
							intro: "Press FIX."
							position: "top"
						}
						{
							element: "#map-highlight"
							intro: "Easy, right?<br />Occasionally a <strong>crease or seam in the map</strong> throws off the computer."
							position: "top"
						}
						{
							element: "#fix-button"
							intro: "Press FIX."
							position: "top"
						}
						{
							element: "#map-highlight"
							intro: "Sometimes the computer makes a mess."
							position: "top"
						}
						{
							element: "#no-button"
							intro: "Press NO."
							position: "top"
						}
						{
							element: "#map-highlight"
							intro: "Laugh at the poor computer and move on."
							position: "top"
						}
						{
							element: "#no-button"
							intro: "Press NO."
							position: "top"
						}
						{
							element: "#links-service"
							intro: "<strong>Now you're ready to begin checking buildings!</strong><br />You can always refer to this tutorial again by hitting the HELP button.<br />Have fun! And thanks for helping The New York Public Library."
							position: "left"
						}
				]
			).onchange (e) ->
				tagger.parseTutorial(e)
			.oncomplete () ->
				tagger.hideTutorial()
			.onexit () ->
				tagger.hideTutorial()
			.start()
		@

	parseTutorial: (e) ->
		$(".introjs-helperLayer").removeClass("noMap")
		$(".introjs-helperLayer").removeClass("yesNext")
		@removeButtonListeners()

		switch @intro._currentStep
			when 1, 2, 23
				$(".introjs-helperLayer").addClass("noMap yesNext")
			when 4, 6, 8, 10, 12, 14, 16, 18, 18, 20
				$(".introjs-helperLayer").addClass("noMap")
				@addButtonListeners()
		@

	hideTutorial: () =>
		console.log "end of tutorial"
		@removeButtonListeners()
		@tutorialOn = false
		@polyData = @clone @_polyData
		@currentIndex = @_currentIndex
		# @currentPolygon = @_currentPolygon
		@showNextPolygon()
		# @showOthers()
		# $("#map-tutorial").hide()
		@intro.exit() if @intro
		@intro = null
		@addButtonListeners()

	getPolygons: () =>
		tagger = @
		if @firstLoad
			@firstLoad = false
			mapdata = $('#tagbuildingjs').data("map")
			$("#loader").remove()
			@processPolygons(mapdata)
		else
			$.getJSON('/fixer/map.json', (data) ->
				# console.log(d);
				$("#loader").remove()
				tagger.processPolygons(data)
			)
	
	processPolygons: (data) ->
		data.poly = @shufflePolygons(data.poly)
		@loadedData = data
		@polyData = data.poly
		@updateScore()
		@showNextPolygon()

	shufflePolygons: (a) ->
		# from: http://coffeescriptcookbook.com/chapters/arrays/shuffling-array-elements
		# From the end of the list to the beginning, pick element `i`.
		for i in [a.length-1..1]
			# Choose random element `j` to the front of `i` to swap with.
			j = Math.floor Math.random() * (i + 1)
			# Swap `j` with `i`, using destructured assignment
			[a[i], a[j]] = [a[j], a[i]]
		# Return the shuffled array.
		a

	submitYesFlag: () =>
		@activateButton("yes") unless @tutorialOn
		@submitFlag("yes")

	submitNoFlag: () =>
		@activateButton("no") unless @tutorialOn
		@submitFlag("no")

	submitFixFlag: () =>
		@activateButton("fix") unless @tutorialOn
		@submitFlag("fix")

	activateButton: (button) =>
		@resetButtons()
		$("#no-button").addClass("inactive") if button != "no"
		$("#yes-button").addClass("inactive") if button != "yes"
		$("#fix-button").addClass("inactive") if button != "fix"
		$("#no-button").addClass("active") if button = "no"
		$("#yes-button").addClass("active") if button = "yes"
		$("#fix-button").addClass("active") if button = "fix"

	resetButtons: () ->
		$("#no-button").removeClass("inactive")
		$("#yes-button").removeClass("inactive")
		$("#fix-button").removeClass("inactive")
		$("#no-button").removeClass("active")
		$("#yes-button").removeClass("active")
		$("#fix-button").removeClass("active")

	submitFlag: (type) =>
		if @tutorialOn
			# do not submit the data
			@intro.goToStep(@intro._currentStep+2)
			@showNextPolygon()
			return

		_gaq.push(['_trackEvent', 'Flag', type])
		@mapPolygonsSession--
		@allPolygonsSession++
		@updateScore()

		tagger = @
		$("#buttons").fadeOut 200 , () ->
			$.get("/fixer/flag", 
				i: tagger.currentPolygon.id
				f: type
				, () ->
					tagger.resetButtons()
					tagger.showNextPolygon()
			# ).done( () ->
			# 	tagger.showNextPolygon()
			# ).fail( () ->
			# 	tagger.showNextPolygon()
			)
	
	showNextPolygon: () ->
		# console.log @polyData
		@currentIndex++
		@map.removeLayer(@geo)
		if @currentIndex < @polyData.length
			$("#buttons").show()
			@currentPolygon = @polyData[@currentIndex]
			@geo = @makePolygon(@currentPolygon)
			# console.log @currentPolygon #, @currentGeo
			# console.log @geo
			# center on the polygon
			@geo.addTo(@map)
			@map.fitBounds( @geo.getBounds() )
		else
			return if @tutorialOn
			console.log "Loading more polygons..."
			@mapPolygons = 0
			@mapPolygonsSession = 0
			@allPolygons = 0
			@allPolygonsSession = 0
			@getPolygons()

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
				dashArray: '4,16'
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
			
	toggleSigninOptions: (e) =>
		$('.sign-in-options').toggle()
		e.stopPropagation()
		
	onBodyClick: (e) =>
    if !$(e.target).closest('.sign-in-options').length
    	$('.sign-in-options').hide()

	# deep copy method
	# see: http://coffeescriptcookbook.com/chapters/classes_and_objects/cloning
	clone: (obj) ->
		if not obj? or typeof obj isnt 'object'
			return obj

		if obj instanceof Date
			return new Date(obj.getTime()) 

		if obj instanceof RegExp
			flags = ''
			flags += 'g' if obj.global?
			flags += 'i' if obj.ignoreCase?
			flags += 'm' if obj.multiline?
			flags += 'y' if obj.sticky?
			return new RegExp(obj.source, flags) 

		newInstance = new obj.constructor()

		for key of obj
			newInstance[key] = @clone obj[key]

		return newInstance


$ ->
	window._is_building = new TagBuilding()
