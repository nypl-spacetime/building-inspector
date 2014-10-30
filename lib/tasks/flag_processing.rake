namespace :db do

  desc "Process consensus in POLYGONS (recurring)"
  task :calculate_consensus => :environment do
    min_count = 3
    threshold = 0.75
    # geometry
    Flag.connection.execute(build_consensus_query_for_task_value("geometry", "yes", min_count, threshold))
    Flag.connection.execute(build_consensus_query_for_task_value("geometry", "no", min_count, threshold))
    Flag.connection.execute(build_consensus_query_for_task_value("geometry", "fix", min_count, threshold))
    # colors
    Flag.connection.execute(build_consensus_query_for_task_value("color", "pink", min_count, threshold))
    Flag.connection.execute(build_consensus_query_for_task_value("color", "blue", min_count, threshold))
    Flag.connection.execute(build_consensus_query_for_task_value("color", "yellow", min_count, threshold))
    Flag.connection.execute(build_consensus_query_for_task_value("color", "green", min_count, threshold))
    Flag.connection.execute(build_consensus_query_for_task_value("color", "gray", min_count, threshold))
    # multicolor
    Flag.connection.execute(build_consensus_query_for_task_value("color", "blue,green", min_count, threshold))
    Flag.connection.execute(build_consensus_query_for_task_value("color", "green,yellow", min_count, threshold))
    Flag.connection.execute(build_consensus_query_for_task_value("color", "blue,pink", min_count, threshold))
    Flag.connection.execute(build_consensus_query_for_task_value("color", "blue,yellow", min_count, threshold))
    Flag.connection.execute(build_consensus_query_for_task_value("color", "gray,pink", min_count, threshold))
    Flag.connection.execute(build_consensus_query_for_task_value("color", "pink,yellow", min_count, threshold))
    Flag.connection.execute(build_consensus_query_for_task_value("color", "green,pink,yellow", min_count, threshold))
    Flag.connection.execute(build_consensus_query_for_task_value("color", "green,pink", min_count, threshold))
    Flag.connection.execute(build_consensus_query_for_task_value("color", "blue,pink,yellow", min_count, threshold))
    # address
    Flag.connection.execute(build_consensus_query_for_task_value("address", "NONE", min_count, threshold))
  end

  desc "Process clustered consensus in ADDRESSES (more expensive, run nightly)"
  task :calculate_address_consensus => :environment do
    Sheet.process_consensus_clusters_for_task('address')
  end

  desc "Process clustered consensus in POLYGONFIX (somewhat expensive, run nightly)"
  task :calculate_polygonfix_consensus => :environment do
    Sheet.process_consensus_clusters_for_task('polygonfix')
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
    SELECT _F.flaggable_id, _F.flag_value, COUNT(*) AS flag_count
    FROM flags AS _F
    WHERE _F.flag_value = '#{value}'
    AND _F.flag_type = '#{task}'
    AND _F.flaggable_type = 'Polygon'
    GROUP BY _F.flaggable_id, _F.flag_value
    HAVING COUNT(*) >= #{min_count}
  ) AS F
  ON F.flaggable_id = P.id
  INNER JOIN (
    SELECT _F.flaggable_id, COUNT(*) AS flag_count
    FROM flags AS _F
    WHERE _F.flag_type = '#{task}'
    AND _F.flaggable_type = 'Polygon'
    GROUP BY _F.flaggable_id
    HAVING COUNT(*) >= #{min_count}
  ) AS FCOUNT
  ON FCOUNT.flaggable_id = P.id
  WHERE
    C.id IS NULL AND
    F.flag_count::float / FCOUNT.flag_count::float >= #{threshold}"
  end

end