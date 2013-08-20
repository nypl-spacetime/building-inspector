$(document).ready(function() {
	var map = L.mapbox.map('map', 'nypllabs.map-ad8d242u', {zoomControl: false, animate: true, attributionControl: false});

	map.on('load', getPolygons);//.setView([40.709,-74.012], 19);

	window.map = map;

	var popup = L.popup();

	var polyData;

	var currentIndex = -1;
	var currentPolygon = {};

	var geo = newGeo();

	function newGeo() {
		var geo = L.geoJson({features:[]},{
			style: function (feature) {
				return {
					color: '#900'
					,weight: 5
					,opacity: 1
					,dashArray: '5,10'
					,fill: false
				};
			},
			onEachFeature:function (f,l){
				var out = [];
				if (f.properties){
					for(var key in f.properties){
						out.push(key+": "+f.properties[key]);
					}
					l.bindPopup(out.join("<br />"));
				}
			}
		});
		return geo;
	}

	function getPolygons() {
		$.getJSON('/files/7130-traced.shp.json', function(data) {
			// console.log(data);
			polyData = data;
			$("#yes-button").on("click", showNextPolygon);
			$("#no-button").on("click", showNextPolygon);
			$("#fix-button").on("click", showNextPolygon);
			showNextPolygon();
		});
	}
	
	function showNextPolygon() {
		currentIndex++;
		map.removeLayer(geo);
		if (currentIndex < polyData.features.length) {
			currentPolygon = polyData.features[currentIndex];
			geo = newGeo();
			geo.addData(currentPolygon);
			// center on the polygon
			var l = currentPolygon.geometry.coordinates[0].length;
			var midpoint = Math.floor(l/2);
			var centroid = [currentPolygon.geometry.coordinates[0][midpoint][0], currentPolygon.geometry.coordinates[0][midpoint][1]]; // computeCentroid(currentPolygon.geometry.coordinates[0]);
			geo.addTo(map);
			// console.log(geo, centroid);
			map.panTo( [ centroid[1], centroid[0] ] );
		}
	}

	function onMapClick(e) {
		popup
			.setLatLng(e.latlng)
			.setContent("You clicked the map at " + e.latlng.toString())
			.openOn(map);
	}

	function area(pts) {
		var area=0;
		var nPts = pts.length;
		var j=nPts-1;
		var p1; var p2;

		for (var i=0;i<nPts;j=i++) {
			p1=pts[i]; p2=pts[j];
			area+=p1[0]*p2[1];
			area-=p1[1]*p2[0];
		}
		area/=2;
		
		return area;
	};

	function computeCentroid(pts) {
		var nPts = pts.length;
		var x=0; var y=0;
		var f;
		var j=nPts-1;
		var p1; var p2;

		for (var i=0;i<nPts;j=i++) {
			p1=pts[i]; p2=pts[j];
			f=p1[0]*p2[1]-p2[0]*p1[1];
			x+=(p1[0]+p2[0])*f;
			y+=(p1[1]+p2[1])*f;
		}

		f=area(pts)*6;
		
		return [x/f, y/f];
	};
		

	map.on('click', onMapClick);
});

