## NYPL Labs Map Polygon fixer

Authors: [Mauricio Giraldo Arteaga] / NYPL Labs

### First ingest

After downloading, and running the proper `rake db:migrate` you need to do a base ingest of data using the included rake task.

####All sheet data ingest

`rake data_import:ingest_bulk force=true`

This assumes the presence of `public/files/config-ingest.json` with a list of IDs and bounding boxes to import. This **erases all sheet/polygon/flag data** for those IDs in the config file.

#####Add bulk centroids

The original GeoJSON files do not have centroids (they were added and processed later). To create the centroids of the polygons in the database you need to run:

`rake data_import:ingest_centroid_bulk force=true`

####Single sheet data ingest

`rake data_import:ingest_geojson id=SOMEID bb=SOMEBOUNDINGBOX force=true`

This imports polygons from a file `public/files/SOMEID-traced.json` into the database **replacing** any polygons (and its corresponding flags) that are associated to ID `SOMEID`.

### API querying

The following API endpoints have been added to export the inspection consensus process (paginated by groups of 500). Consensus is defined by **agreement of 75% or more of three or more votes**:

- `/api/polygons/all/page/PAGENUMBER` returns all polygons in `PAGENUMBER` regardless of their consensus falue.
- `/api/polygons/yes/page/PAGENUMBER` returns all polygons in `PAGENUMBER` that have been marked as correct.
- `/api/polygons/no/page/PAGENUMBER` returns all polygons in `PAGENUMBER` that have been marked as *not buildings*.
- `/api/polygons/fix/page/PAGENUMBER` returns all polygons in `PAGENUMBER` that need to be fixed.


[Mauricio Giraldo Arteaga]: https://twitter.com/mgiraldo
