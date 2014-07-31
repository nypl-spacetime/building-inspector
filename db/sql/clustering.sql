-- example clustering query/algo
-- based on http://gis.stackexchange.com/a/11807/18778

CREATE OR REPLACE FUNCTION get_domains_n(lname varchar, lat varchar, lon varchar, gid varchar, radius numeric, filtercol varchar, filterval varchar, excludecol varchar, excludeval varchar)
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
    EXECUTE 'CREATE TEMPORARY TABLE tmp AS SELECT '||gid||', ST_GeometryFromText('''||Concat('POINT(''||',lat,'||'' ''||',lon,'||'')')||''') AS geom '||' FROM '||lname||' WHERE '||excludecol||' != '''||excludeval||''' AND '||filtercol||'='''||filterval||''' ';
    ALTER TABLE tmp ADD COLUMN dmn integer;
    ALTER TABLE tmp ADD COLUMN chk boolean DEFAULT FALSE;
    EXECUTE 'UPDATE tmp SET dmn = '||dmn_number||', chk = FALSE WHERE '||gid||' = (SELECT MIN('||gid||') FROM tmp)';

    LOOP
        LOOP
            FOR outr IN EXECUTE 'SELECT '||gid||' AS gid, geom FROM tmp WHERE dmn = '||dmn_number||' AND NOT chk' LOOP
                FOR innr IN EXECUTE 'SELECT '||gid||' AS gid, geom FROM tmp WHERE dmn IS NULL' LOOP
                    IF ST_DWithin(ST_Transform(ST_SetSRID(outr.geom, 4326), 3785), ST_Transform(ST_SetSRID(innr.geom, 4326), 3785), radius) THEN
                    --IF ST_DWithin(outr.geom, innr.geom, radius) THEN
                        EXECUTE 'UPDATE tmp SET dmn = '||dmn_number||', chk = FALSE WHERE '||gid||' = '||innr.gid;
                    END IF;
                END LOOP;
                EXECUTE 'UPDATE tmp SET chk = TRUE WHERE '||gid||' = '||outr.gid;
            END LOOP;
            SELECT INTO r dmn FROM tmp WHERE dmn = dmn_number AND NOT chk LIMIT 1;
            EXIT WHEN NOT FOUND;
       END LOOP;
       SELECT INTO r dmn FROM tmp WHERE dmn IS NULL LIMIT 1;
       IF FOUND THEN
           dmn_number := dmn_number + 1;
           EXECUTE 'UPDATE tmp SET dmn = '||dmn_number||', chk = FALSE WHERE '||gid||' = (SELECT MIN('||gid||') FROM tmp WHERE dmn IS NULL LIMIT 1)';
       ELSE
           EXIT;
       END IF;
    END LOOP;

    -- RETURN QUERY EXECUTE 'SELECT ST_ConvexHull(ST_Collect(geom)) FROM tmp GROUP by dmn';
    RETURN QUERY EXECUTE 'SELECT dmn, '||gid||' FROM tmp ORDER BY dmn';

    RETURN;
END
$$
LANGUAGE plpgsql;

-- USAGE:
-- SELECT * FROM get_domains_n('flags', 'latitude', 'longitude', 'id', 2, 'flag_type', 'address', 'flag_value', 'NONE') AS g(dmn integer, id integer);