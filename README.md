## NYPL Labs Map Polygon fixer

Author: Mauricio Giraldo Arteaga / NYPL Labs

### First ingest

After downloading, and running the proper `rake db:migrate` you need to do a base ingest of data using the included rake task: `rake data_import:ingest_bulk force=true`