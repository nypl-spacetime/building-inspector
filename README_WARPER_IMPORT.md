# Importing Map Warper layers into Building Inspector

 1. Download the map sheets corresponding to the layer, using `mapwarperdownloader.py`. Each map will have a `TIF` file named after its `id` (eg: `21009.tif`)

 2. Group the sheets under a folder named after the `id` of the layer (eg: `1148/21009.tif`)

 3. Calibrate the Map Vectorizer according to instructions in the [README](https://github.com/nypl/map-vectorizer/blob/master/README.md) and save the parameters in a configuration file inside the sheet folder for safe keeping (eg: `1148/config-1148.txt`)

 4. Run the Map Vectorizer on the entire folder according to [instructions](https://github.com/nypl/map-vectorizer/blob/master/README.md#configuring):

     `./vectorize_map.py -p 1148/config-1148.txt 1148`

 5. Copy the resulting traced JSON output of each sheet to the Building Inspector `public/files/` folder:

     `cp 1148/*/*.json /path/to/app/public/files`

 6. Run the `ingestor_config_builder.py` ingest configuration file creator on the sheets:

    `./ingestor_config_builder.py 1148`

 7. Add `year(s)`, `description`, `tileset_type`, `tilejson`, and `name` to the ingest configuration file

 8. Test the ingest process locally (`force=true` omitted from example to avoid copy/paste snafus):

    `rake data_import:ingest_bulk id=1148`

 8. Commit and push the configuration and JSON files in the Building Inspector repository

 9. Push the code to the staging server and run the ingest script (note `-a bistage` which specifies the staging instance):

     `heroku run rake data_import:ingest_bulk id=1148 -a bistage`

 10. Test that everything works fine

 11. Push the code to the production server and run the scripts

 10. Profit!
