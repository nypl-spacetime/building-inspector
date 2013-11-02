## NYPL Labs Map Polygon fixer

Authors: [Mauricio Giraldo Arteaga] / NYPL Labs

### First ingest

After downloading, and running the proper `rake db:migrate` you need to do a base ingest of data using the included rake task.

####All sheet data ingest

`rake data_import:ingest_bulk id=LAYERID force=true`

This assumes the presence of `public/files/config-ingest-LAYERID.json` with a list of IDs and bounding boxes to import for the layer `LAYERID`. This **erases all sheet/polygon/flag data** for those IDs in the config file.

#####Add bulk centroids

The original GeoJSON files do not have centroids (they were added and processed later). To create the centroids of the polygons in the database you need to run:

`rake data_import:ingest_centroid_bulk force=true`

####Single sheet data ingest

`rake data_import:ingest_geojson id=SOMEID layer_id=SOMELAYERID bbox=SOMEBOUNDINGBOX force=true`

This imports polygons from a file `public/files/SOMEID-traced.json` into the database **replacing** any polygons (and its corresponding flags) that are associated to ID `SOMEID`. 

**NOTE:** So far only layers 859 and 860 are provided. Layer 859 has separate GeoJSON for centroids and polygons. Layer 860 sheets have a single file with both fields. Ingesting 859 requires a separate `data_import:ingest_centroid_bulk` process for centroids.

### API querying

The following API endpoints have been added to export the inspection consensus process (paginated by groups of 500). Consensus is defined by **agreement of 75% or more of three or more votes**:

#### Polygon export → /api/polygons/:type/page/:page

Accepts types: `all`, `yes`, `no`, `fix` with numeric paging (500 records per page).

- `/api/polygons/all/page/PAGENUMBER` returns all polygons in `PAGENUMBER` regardless of their consensus value.
- `/api/polygons/yes/page/PAGENUMBER` returns all polygons in `PAGENUMBER` that have been marked as *correct*.
- `/api/polygons/no/page/PAGENUMBER` returns all polygons in `PAGENUMBER` that have been marked as *not buildings*.
- `/api/polygons/fix/page/PAGENUMBER` returns all polygons in `PAGENUMBER` that need to be *fixed*.


[Mauricio Giraldo Arteaga]: https://twitter.com/mgiraldo
