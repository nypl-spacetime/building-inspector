namespace :db do

  desc "Process consensus in POLYGONS (recurring)"
  task :calculate_consensus => :environment do
    # geometry
    yes_query = Flag.connection.execute(build_query_for_task_value("geometry", "yes", 0.75))
    no_query = Flag.connection.execute(build_query_for_task_value("geometry", "no", 0.75))
    fix_query = Flag.connection.execute(build_query_for_task_value("geometry", "fix", 0.75))
    # colors
    pink_query = Flag.connection.execute(build_query_for_task_value("color", "pink", 0.75))
    blue_query = Flag.connection.execute(build_query_for_task_value("color", "blue", 0.75))
    yellow_query = Flag.connection.execute(build_query_for_task_value("color", "yellow", 0.75))
    green_query = Flag.connection.execute(build_query_for_task_value("color", "green", 0.75))
    black_query = Flag.connection.execute(build_query_for_task_value("color", "black", 0.75))
  end

  def build_query_for_task_value(task, value, threshold)
    "INSERT INTO consensuspolygons
  (consensus, task, polygon_id, created_at, updated_at)
  SELECT '#{value}' AS consensus, '#{task}' AS task, P.id AS polygon_id, now(), now()
  FROM polygons AS P
  LEFT JOIN consensuspolygons AS C
  ON C.polygon_id = P.id
  AND C.task = '#{task}'
  INNER JOIN (
    SELECT _F.polygon_id, _F.flag_value, COUNT(*) AS flag_count
    FROM flags AS _F
    WHERE _F.flag_value = '#{value}'
    GROUP BY _F.polygon_id, _F.flag_value
    HAVING COUNT(*) >= 3
  ) AS F
  ON F.polygon_id = P.id
  INNER JOIN (
    SELECT _F.polygon_id, COUNT(*) AS flag_count
    FROM flags AS _F
    GROUP BY _F.polygon_id
    HAVING COUNT(*) >= 3
  ) AS FCOUNT
  ON FCOUNT.polygon_id = P.id
  WHERE
    C.id IS NULL AND
    F.flag_count::float / FCOUNT.flag_count::float >= #{threshold}"
  end

end