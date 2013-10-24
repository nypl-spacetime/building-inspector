var bboxstr = "-74.0045051,40.7558605,-73.994675,40.7627951";
var zoom = 20;

function tilesForBbox(bboxstring, zoom) {
	var bboxarr = bboxstring.split(",");
	if (bboxarr.length != 4) {
		return;
	}
	var bbox = new L.latLngBounds( new L.latLng(bboxarr[1], bboxarr[0]) , new L.latLng(bboxarr[3], bboxarr[2]) );
	// bbox = bbox.pad(10);
	var NW = bbox.getNorthWest();
	var SE = bbox.getSouthEast();
	var N = NW.lat;
	var S = SE.lat;
	var W = NW.lng;
	var E = SE.lng;
	var minX = long2tile(W,zoom);
	var maxX = long2tile(E,zoom);
	var minY = lat2tile(N,zoom);
	var maxY = lat2tile(S,zoom);
	
	var x, y;
	var result = [];
	for (x=minX; x<=maxX; x++) {
		for (y=minY; y<=maxY; y++) {
			result.push([zoom,x,y]);
		}
	}
	return result;
}

function long2tile(lon,zoom) { 
	return (Math.floor((lon+180)/360*Math.pow(2,zoom)));
}

function lat2tile(lat,zoom)  {
	return (Math.floor((1-Math.log(Math.tan(lat*Math.PI/180) + 1/Math.cos(lat*Math.PI/180))/Math.PI)/2 *Math.pow(2,zoom)));
}

function toRadians(deg) {
	return deg * Math.PI / 180;
}