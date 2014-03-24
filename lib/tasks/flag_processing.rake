namespace :db do

  desc "Process consensus in POLYGONS (recurring)"
  task :calculate_consensus => :environment do
    min_count = 3
    threshold = 0.75
    # geometry
    yes_query = Flag.connection.execute(build_consensus_query_for_task_value("geometry", "yes", min_count, threshold))
    no_query = Flag.connection.execute(build_consensus_query_for_task_value("geometry", "no", min_count, threshold))
    fix_query = Flag.connection.execute(build_consensus_query_for_task_value("geometry", "fix", min_count, threshold))
    # colors
    pink_query = Flag.connection.execute(build_consensus_query_for_task_value("color", "pink", min_count, threshold))
    blue_query = Flag.connection.execute(build_consensus_query_for_task_value("color", "blue", min_count, threshold))
    yellow_query = Flag.connection.execute(build_consensus_query_for_task_value("color", "yellow", min_count, threshold))
    green_query = Flag.connection.execute(build_consensus_query_for_task_value("color", "green", min_count, threshold))
    black_query = Flag.connection.execute(build_consensus_query_for_task_value("color", "black", min_count, threshold))
  end

  def build_consensus_query_for_task_value(task, value, min_count, threshold)
    # given a task and a flag value (for simple flag values such as YES/NO/FIX)
    # and a given minimum flag count and threshold
    # determines all new polygons that should be considered as having consensus
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
    HAVING COUNT(*) >= #{min_count}
  ) AS F
  ON F.polygon_id = P.id
  INNER JOIN (
    SELECT _F.polygon_id, COUNT(*) AS flag_count
    FROM flags AS _F
    GROUP BY _F.polygon_id
    HAVING COUNT(*) >= #{min_count}
  ) AS FCOUNT
  ON FCOUNT.polygon_id = P.id
  WHERE
    C.id IS NULL AND
    F.flag_count::float / FCOUNT.flag_count::float >= #{threshold}"
  end

end