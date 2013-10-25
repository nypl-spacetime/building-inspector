class OfflineDB
  constructor: () ->
    try
      if (!window.openDatabase)
        console.log "not supported."
      else
        shortName = 'building-inspector-local-db'
        version = '1.0'
        displayName = 'Building Inspector Local DB'
        maxSize = 65536000
        myDB = openDatabase shortName, version, displayName, maxSize
    catch error
      if (error == INVALID_STATE_ERR)
        console.log "Invalid database version"
      else
        console.log "Unknown error" + error + "."

    @createTables(myDB)
    @systemDB = myDB

  createTables: (db) ->
    console.log "creating tables for", db
    db.transaction((transaction) ->
      transaction.executeSql "DROP TABLE filedata;"
    )
    db.transaction((transaction) ->
      transaction.executeSql 'CREATE TABLE IF NOT EXISTS filedata(id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, datablob TEXT NOT NULL DEFAULT "", folderA INTEGER NOT NULL, folderB INTEGER NOT NULL, filename INTEGER NOT NULL);', [], @nullDataHandler, @errorHandler
    )

  loadFile: (id) ->
    @myDB.transaction (transaction) ->
      transaction.executeSql "SELECT datablob FROM filedata WHERE id = ?;", [id], loadFileData, errorHandler

  loadFileData: (transaction, results) ->
    for blob in results
      base64blob = results
      image = document.createElement 'img'
      image.src = base64blob.datablob
      document.body.appendChild image

  nullDataHandler: () ->
    if (!results.rowsAffected) 
      # Previous insert failed. Bail.
      console.log "No rows affected!"
    console.log "insert ID was " + results.insertId

  errorHandler: (transaction, error) ->
    console.log 'Oops.  Error was ' + error.message + ' (Code ' + error.code + ')'
    true

  getImages: (tiles) ->
    baseURL = "http://maptiles.nypl.org/859-final/"
    imageType = "png"
    console.log "starting to fetch blobs"
    t = @
    $.each tiles, (i, val) ->
      path = 'http://pixelserver.herokuapp.com/getimagedata.json?url=' + baseURL + val[0] + "/" + val[1] + "/" + val[2] + "." + imageType
      $.ajax(
        type: "GET"
        url: path
        dataType: "jsonp"
        success: (data) ->
          console.log data 
          t.insertNewBlob data.data, val[0], val[1], val[2]
      )
$ ->
  window._odb = new OfflineDB()
         
