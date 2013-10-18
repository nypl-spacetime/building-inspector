## NYPL Labs Map Polygon fixer

Authors: [Mauricio Giraldo Arteaga] / NYPL Labs

### First ingest

After downloading, and running the proper `rake db:migrate` you need to do a base ingest of data using the included rake task.

####All sheet data ingest

`rake data_import:ingest_bulk force=true`

This assumes the presence of `public/files/config-ingest.json` with a list of IDs and bounding boxes to import. This **erases all sheet/polygon/flag data** for those IDs in the config file.

####Single sheet data ingest

`rake data_import:ingest_geojson id=SOMEID bb=SOMEBOUNDINGBOX force=true`

This imports polygons from a file `public/files/SOMEID-traced.json` into the database **replacing** any polygons (and its corresponding flags) that are associated to ID `SOMEID`.

[Mauricio Giraldo Arteaga]: https://twitter.com/mgiraldo