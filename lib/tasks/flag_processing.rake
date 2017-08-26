namespace :db do

  desc "Process consensus in POLYGONS (recurring)"
  task :calculate_consensus => :environment do
    # geometry
    Flag.distinct_task_values("geometry").each do |value|
      Flag.connection.execute(build_polygon_consensus_query_for_task_value("geometry", value, 1))
    end
    # colors
    Flag.distinct_task_values("color").each do |value|
      Flag.connection.execute(build_polygon_consensus_query_for_task_value("color", value, 1))
    end
    # address == 'none'
    Flag.connection.execute(build_polygon_consensus_query_for_task_value("address", "NONE", 1))
  end

  desc "Process clustered consensus in ADDRESSES (more expensive, run nightly)"
  task :calculate_address_consensus => :environment do
    Sheet.process_consensus_clusters_for_task('address')
  end

  desc "Process clustered consensus in POLYGONFIX (somewhat expensive, run nightly)"
  task :calculate_polygonfix_consensus => :environment do
    Sheet.process_consensus_clusters_for_task('polygonfix')
  end

  desc "Process clustered consensus in TOPONYMS (somewhat expensive, run nightly)"
  task :calculate_toponym_consensus => :environment do
    Sheet.process_consensus_clusters_for_task('toponym')
  end

  def build_polygon_consensus_query_for_task_value(task, value, min_count = 3, threshold = 0.75, admin_multiplier = 4)
    # given a task and a flag value (for simple flag values such as YES/NO/FIX)
    # and a given minimum flag count and threshold
    # determines all new polygons that should be considered as having consensus
    "INSERT INTO consensuspolygons
  (consensus, task, flaggable_id, flaggable_type, created_at, updated_at)
  SELECT '#{value}' AS consensus, '#{task}' AS task, P.id AS polygon_id, 'Polygon', now(), now()
  FROM polygons AS P
  LEFT JOIN consensuspolygons AS C
  ON C.flaggable_id = P.id
  AND C.task = '#{task}'
  INNER JOIN (
    SELECT _F.flaggable_id, COUNT(*) AS flag_count, SUM(CASE WHEN _U.role = 'admin' THEN #{admin_multiplier} ELSE 1 END) AS flag_score
    FROM flags AS _F

    LEFT JOIN usersessions _S
    ON _S.session_id = _F.session_id
    LEFT JOIN users _U
    ON _U.id = _S.user_id

    WHERE _F.flag_value = '#{value}'
    AND _F.flag_type = '#{task}'
    AND _F.flaggable_type = 'Polygon'
    GROUP BY _F.flaggable_id
    HAVING COUNT(*) >= #{min_count}
  ) AS POSITIVE
  ON POSITIVE.flaggable_id = P.id
  INNER JOIN (
    SELECT _F.flaggable_id, COUNT(*) AS flag_count, SUM(CASE WHEN _U.role = 'admin' THEN #{admin_multiplier} ELSE 1 END) AS flag_score
    FROM flags AS _F

    LEFT JOIN usersessions _S
    ON _S.session_id = _F.session_id
    LEFT JOIN users _U
    ON _U.id = _S.user_id

    WHERE _F.flag_type = '#{task}'
    AND _F.flaggable_type = 'Polygon'
    GROUP BY _F.flaggable_id
    HAVING COUNT(*) >= #{min_count}
  ) AS TOTAL
  ON TOTAL.flaggable_id = P.id
  WHERE
    C.id IS NULL AND
    POSITIVE.flag_score::float / TOTAL.flag_score::float >= #{threshold}"
  end

end