class bBox
  bboxstr: "-74.0045051,40.7558605,-73.994675,40.7627951"
  zoom: 18
  getTiles: (bboxstr, zoom) ->
    bboxarr = bboxstring.split ","
    if (bboxarr.length != 4) 
		  true
    bbox = new L.latLngBounds(new L.latLng(bboxarr[1], bboxarr[0]) , new L.latLng(bboxarr[3], bboxarr[2]))
    NW = bbox.getNorthWest()
    SE = bbox.getSouthEast()
    N = NW.lat
    S = SE.lat
    W = NW.lng
    E = SE.lng
    minX = long2tile W, zoom
    maxX = long2tile E, zoom
    minY = lat2tile N, zoom
    maxY = lat2tile S, zoom
    for y in [minY..maxY]
      do(y) ->
        result.push [zoom, x, y] for x in [minX..maxX]
	  result

  log2tile: (lon, zoom) ->
    (Math.floor((lon+180)/360*Math.pow(2,zoom)))

  lat2tile: (lat, zoom) ->
    (Math.floor((1-Math.log(Math.tan(lat*Math.PI/180) + 1/Math.cos(lat*Math.PI/180))/Math.PI)/2 *Math.pow(2,zoom)))

  toRadians: (deg) ->
    deg * Math.PI / 180
