class Polygonfix extends Inspector

  constructor: (options) ->
    options =
      tutorialType:"video"
      tutorialURL: "//player.vimeo.com/video/91019591?autoplay=1&title=0&amp;byline=0&amp;portrait=0"
      editablePolygon: true
      draggableMap: true
      constrainMapToPolygon: false
      tutorialData: {}
      jsdataID: '#polygonfixjs'
      tweetString: "_score_ footprints fixed! Data mining old maps with Building Inspector from @NYPLMaps @nypl_labs"
      task: 'polygonfix'
    super(options)
    @flags = []
    @isMultiple = false

  clearScreen: () =>
    document.getElementById("multiple-checkbox").checked = false
    @isMultiple = false
    @updateMultipleStatus()
    @eraseGhosts()
    super()

  addEventListeners: () =>
    super()
    @map.on('click', @onMapClick)
    @map.on('dragstart', @onMapDragStart)
    @map.on('dragend', @onMapDragEnd)

    $("#multiple-checkbox").on("change", @multipleBuildingClick)

  addButtonListeners: () =>
    super()
    inspector = @
    $("#submit-button").on "click", @submitFlags
    $("#save-button").on "click", @submitFlags
    $("#add-button").on "click", @addPolygonToFlags

  removeButtonListeners: () =>
    super()
    $("#submit-button").unbind()
    $("#save-button").unbind()
    $("#add-button").unbind()

  resetButtons: () ->
    super()
    $("#submit-button").removeClass("active inactive")
    $("#save-button").removeClass("active inactive")
    $("#add-button").removeClass("active inactive")

  activateButton: (button) =>
    $("#submit-button").addClass("inactive") if button != "submit"
    $("#submit-button").addClass("active") if button == "submit"
    $("#save-button").addClass("inactive") if button != "save"
    $("#save-button").addClass("active") if button == "save"
    $("#add-button").addClass("inactive") if button != "add"
    $("#add-button").addClass("active") if button == "add"

  onMapClick: (e) =>
    @updateButton()

  onMapDragStart: (e) =>
    @updateButton()
    @hidePolygon()

  onMapDragEnd: (e) =>
    @updateButton()
    @showPolygon()

  updateButton: () ->
    $("#submit-button").text("SKIP")
    $("#submit-button").text("SAVE") if @polygonHasChanged()

  multipleBuildingClick: (e) =>
    if @isMultiple && @flags.length > 1 && !confirm("Some buildings you have created will be lost if you uncheck this. Continue?")
      # user regrets unchecking this thing
      document.getElementById("multiple-checkbox").checked = true
      @isMultiple = true
      return
    @isMultiple = $("#multiple-checkbox").is(':checked')
    @updateMultipleStatus()
    if !@isMultiple && @flags.length > 0
      # super hacky but allows for first poly to be shown
      # so user doesnt lose the very first fix they did
      @map._editablePolygons = []
      poly = ([coord[1],coord[0]] for coord in $.parseJSON(@flags[0].flag)[0])
      @geo.updateLatLngs(poly)
      @geo.addTo(@map)
      @geo._edited = true
      @eraseGhosts()
      @showPolygon()

  updateMultipleStatus: () ->
    if (@isMultiple)
      $(".primary").hide()
      $(".secondary").show()
    else
      $(".primary").show()
      $(".secondary").hide()

  showPolygon: (e) =>
    # overriding the superclass method
    @geo?._reloadPolygon() # hacky

  hidePolygon: (e) =>
    # overriding the superclass method
    @geo?._hideAll() # hacky

  addPolygonToFlags: (e) =>
    return if !@polygonHasChanged()
    flag = @getFixedPolygon()
    if flag
      @flags.push(
        flag: flag
        layer: null
      )
    @refreshGhosts()
    @resetPolygon()

  submitFlags: (e) =>
    if !@isMultiple
      @activateButton("submit") unless @options.tutorialOn
      flag_str = @getFixedPolygon()
      flag_str = "NOFIX" if !flag_str
      # console.log flag_str
      @submitFlag(e, flag_str)
    else
      @activateButton("save") unless @options.tutorialOn
      # add current flag if good
      @addPolygonToFlags()
      flag_str = @prepareData()
      @submitFlag(e, flag_str)

  getFixedPolygon: () ->
    # prepares the new polygon in GeoJSON-ish format
    # (same format as was received from server)
    return false if !@polygonHasChanged()
    points = @geo.getLatLngs()
    # console.log "points:", points
    p_array = ([p.lng,p.lat] for p in points)
    coordinates = @originalPolygon
    # if there's no change return false to leave as is
    # console.log p_array, coordinates, p_array == coordinates
    return "[[" + ("[#{p.join(",")}]" for p in p_array) + "]]"

  prepareData: () ->
    flag_array = ("#{f.flag}==" for f in @flags)
    flag_array.join("|")

  refreshGhosts: () ->
    @drawGhost $.parseJSON(f.flag), index for f, index in @flags

  eraseGhosts: () ->
    @map.removeLayer f.layer for f in @flags when f.layer isnt null
    @flags = []

  drawGhost: (poly, index) ->
    return if @flags[index].layer != null
    ghost = @makePolygon(poly)
    ghost.setStyle(
      color:'#fff'
      dashArray: '2,6'
      weight: 3
    )
    ghost.addTo @map
    @flags[index].layer = ghost

  resetPolygon: () ->
    @makeEditablePolygon()
    @geo._reloadPolygon() # hacky
    @geo._edited = false

  polygonHasChanged: () ->
    @geo._edited

$ ->
  new Polygonfix()

