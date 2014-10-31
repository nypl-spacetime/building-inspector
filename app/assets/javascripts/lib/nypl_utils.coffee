root = exports ? this

class root.Utils
  constructor: () ->
    @

  # deep copy method
  # see: http://coffeescriptcookbook.com/chapters/classes_and_objects/cloning
  @clone: (obj) ->
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

    newInstance

  @shuffle: (a) ->
    return a if a.length < 2
    # from: http://coffeescriptcookbook.com/chapters/arrays/shuffling-array-elements
    # From the end of the list to the beginning, pick element `i`.
    for i in [a.length-1..1]
      # Choose random element `j` to the front of `i` to swap with.
      j = Math.floor Math.random() * (i + 1)
      # Swap `j` with `i`, using destructured assignment
      [a[i], a[j]] = [a[j], a[i]]
    # Return the shuffled array.
    a

  @parseBbox: (bbox_str) ->
    bbox = (parseFloat(n) for n in bbox_str.split(","))
    @bboxToBounds(bbox)

  @bboxToBounds: (bbox) ->
    W = parseFloat(bbox[0])
    S = parseFloat(bbox[1])
    E = parseFloat(bbox[2])
    N = parseFloat(bbox[3])

    SW = new L.LatLng(S, W)
    NW = new L.LatLng(N, W)
    NE = new L.LatLng(N, E)
    SE = new L.LatLng(S, E)

    new L.LatLngBounds(SW, NE)

  @spinner: (opts) ->
    default_opts =
      lines: 11 # The number of lines to draw
      length: 0 # The length of each line
      width: 4 # The line thickness
      radius: 8 # The radius of the inner circle
      corners: 1 # Corner roundness (0..1)
      rotate: 0 # The rotation offset
      color: '#3f3a34' # #rgb or #rrggbb
      speed: 1 # Rounds per second
      trail: 60 # Afterglow percentage
      shadow: false # Whether to render a shadow
      hwaccel: false # Whether to use hardware acceleration
      className: 'spinner' # The CSS class to assign to the spinner
      zIndex: 9 # The z-index (defaults to 2000000000)
      top: 'auto' # Top position relative to parent in px
      left: 'auto' # Left position relative to parent in px

    opts = $.extend default_opts, opts
    new Spinner(opts).spin()

class root.Simplify
  # This Library contains a function which performs the Visvalingam-Whyatt Curve Simplification Algorithm.
  # Code taken from
  # http://web.cs.sunyit.edu/~poissad/projects/Curve/about_code/
  # Created by Dustin Poissant on 10/09/2012
  # Ported to CoffeScript by Mauricio Giraldo on 03/05/2014.

  constructor: () ->
    @

  @whyatt: (geometry, number_to_keep) ->
    list = Simplify.geoJSONToXY(geometry)
    num_remove = list.length - number_to_keep
    for i in [0..num_remove]
      minIndex = 1
      minArea = Simplify.triangleArea(list[0], list[1], list[2])
      for e in [2..(list.length-1)]
        continue if !list[e+1]
        area = Simplify.triangleArea(list[e-1], list[e], list[e+1])
        if (area<minArea)
          minIndex = e
          minArea = area
      list.splice(minIndex,1)
    list

  @whyattGeoJSON: (geometry, number_to_keep) ->
    simple = Simplify.whyatt(geometry, number_to_keep)
    Simplify.xyToGeoJSON(simple)

  @geoJSONToXY: (geometry) ->
    list = []
    for point in geometry
      list.push(
        x: point[0]
        y: point[1]
      )
    list

  @xyToGeoJSON: (list) ->
    xy = []
    for point in list
      xy.push([point.x,point.y])
    xy

  @distance: (point1, point2) ->
    Math.sqrt( Math.pow( ( point1.x - point2.x ), 2 ) + Math.pow( ( point1.y - point2.y ), 2 ) )

  @distanceToLine: (Line, Point) ->
    m = (Line.p1.y-Line.p2.y)/(Line.p1.x-Line.p2.x)
    b = Line.p1.y - ( m * Line.p1.x )
    # Distance to Point Formula
    Math.abs( Point.y - ( m * Point.x ) - b ) / Math.sqrt( Math.pow( m, 2 ) + 1)

  @triangleArea: (Point1, Point2, Point3) ->
    line = new Line(Point1, Point2)
    point = Point3
    if ( @distance(Point1, Point3)>@distance(Point1, Point2))
      line = new Line(Point1, Point3)
      point = Point2

    if ( @distance(Point2, Point3) > @distance(line.p1, line.p2))
      line = new Line(Point2, Point3)
      point = Point1

    base = Simplify.distance(line.p1, line.p2)
    height = Simplify.distanceToLine(line, point)
    if ((base*height)/2>0 || (base*height)/2<0)
      return (base*height)/2
    else
      return 0

  randomInt: (min, max) ->
    return Math.floor((Math.random()*(max-min))+min)

class root.Line
  # Code taken from
  # http://web.cs.sunyit.edu/~poissad/projects/Curve/about_code/
  # Created by Dustin Poissant on 10/09/2012
  # Ported to CoffeScript by Mauricio Giraldo on 03/05/2014.
  constructor: (@p1, @p2) ->
    @
