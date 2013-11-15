class Building

	polyData: {}
	_polyData: {}
	currentIndex: -1
	_currentIndex: -1
	currentPolygon: {}
	_currentPolygon: {}
	layer_id: 0
	geo: {}
	popup: L.popup()
	verticalOffset: 100 # pixels to offset the polygon from the center
	loadedData: {}
	tutorialOn: $('#buildingjs').data("session")
	mapPolygons: 0
	mapPolygonsSession: 0
	allPolygons: 0
	allPolygonsSession: 0
	level: 0
	firstLoad: true
	tutorialData: {"bbox":"","created_at":"2013-08-28T21:52:04Z","id":2,"map_id":0,"map_url":null,"poly":[{"color":"8","dn":1058779,"geometry":"[[[-73.98981903680895,40.718485922670816],[-73.98993036816371,40.71851925549513],[-73.98993427452703,40.718529511745416],[-73.9899108363471,40.71857566485211],[-73.98978192635737,40.71853976799411],[-73.98979755181067,40.718498742989844],[-73.98980927090065,40.71848335860672],[-73.98981903680895,40.718485922670816]]]","id":1488,"sheet_id":2,"status":"unprocessed"},{"color":"8","dn":1065840,"geometry":"[[[-73.99165289733966,40.71803840813441],[-73.99176116354947,40.718068556660576],[-73.99176608474083,40.71807501705726],[-73.991754601961,40.71809870517308],[-73.99170867084169,40.71808147745331],[-73.99167586289933,40.71809870517308],[-73.99160696622035,40.71807717052268],[-73.9916282913829,40.718031947734175],[-73.99165289733966,40.71803840813441]]]","id":2101,"sheet_id":2,"status":"unprocessed"},{"color":"8","dn":1065840,"geometry":"[[[-73.99238005769902,40.71582418347879],[-73.9925334868471,40.71586983959642],[-73.99255394406686,40.71585909698332],[-73.99256417267672,40.71584566871452],[-73.99260713283819,40.715762413387445],[-73.9926460015557,40.715770470359125],[-73.9926460015557,40.71580269823613],[-73.99259894995028,40.71589669612158],[-73.9925662183987,40.71589132481742],[-73.99241074352862,40.715842983060426],[-73.99237596625507,40.71582955478837],[-73.99238005769902,40.71582418347879]]]","id":2101,"sheet_id":2,"status":"unprocessed"},{"color":"3","dn":111187,"geometry":"[[[-74.00221835769625,40.70964367838799],[-74.0023501667551,40.70970475730078],[-74.00234629001807,40.709720027020225],[-74.00231527612186,40.70976074625494],[-74.00231527612186,40.70977092605974],[-74.00228038548865,40.70981673516205],[-74.00228038548865,40.709826914958285],[-74.00206328821527,40.709745476544846],[-74.00204778126715,40.709735296736156],[-74.00209430211146,40.70966403803181],[-74.00212919274469,40.709679307760595],[-74.00215632990384,40.70967421785139],[-74.00217183685194,40.70964367838799],[-74.00218734380005,40.70963349856375],[-74.00221835769625,40.70964367838799]]]","id":69407,"sheet_id":2,"status":"unprocessed"},{"color":"1","dn":1061017,"geometry":"[[[-73.99102938067263,40.71945258584999],[-73.99106888411198,40.71946295742699],[-73.99109456134758,40.7194499929555],[-73.99110838755135,40.719431842691144],[-73.99119529511795,40.719457771638695],[-73.99116171719449,40.71952259396336],[-73.99101555446885,40.71948110768284],[-73.99102938067263,40.71945258584999]]]","id":1984,"sheet_id":2,"status":"unprocessed"},{"color":"8","dn":1084906,"geometry":"[[[-74.00348923441064,40.70902308140003],[-74.00350806906381,40.709031324381094],[-74.00353946015244,40.709072539271126],[-74.00355829480561,40.709080782246076],[-74.00358968589426,40.7091219971055],[-74.00360852054742,40.70913024007433],[-74.00363991163604,40.70917145490314],[-74.00365874628923,40.70917969786584],[-74.00369013737786,40.70922091266405],[-74.00370897203103,40.70922915562063],[-74.00374036311966,40.709270370388225],[-74.00373408490194,40.70927861333868],[-74.00358968589426,40.70935279984689],[-74.00351434728154,40.709402257473116],[-74.00347667797517,40.70941874334035],[-74.00345156510427,40.70941874334035],[-74.00342645223337,40.70938577160178],[-74.0034829561929,40.709361042787144],[-74.00349551262836,40.70932807102001],[-74.00346412153974,40.70928685628812],[-74.00344528688655,40.70927861333868],[-74.00341389579793,40.709237398576185],[-74.00339506114474,40.70922915562063],[-74.00336367005612,40.709187940827526],[-74.00334483540294,40.70917969786584],[-74.00331972253203,40.70914672600892],[-74.00330088787885,40.70913848304213],[-74.00328205322567,40.70911375413566],[-74.00333227896749,40.709080782246076],[-74.00341389579793,40.70903956736114],[-74.00347039975746,40.70901483841793],[-74.0034829561929,40.70901483841793],[-74.00348923441064,40.70902308140003]]]","id":69495,"sheet_id":2,"status":"unprocessed"},{"color":"8","dn":1084908,"geometry":"[[[-73.99250529707196,40.71843440142136],[-73.9925212982511,40.7184133956505],[-73.99268131004264,40.71846140883131],[-73.99268588180813,40.71846741047648],[-73.99266073709802,40.71851842443856],[-73.99264930768436,40.718521425258636],[-73.99262644885698,40.71851542361834],[-73.9924892958928,40.718473412121114],[-73.99250529707196,40.71843440142136]]]","id":2018,"sheet_id":2,"status":"unprocessed"},{"color":"12","dn":1095137,"geometry":"[[[-74.00454310505249,40.70815510738579],[-74.00458593251801,40.708203804863125],[-74.00438607101226,40.70828496724622],[-74.00437179519042,40.70830661053167],[-74.00448600176513,40.70845270252448],[-74.00441462265594,40.708479756562056],[-74.00425758861572,40.70829037806824],[-74.00427186443756,40.70826873477752],[-74.00426472652664,40.708257913129515],[-74.00427186443756,40.70825250230486],[-74.00437893310134,40.708214626519926],[-74.00439320892318,40.708203804863125],[-74.00440748474503,40.708203804863125],[-74.00442176056686,40.708192983204576],[-74.00454310505249,40.70814969655278],[-74.00454310505249,40.70815510738579]]]","id":69655,"sheet_id":2,"status":"unprocessed"},{"color":"1","dn":1123405,"geometry":"[[[-74.00501889557988,40.70880948768108],[-74.00505393966343,40.70879798486693],[-74.0050911740022,40.70884687181333],[-74.00490938281875,40.70891301291898],[-74.00488967052176,40.70891013722009],[-74.00487214847999,40.70889863442333],[-74.00491157307398,40.70889288302421],[-74.00492252435009,40.708872753123366],[-74.00491376332921,40.70886700172199],[-74.00490938281875,40.70884974751494],[-74.00501889557988,40.70880948768108]]]","id":69530,"sheet_id":2,"status":"unprocessed"},{"color":"3","dn":1123406,"geometry":"[[[-74.00425213504737,40.70791363421757],[-74.00427097013254,40.707907923086026],[-74.00427473714957,40.70791648978315],[-74.00424836803033,40.707925056479176],[-74.00422953294517,40.707939334303425],[-74.0042332999622,40.70796503437937],[-74.00420693084297,40.707996445569826],[-74.00418432874076,40.70800786781724],[-74.00417302768966,40.70797931219506],[-74.00415042558745,40.70797360106915],[-74.00413159050228,40.70797645663216],[-74.00410898840008,40.70799359000767],[-74.00410898840008,40.70800786781724],[-74.00413912453637,40.70805355678725],[-74.00413535751933,40.70805070122754],[-74.00410522138306,40.70806212346564],[-74.00409768734899,40.70807640126051],[-74.00410145436602,40.70809067905231],[-74.00414665857043,40.70813065685308],[-74.00418056172373,40.70814779018892],[-74.00418056172373,40.70816206796541],[-74.00419562979185,40.70817349018441],[-74.00421446487702,40.708176345738856],[-74.00421069786,40.70819347906294],[-74.00419186277483,40.708202045723326],[-74.0041767947067,40.708196334616524],[-74.00401857999128,40.70800786781724],[-74.0041993968089,40.707936478738816],[-74.00421069786,40.70791648978315],[-74.00423706697923,40.707919345348614],[-74.00425213504737,40.70791363421757]]]","id":69712,"sheet_id":2,"status":"unprocessed"},{"color":"12","dn":1178378,"geometry":"[[[-73.9948451711393,40.71733802612758],[-73.99491251041154,40.717348735589155],[-73.99497298681057,40.71736913253071],[-73.99501137394432,40.71736962965669],[-73.99508990777598,40.71739873469717],[-73.99516873709659,40.717419715618824],[-73.99512401293532,40.71750986004308],[-73.99509811988182,40.71754572595169],[-73.9950988312578,40.71756027341869],[-73.99508491698433,40.7175733044768],[-73.99507684029759,40.71759845612131],[-73.99500853859328,40.717580568175016],[-73.9949985459334,40.71757217243856],[-73.99496447628967,40.717561157763924],[-73.99491649237247,40.71755967417368],[-73.99484922952735,40.717534417276575],[-73.99482043917703,40.71752999121156],[-73.99479075517367,40.71751617456105],[-73.9947856566583,40.71750144236371],[-73.99477664568917,40.71749703183826],[-73.99473767274111,40.71750272718133],[-73.99475423965809,40.71748386183968],[-73.99476220063562,40.71745474362645],[-73.99475154032955,40.71743294563284],[-73.99473688184187,40.71742271600433],[-73.99474467773311,40.71739431898885],[-73.99473316204985,40.71737907350362],[-73.99471387365774,40.71737045359464],[-73.99476195240017,40.71738200614437],[-73.9947877846485,40.71735615214322],[-73.99480184498564,40.717362506611586],[-73.99482617178225,40.71735529434347],[-73.99482597757243,40.717333473074575],[-73.994808193,40.717328972106856],[-73.9948167174015,40.71731905253298],[-73.9948369833503,40.71732595402236],[-73.9948451711393,40.71733802612758]]]","id":1457,"sheet_id":2,"status":"unprocessed"}],"status":"unprocessed","updated_at":"2013-08-28T21:52:04Z"}
	intro: null
	prevStep: 0
	buttonModes: ["center","right","left"]

	constructor: () ->
		@buttonMode = 0
		$("#map-tutorial").hide()
		$("#map-about").hide()
		$("#buttons").hide()
		$("#tweet").hide()
		@map = L.mapbox.map('map', 'https://s3.amazonaws.com/maptiles.nypl.org/859-final/859spec.json', 
			zoomControl: false
			scrollWheelZoom: false
			animate: true
			attributionControl: false
			minZoom: 18
			maxZoom: 21
			dragging: false
			touchZoom: false
		)

		@overlay2 = L.mapbox.tileLayer('https://s3.amazonaws.com/maptiles.nypl.org/860/860spec.json',
			zIndex: 3
		).addTo(@map)

		L.control.attribution(
			position: 'bottomright'
			prefix: ""
		).addTo(@map)

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

		return if !!(window.history && window.history.pushState) # ie screws up all
		
		history.replaceState("fixer","inspector","building") 

		# console.log @tutorialOn

	addEventListeners: () =>
		tagger = @

		@addButtonListeners()

	addButtonListeners: () =>
		tagger = @
		@removeButtonListeners()
		$("#one-hand").on("click", @toggleButtonMode)
		$("#link-help-close").on("click", @hideTutorial)
		$("#link-exit-tutorial").on("click", @hideTutorial)
		$("#link-help").on("click", @invokeTutorial)
		$("#yes-button").on("click", @submitYesFlag)
		$("#no-button").on("click", @submitNoFlag)
		$("#fix-button").on("click", @submitFixFlag)

		$("#yes-button").on("dblclick", (e) ->
			e.preventDefault()
		)
		$("#no-button").on("dblclick", (e) ->
			e.preventDefault()
		)
		$("#fix-button").on("dblclick", (e) ->
			e.preventDefault()
		)

		$("body").keyup (e)->
			# console.log "key", e.which
			switch e.which
				when 49 then tagger.submitNoFlag(e)
				when 97 then tagger.submitNoFlag(e)
				when 50 then tagger.submitFixFlag(e)
				when 98 then tagger.submitFixFlag(e)
				when 51 then tagger.submitYesFlag(e)
				when 99 then tagger.submitYesFlag(e)

	toggleButtonMode: () =>
		@buttonMode++
		@buttonMode = 0 if @buttonMode >= @buttonModes.length
		$("#buttons").removeClass("left")
		$("#buttons").removeClass("right")
		switch @buttonMode
			when 1
				$("#buttons").addClass("right")
			when 2
				$("#buttons").addClass("left")
		@

	removeButtonListeners: () =>
		$("#link-help").unbind()
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
		
		$("#score .total").text(@allPolygonsSession)

		url = $('#progressjs').data("server")
		tweet = @allPolygonsSession + " buildings checked! Data mining old maps with the Building Inspector from @NYPLMaps @nypl_labs"
		twitterurl = "https://twitter.com/share?url=" + url + "&text=" + tweet

		$("#tweet").show()

		$("#tweet").attr "href", twitterurl

	animateSheet: () =>
		return if @layer_id == @loadedData.map.layer_id
		@layer_id = @loadedData.map.layer_id
		msg = "BROOKLYN"
		msg = "MANHATTAN" if @layer_id == 859 # hack // eventually add to sheet table
		el = $("#map-inspecting")
		el.html("<span>NOW INSPECTING " + msg + "!</span>")
		.show().delay(1000).fadeOut(1000)

	hideOthers: () ->
		$("#main-container").hide()
		$("#controls").hide()
		$("#map-tutorial").hide()

	showOthers: () ->
		$("#main-container").show()
		$("#controls").show()
		$("#map-tutorial").hide()

	hideTutorial: () =>
		# console.log "end of tutorial"
		if (window.innerWidth < 500)
			@showOthers()
		else
			@intro.exit() if @intro
			@intro = null
			@removeButtonListeners()
			@polyData = @clone @_polyData
			@currentIndex = @_currentIndex
			@showNextPolygon()
			@addButtonListeners()
		@tutorialOn = false

	invokeTutorial: () =>
		if (window.innerWidth < 500)
			@hideOthers()
			$("#map-tutorial").unswipeshow()
			$("#map-tutorial").show()
			$("#map-tutorial").swipeshow
				mouse: true
				autostart: false
			.goTo 0
		else
			@_polyData = @clone @polyData
			@polyData = @clone @tutorialData.poly
			@_currentIndex = @currentIndex - 1
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
				showStepNumbers: false
				exitOnOverlayClick: false
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
							intro: "Press NO to tag it as wrong."
							position: "top"
						}
						{
							element: "#map-highlight"
							intro: "Sometimes that inter-building space has a darker shade."
							position: "top"
						}
						{
							element: "#no-button"
							intro: "Be vigilant!"
							position: "top"
						}
						{
							element: "#map-highlight"
							intro: "Sometimes the computer is <strong>just a little bit off</strong> (e.g. here it missed a skylight).<br />Your input can help us to train it to recognize these in the future."
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
							intro: "This one's good enough. Press YES and keep going."
							position: "top"
						}
						{
							element: "#map-highlight"
							intro: "Some buildings have multiple parts. When in doubt, refer to the original map. <strong>Broken lines mean connected structures.</strong> Solid lines mean separate ones."
							position: "top"
						}
						{
							element: ".leaflet-control-zoom.leaflet-bar.leaflet-control"
							intro: "That's a large building! Use zoom in/out to view it better."
							position: "left"
						}
						{
							element: "#yes-button"
							intro: "Now you can approve it."
							position: "top"
						}
						{
							element: "#map-highlight"
							intro: "Defer to those original lines (broken vs. solid) criteria for <strong>multi-colored buildings</strong> also."
							position: "top"
						}
						{
							element: "#yes-button"
							intro: "That's a YES!"
							position: "top"
						}
						{
							element: "#map-highlight"
							intro: "Good!<br />This one is actually <strong>two separate</strong> buildings."
							position: "top"
						}
						{
							element: "#fix-button"
							intro: "That's a FIXer."
							position: "top"
						}
						{
							element: "#map-highlight"
							intro: "Easy, right?<br />But keep an eye out.. Occasionally a <strong>crease or seam in the map</strong> throws off the computer."
							position: "top"
						}
						{
							element: "#fix-button"
							intro: "Those are FIXes."
							position: "top"
						}
						{
							element: "#map-highlight"
							intro: "Sometimes the computer makes a real mess."
							position: "top"
						}
						{
							element: "#no-button"
							intro: "Teach that computer a lesson!"
							position: "top"
						}
						{
							element: "#map-highlight"
							intro: "Yikes! It really screwed this one up."
							position: "top"
						}
						{
							element: "#no-button"
							intro: "Laugh at the poor computer and move on."
							position: "top"
						}
						{
							element: "#link-help"
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

	parseTutorial: (e) =>
		# console.log @intro._currentStep, @currentIndex
		$(".introjs-helperLayer").removeClass("noMap")
		$(".introjs-helperLayer").removeClass("yesNext")
		@removeButtonListeners()

		switch @intro._currentStep
			when 1, 2, 14
				$(".introjs-helperLayer").addClass("noMap yesNext")
			when 4, 6, 8, 10, 12, 15, 17, 19, 21, 23, 25
				$(".introjs-helperLayer").addClass("noMap")
				@addButtonListeners()
			when 26
				$(".introjs-helperLayer").addClass("noMap")
		# for polygon show
		switch @intro._currentStep
			when 0,1,2,3,4
				@currentIndex = -1
			when 5,6 then @currentIndex = 0
			when 7,8 then @currentIndex = 1
			when 9,10 then @currentIndex = 2
			when 11,12 then @currentIndex = 3
			when 13,14,15 then @currentIndex = 4
			when 16,17 then @currentIndex = 5
			when 18,19 then @currentIndex = 6
			when 20,21 then @currentIndex = 7
			when 22,23 then @currentIndex = 8
			when 24,25,26 then @currentIndex = 9
		@showNextPolygon()
		@

	getPolygons: () =>
		tagger = @
		if @firstLoad
			@firstLoad = false
			mapdata = $('#buildingjs').data("map")
			$("#loader").remove()
			@processPolygons(mapdata)
		else
			$.getJSON('/fixer/map.json', (data) ->
				# console.log(d);
				$("#loader").remove()
				tagger.processPolygons(data)
			)
	
	processPolygons: (data) =>
		data.poly = @shufflePolygons(data.poly)
		@loadedData = data
		@polyData = data.poly
		@updateScore()
		@animateSheet()
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

	submitYesFlag: (e) =>
		@removeButtonListeners()
		e.preventDefault()
		@activateButton("yes") unless @tutorialOn
		@submitFlag("yes")

	submitNoFlag: (e) =>
		@removeButtonListeners()
		e.preventDefault()
		@activateButton("no") unless @tutorialOn
		@submitFlag("no")

	submitFixFlag: (e) =>
		@removeButtonListeners()
		e.preventDefault()
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
		@addButtonListeners()

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
	
	showNextPolygon: () =>
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
			# console.log "Loading more polygons..."
			@currentIndex = -1
			@currentPolygon = {}
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
				weight: 5
				opacity: 1
				dashArray: '1,16'
				fill: false
			# onEachFeature: (f,l) ->
			# 	out = for key, val of f.properties
			# 		"<strong>#{key}:</strong> #{val}"
			# 	l.bindPopup(out.join("<br />"))
		).addData json

	# onMapClick: (e) =>
	# 	@popup
	# 		.setLatLng(e.latlng)
	# 		.setContent("You clicked the map at " + e.latlng.toString())
	# 		.openOn(@map)
		
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
	window._is_building = new Building()
