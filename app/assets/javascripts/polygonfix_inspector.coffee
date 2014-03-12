class Polygonfix extends Inspector

  constructor: () ->
    tutorialData =
        poly: {"bbox":"","created_at":"2013-08-28T21:52:04Z","id":2,"map_id":0,"map_url":null,"poly":[{"color":"8","dn":1058779,"geometry":"[[[-73.9917489385617,40.73160355632643],[-73.99176508603846,40.7315894272398],[-73.9917785422691,40.73159295951173],[-73.99200729818992,40.7316883307832],[-73.99201268068218,40.73169539531639],[-73.99197500323639,40.73173778249977],[-73.99172471734657,40.73163534676037],[-73.9917489385617,40.73160355632643]]]","id":1488,"sheet_id":2,"status":"unprocessed"},{"color":"8","dn":1065840,"geometry":"[[[-73.99285440448465,40.73320584082565],[-73.99291608447433,40.733232825247896],[-73.99291450293613,40.7332390524207],[-73.99289077986317,40.733245279592936],[-73.99286863832842,40.73327849116829],[-73.99278956141856,40.73326603682947],[-73.99283226294989,40.73320168937511],[-73.99284017064087,40.733199613649745],[-73.99285440448465,40.73320584082565]]]","id":2101,"sheet_id":2,"status":"unprocessed"},{"color":"8","dn":1065840,"geometry":"[[[-73.99219510816457,40.73254771536549],[-73.99224570315576,40.73256835946708],[-73.99214451317339,40.7327010713958],[-73.992082242415,40.732674529031236],[-73.99217954047498,40.73254476620759],[-73.99218343239738,40.73254181704957],[-73.99219510816457,40.73254771536549]]]","id":2101,"sheet_id":2,"status":"unprocessed"},{"color":"3","dn":111187,"geometry":"[[[-73.991333336943,40.73301062882454],[-73.99147411122182,40.73303372418245],[-73.99147851041803,40.73305104569565],[-73.9914653128294,40.73309146254221],[-73.99129374417709,40.733062593368594],[-73.99130694176571,40.73300485498379],[-73.991333336943,40.73301062882454]]]","id":69407,"sheet_id":2,"status":"unprocessed"},{"color":"1","dn":1061017,"geometry":"[[[-73.99204496531397,40.733898502139596],[-73.9920540120468,40.733886628675144],[-73.99213724198881,40.733919874370265],[-73.99213905133539,40.73393174782879],[-73.9921064830972,40.73397449226191],[-73.9920847709384,40.73397449226191],[-73.99200696903611,40.733957869430064],[-73.99200515968954,40.73395074535801],[-73.99204496531397,40.733898502139596]]]","id":1984,"sheet_id":2,"status":"unprocessed"},{"color":"8","dn":1084906,"geometry":"[[[-73.99260271561742,40.733666621617616],[-73.99264410318662,40.73367341157545],[-73.99265445007892,40.73368699148904],[-73.99278895967879,40.733741311115665],[-73.99279154640186,40.73375149604072],[-73.99275015883266,40.733799025670365],[-73.992553567879,40.73371754628447],[-73.99257684838668,40.73367341157545],[-73.99258978200206,40.73366322663844],[-73.99260271561742,40.733666621617616]]]","id":69495,"sheet_id":2,"status":"unprocessed"},{"color":"8","dn":1084908,"geometry":"[[[-73.99467876998335,40.714962098308405],[-73.99481423128013,40.71500225525319],[-73.99478364324537,40.71505962227514],[-73.99463070307159,40.71501372866153],[-73.9946569213871,40.71495636160003],[-73.99467876998335,40.714962098308405]]]","id":2018,"sheet_id":2,"status":"unprocessed"},{"color":"12","dn":1095137,"geometry":"[[[-73.9914326318635,40.732605885457374],[-73.99164216035788,40.73269365226407],[-73.99165107646402,40.73273461006758],[-73.99164661841095,40.73274631229252],[-73.99153516708415,40.7326995033804],[-73.99150841876573,40.73268195002986],[-73.99149058655344,40.73268195002986],[-73.99139250938585,40.73264099219395],[-73.991401425492,40.73259418320773],[-73.9914326318635,40.732605885457374]]]","id":69655,"sheet_id":2,"status":"unprocessed"},{"color":"12","dn":1095137,"geometry":"[[[-73.99631771565119,40.738981722245896],[-73.9963831008286,40.73900779683433],[-73.99631771565119,40.73909905781334],[-73.99624544782354,40.73906776834893],[-73.99630739167581,40.738981722245896],[-73.99631771565119,40.738981722245896]]]","id":69655,"sheet_id":2,"status":"unprocessed"},{"color":"1","dn":1123405,"geometry":"[[[-73.99137871882681,40.73271012952303],[-73.99144820633073,40.73271979836216],[-73.9914399003793,40.73275058464772],[-73.99136756952616,40.732740159964955],[-73.99137375971172,40.73270948736736],[-73.99137871882681,40.73271012952303]]]","id":69530,"sheet_id":2,"status":"unprocessed"},{"color":"3","dn":1123406,"geometry":"[[[-73.99150976731543,40.732235259397115],[-73.9915611428715,40.732235259397115],[-73.99158040870505,40.73224368814436],[-73.99163178426112,40.73224368814436],[-73.99165105009465,40.73225211689052],[-73.9916895817617,40.73225211689052],[-73.99170884759523,40.73226054563564],[-73.99176022315132,40.73226054563564],[-73.99177948898485,40.73226897437967],[-73.99180517676288,40.73226897437967],[-73.99181159870739,40.732277403122644],[-73.99179875481836,40.73232797555806],[-73.99183728648545,40.73234483302798],[-73.99185013037444,40.73234483302798],[-73.99184370842994,40.732420691589795],[-73.99185013037444,40.73242912031355],[-73.9918886620415,40.73244597775785],[-73.99180517676288,40.73255555104169],[-73.99174737926229,40.73253026491528],[-73.99172811342875,40.73253869362516],[-73.99147765759288,40.73242912031355],[-73.99146481370386,40.73242912031355],[-73.99143912592584,40.73241226286497],[-73.99147765759288,40.73226054563564],[-73.99147765759288,40.7322268306488],[-73.99150976731543,40.732235259397115]]]","id":69712,"sheet_id":2,"status":"unprocessed"},{"color":"3","dn":1123406,"geometry":"[[[-73.9946878320301,40.71491928210032],[-73.9948462711411,40.71496778046124],[-73.99483103661119,40.71500011268223],[-73.99466345678226,40.71495161434486],[-73.9946725975002,40.714923900993355],[-73.99467869131216,40.714916972653675],[-73.9946878320301,40.71491928210032]]]","id":69712,"sheet_id":2,"status":"unprocessed"},{"color":"3","dn":1123406,"geometry":"[[[-73.99092398657614,40.73119895065988],[-73.99093727994169,40.73119197157895],[-73.99099311207691,40.731216398359],[-73.99095854932654,40.73126176235532],[-73.99089739984507,40.731237335591906],[-73.99092398657614,40.73119895065988]]]","id":69712,"sheet_id":2,"status":"unprocessed"},],"status":"unprocessed","updated_at":"2013-08-28T21:52:04Z"}
        steps: [
              {
                element: "#map-highlight"
                intro: "<strong>Here's how this task works</strong><br />We'll show you one computer-generated building outline at a time, laid over the original map."
                position: "bottom"
                polygon_index: -1
              }
              {
                element: "#buttons .wrapper"
                intro: "Along with this button. Let's walk through a few examples…"
                position: "top"
                polygon_index: -1
                ixactive: true
              }
              {
                element: "#map-highlight"
                intro: "The address number of this building is 781. Click there and type 781."
                position: "right"
                polygon_index: -1
              }
              {
                element: "#submit-button"
                intro: "Press next to save it and go to the next building."
                position: "top"
                polygon_index: -1
                ixactive: true
              }
              {
                element: "#buttons .multiple"
                intro: "Check this box if the polygon covers more than one building."
                position: "top"
                polygon_index: -1
              }
              {
                element: "#map-highlight"
                intro: "62 or 29? Look around! (remind of even/odd addressing system)"
                position: "right"
                polygon_index: 0
              }
              {
                element: "#submit-button"
                intro: "press."
                position: "top"
                polygon_index: 0
                ixactive: true
              }
              {
                element: "#map-highlight"
                intro: "1s may be confused for 4s and vice-versa. look around"
                position: "right"
                polygon_index: 1
              }
              {
                element: "#submit-button"
                intro: "Be vigilant!"
                position: "top"
                polygon_index: 1
                ixactive: true
              }
              {
                element: "#map-highlight"
                intro: "3s and 8s are another source of confusion."
                position: "right"
                polygon_index: 2
              }
              {
                element: "#submit-button"
                intro: "Press FIX to indicate so."
                position: "top"
                polygon_index: 2
                ixactive: true
              }
            ]
    options =
      editablePolygon: true
      tutorialData: tutorialData
      jsdataID: '#polygonfixjs'
      task: 'polygonfix'
      tweetString: "_score_ buildings checked! Data mining old maps with the Building Inspector from @NYPLMaps @nypl_labs"
    super(options)
    @isMultiple = false

  clearScreen: () =>
    @updateMultipleStatus()
    super()

  addEventListeners: () =>
    super()
    $("#multiple-polygon").on("change click", @multipleBuildingClick)
    $("#multiple-text").on("click", @multipleBuildingClick)

  addButtonListeners: () =>
    super()
    inspector = @
    $("#submit-button").on "click", @submitFlags

  removeButtonListeners: () =>
    super()
    $("#submit-button").unbind()

  resetButtons: () ->
    super()
    $("#submit-button").removeClass("active inactive")

  activateButton: (button) =>
    $("#submit-button").addClass("inactive") if button != "submit"
    $("#submit-button").addClass("active") if button == "submit"

  multipleBuildingClick: (e) =>
    @isMultiple = $("#multiple-polygon").is(':checked')
    @updateMultipleStatus()

  updateMultipleStatus: () ->
    if (@isMultiple)
      $("#multiple-text").text("Finish this building, polygon will reload.")
    else
      $("#multiple-text").text("More than one building?")

  showPolygon: (e) =>
    # overriding the superclass method
    @geo._reloadPolygon() # hacky

  hidePolygon: (e) =>
    # overriding the superclass method
    @geo._hideAll() # hacky

  submitFlags: (e) =>
    @activateButton("submit") unless @options.tutorialOn

    flag_str = @getFixedPolygon()

    flag_str = "NOFIX" if !flag_str

    # console.log flag_str

    @submitSingleFlag(e, flag_str)

  getFixedPolygon: () ->
    # prepares the new polygon in GeoJSON-ish format
    # (same format as was received from server)
    points = @geo.getPoints()
    # console.log "points:", points
    p_array = ([p.getLatLng().lng,p.getLatLng().lat] for p in points)
    coordinates = $.parseJSON(@currentPolygon.geometry)[0]
    if coordinates[0][0] == coordinates[coordinates.length-1][0] && coordinates[0][1] == coordinates[coordinates.length-1][1]
      # same coordinate for the first and last point / redundant
      coordinates.pop()
    # if there's no change return false to leave as is
    # console.log p_array, coordinates
    return false if p_array.join(",") == coordinates.join(",")
    return "[[" + ("[#{p.join(",")}]" for p in p_array) + "]]"

$ ->
  new Polygonfix()

