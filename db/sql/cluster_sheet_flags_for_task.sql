CREATE OR REPLACE FUNCTION cluster_sheet_flags_for_task(radius numeric, sheet_id integer, task varchar)
    RETURNS SETOF record AS
$$
DECLARE
    lid_new    integer;
    dmn_number integer := 1;
    outr       record;
    innr       record;
    r          record;
BEGIN

    DROP TABLE IF EXISTS tmp;
    EXECUTE format('CREATE TEMPORARY TABLE tmp AS SELECT F.id AS id, F.polygon_id AS polygon_id, F.latitude, F.longitude, F.flag_value, ST_GeometryFromText('''||Concat('POINT(''||','latitude','||'' ''||','longitude','||'')')||''') AS geom FROM flags F, polygons P WHERE F.polygon_id = P.id AND P.sheet_id = %L AND F.flag_type = %L AND F.latitude IS NOT NULL AND F.longitude IS NOT NULL ', sheet_id, task);
    ALTER TABLE tmp ADD COLUMN dmn integer;
    ALTER TABLE tmp ADD COLUMN chk boolean DEFAULT FALSE;
    EXECUTE 'UPDATE tmp SET dmn = '||dmn_number||', chk = FALSE WHERE id = (SELECT MIN(id) FROM tmp)';

    LOOP
        LOOP
            FOR outr IN EXECUTE 'SELECT id AS gid, geom FROM tmp WHERE dmn = '||dmn_number||' AND NOT chk' LOOP
                FOR innr IN EXECUTE 'SELECT id AS gid, geom FROM tmp WHERE dmn IS NULL' LOOP
                    IF ST_DWithin(ST_Transform(ST_SetSRID(outr.geom, 4326), 3785), ST_Transform(ST_SetSRID(innr.geom, 4326), 3785), radius) THEN
                    --IF ST_DWithin(outr.geom, innr.geom, radius) THEN
                        EXECUTE 'UPDATE tmp SET dmn = '||dmn_number||', chk = FALSE WHERE id = '||innr.gid;
                    END IF;
                END LOOP;
                EXECUTE 'UPDATE tmp SET chk = TRUE WHERE id = '||outr.gid;
            END LOOP;
            SELECT INTO r dmn FROM tmp WHERE dmn = dmn_number AND NOT chk LIMIT 1;
            EXIT WHEN NOT FOUND;
       END LOOP;
       SELECT INTO r dmn FROM tmp WHERE dmn IS NULL LIMIT 1;
       IF FOUND THEN
           dmn_number := dmn_number + 1;
           EXECUTE 'UPDATE tmp SET dmn = '||dmn_number||', chk = FALSE WHERE id = (SELECT MIN(id) FROM tmp WHERE dmn IS NULL LIMIT 1)';
       ELSE
           EXIT;
       END IF;
    END LOOP;

    -- RETURN QUERY EXECUTE 'SELECT ST_ConvexHull(ST_Collect(geom)) FROM tmp GROUP by dmn';
    RETURN QUERY EXECUTE 'SELECT dmn, id, polygon_id, flag_value, latitude, longitude FROM tmp ORDER BY dmn';

    RETURN;
END
$$
LANGUAGE plpgsql;

-- USAGE:
-- SELECT * FROM cluster_sheet_flags_for_task(2, 203, 'address') AS g(dmn integer, id integer, polygon_id integer, flag_value text, latitude numeric, longitude numeric);