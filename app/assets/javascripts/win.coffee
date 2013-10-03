class Win

    width: 500
    height: 500
    scale: 10000000
    polys: []

    constructor: () ->
        # console.log "win:", @json
        @json = $('#data').data("polys")
        @processPolys()

    processPolys: () ->
        # console.log "json:", @json
        @polyToXY p for p in @json.features
        console.log @polys

    polyToXY: (poly) ->
        # console.log "poly:", poly
        xy = []
        coords = poly.geometry.coordinates[0]
        origin = coords[0]
        xy = (@scaleCoordByOrigin coord, origin for coord in coords)
        @polys.push(xy)

    scaleCoordByOrigin: (coord, origin) ->
        [x,y] = [(coord[0] - origin[0]) * @scale, (coord[1] - origin[1]) * @scale]

$ ->
    window._win = new Win()
