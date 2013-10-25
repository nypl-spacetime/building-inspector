
var bboxstr = "-74.0045051,40.7558605,-73.994675,40.7627951";
var zoom = 18;

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

var tiles = tilesForBbox(bboxstr, zoom);

// DB stuff
var systemDB;

/* Initialize the systemDB global variable. */
(function () {
  try {
    if (!window.openDatabase) {
      console.log('not supported');
    } else {
      var shortName = 'building-inspector-local-db';
      var version = '1.0';
      var displayName = 'Building Inspector Local DB';
      var maxSize = 65536000; // in bytes
      var myDB = openDatabase(shortName, version, displayName, maxSize);
      console.log("database:",myDB);
    }
  } catch(e) {
    // Error handling code goes here.
    if (e == INVALID_STATE_ERR) {
      // Version number mismatch.
	    console.log("Invalid database version.");
    } else {
	    console.log("Unknown error "+e+".");
    }
    return;
  }
  createTables(myDB);
  systemDB = myDB;
})();

/*! Mark a file as "delete"*/
function reallyDelete(id) {
	// console.log('delete ID: '+id);
	var myDB = systemDB;
	myDB.transaction(
	    new Function("transaction", "transaction.executeSql('UPDATE files set deleted=1 where id=?;', [ " +id+" ], /* array of values for the ? placeholders */"+
			"deleteUpdateResults, errorHandler);")
	);
}

/*! Ask for user confirmation before deleting a file. */
function deleteFile(id) {
	var myDB = systemDB;
	myDB.transaction(
	    new Function("transaction", "transaction.executeSql('SELECT id,name from files where id=?;', [ "+id+" ], /* array of values for the ? placeholders */"+
			"function (transaction, results) {"+
				"if (confirm('Really delete '+results.rows.item(0)['name']+'?')) {"+
					"reallyDelete(results.rows.item(0)['id']);"+
				"}"+
			"}, errorHandler);")
	);
}

/* Create a new "file" in the database. */
function insertNewBlob(data, foldera, folderb, filename) {
	var myDB = systemDB;
	myDB.transaction(
		function (transaction) {
      transaction.executeSql('INSERT INTO filedata (datablob, folderA, folderB, filename) VALUES (?, ?, ?, ?);', [data, foldera, folderb, filename], nullDataHandler, errorHandler);
		}
	);
}

/*! This saves the contents of the file. */
function updateFileData(file) {
	var myDB = systemDB;
	myDB.transaction(function (transaction) {
			transaction.executeSql("UPDATE filedata set datablob=? where id=?;",[file, 88998], nullDataHandler, errorHandler); 
	});
  console.log(file + ' saved.');
}

/* This processes the data read from the database by loadFile and sets up the editing environment. */
function loadFileData(transaction, results) {
  //console.log(results.rows);
  for (var i = 0; i < results.rows.length; i++) {
    // Each row is a standard JavaScript array indexed by column names.
    var base64blob = results.rows.item(i);
    console.log(base64blob);
    var image = document.createElement('img');
    image.src = base64blob.datablob;
    document.body.appendChild(image);
  }
}

/* This loads a "file" from the database and calls loadFileData with the results. */
function loadFile(id) {
	//console.log('Loading file with id ' + id);
	var myDB = systemDB;
	myDB.transaction(function (transaction) {
    //transaction.executeSql('SELECT * FROM filedata;', [], loadFileData, errorHandler);
     transaction.executeSql('SELECT datablob FROM filedata WHERE id = ?;', [id], loadFileData, errorHandler);
		}
	);
}

/*! This creates the database tables. */
function createTables(db) {
/* To wipe out the table (if you are still experimenting with schemas,
   for example), enable this block. 
*/
  console.log("creating tables for", db);
  db.transaction(
    function (transaction) {
	    transaction.executeSql('DROP TABLE filedata;');
    }
  );
  
  db.transaction(
    function (transaction) {
      transaction.executeSql('CREATE TABLE IF NOT EXISTS filedata(id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, datablob TEXT NOT NULL DEFAULT "", folderA INTEGER NOT NULL, folderB INTEGER NOT NULL, filename INTEGER NOT NULL);', [], nullDataHandler, errorHandler);
    }
  ); 
}

/*! When passed as the error handler, this silently causes a transaction to fail. */
function killTransaction(transaction, error) {
	return true; // fatal transaction error
}

/*! When passed as the error handler, this causes a transaction to fail with a warning message. */
function errorHandler(transaction, error) {
    // Error is a human-readable string.
    console.log('Oops.  Error was '+error.message+' (Code '+error.code+')');
    // Handle errors here
    var we_think_this_error_is_fatal = true;
    if (we_think_this_error_is_fatal) return true;
    return false;
}

/* This is used as a data handler for a 
   request that should return no data. 
*/
function nullDataHandler(transaction, results) { 
  if (!results.rowsAffected) {
    // Previous insert failed. Bail.
    console.log('No rows affected!');
  }
  console.log('insert ID was '+results.insertId);
}

/* This sets up an onbeforeunload handler to avoid 
   accidentally navigating away from the
   page without saving changes. 
*/
function setupEventListeners() {
  window.onbeforeunload = function () {
	  return saveChangesDialog();
  };
}

function getBlobs(tiles) {
  var baseURL = "http://maptiles.nypl.org/859-final/"; 
  var imageType = "png";
  var count = 0;
  console.log("starting to fetch blobs");
  $.each(tiles, function (i, val) {
    count++;
    var path = 'http://pixelserver.herokuapp.com/getimagedata.json?url=' + baseURL + val[0] + "/" + val[1] + "/" + val[2] + "." + imageType;
    $.ajax({
      type: "GET",
      url: path,
      dataType: "jsonp",
      success: function (data) { 
        console.log(data);
        insertNewBlob(data.data, val[0], val[1], val[2]); 
      }});
  });
  console.log(count);
}

function getBlob(url) {

}

function truncateFileData() {
	var myDB = systemDB;
  myDB.transaction(function (transaction) {
			transaction.executeSql("DELETE FROM filedata;",[], nullDataHandler, errorHandler); 
	});
  console.log('All files removed.');
}

function setImage(id) {
  var blob = loadFile(id);
}

// truncateFileData();
// getBlobs(tiles);


