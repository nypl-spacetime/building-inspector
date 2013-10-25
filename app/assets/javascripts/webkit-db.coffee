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
    createTables(myDB)
    systemDB = myDB
    @myFunc()
    
  myFunc: () ->
    console.log @systemDB
    
$ ()->
  thing = new OfflineDB()
         
