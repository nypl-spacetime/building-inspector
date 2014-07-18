class Sheet < ActiveRecord::Base
  has_many :polygons, :dependent => :destroy
  attr_accessible :bbox, :map_id, :map_url, :status, :layer_id, :consensus, :consensus_address

  def polygons_for_task(session_id = nil, type="geometry")
    Sheet.polygons_for_task(self[:id], session_id, type)
  end

  def self.polygons_for_task(sheet_id, session_id = nil, type="geometry")
    # only the necessary data of a sheet's polygons
    sheet_id = Sheet.sanitize(sheet_id)
    session_id = Sheet.sanitize(session_id)
    if session_id != nil
      # find all the sessions associated to this session_id via its user_id if any
      join = "LEFT JOIN flags AS F ON polygons.id = F.polygon_id
              AND F.session_id IN (
                SELECT #{session_id}
                UNION
                  SELECT _S.session_id
                  FROM (
                    SELECT __S.user_id FROM usersessions __S
                    WHERE __S.session_id = #{session_id}
                    AND __S.user_id IS NOT NULL
                  ) S
                  INNER JOIN usersessions _S
                  ON _S.user_id = S.user_id
              )"
      where = "sheet_id = #{sheet_id} AND F.session_id IS NULL AND CP.id IS NULL"
    else
      join = " "
      where = "sheet_id = #{sheet_id} AND CP.id IS NULL"
    end

    case type
    when "geometry"
      join += "LEFT JOIN consensuspolygons AS CP ON polygons.id = CP.polygon_id AND CP.task = "+ Sheet.sanitize(type)
    when "address", "color"
      join += "INNER JOIN consensuspolygons AS CPG ON polygons.id = CPG.polygon_id AND CPG.task = 'geometry' AND CPG.consensus = 'yes' LEFT JOIN consensuspolygons AS CP ON polygons.id = CP.polygon_id AND CP.task = " + Sheet.sanitize(type)
    when "polygonfix"
      join += "INNER JOIN consensuspolygons AS CPG ON polygons.id = CPG.polygon_id AND CPG.task = 'geometry' AND CPG.consensus = 'fix' LEFT JOIN consensuspolygons AS CP ON polygons.id = CP.polygon_id AND CP.task = " + Sheet.sanitize(type)
    end

    Polygon.select("polygons.id, polygons.color, polygons.geometry, polygons.sheet_id, polygons.status, polygons.dn, CP.consensus").joins(join).where(where)
  end

  def self.progress_for_task(sheet_id, type)
    sheet_id = Sheet.sanitize(sheet_id)
    type = Sheet.sanitize(type)

    columns = "polygons.id, geometry, sheet_id, CP.consensus, dn, centroid_lat, centroid_lon"
    join = "LEFT JOIN flags AS F ON polygons.id = F.polygon_id LEFT JOIN consensuspolygons AS CP ON CP.polygon_id = polygons.id AND CP.task = #{type}"
    where = " sheet_id = #{sheet_id} "

    poly = Polygon.select(columns).joins(join).where(where)

  end

  def self.random_unprocessed(type="geometry")
    join = " "
    case type
    when "geometry"
      # any sheet without consensus
      join = " "
    when "address", "color"
      # sheet has not been totally processed for addresses, colors
      join = "INNER JOIN consensuspolygons AS CPG ON polygons.id = CPG.polygon_id AND CPG.task = 'geometry' AND CPG.consensus = 'yes'"
    when "polygonfix"
      # sheet has not been totally processed for geometry
      join = "INNER JOIN consensuspolygons AS CPG ON polygons.id = CPG.polygon_id AND CPG.task = 'geometry' AND CPG.consensus = 'fix'"
    end
    join += " LEFT JOIN consensuspolygons AS CP ON CP.polygon_id = polygons.id AND CP.task = " + Sheet.sanitize(type)
    bunch = Polygon.select(:sheet_id).joins(join).where("CP.id IS NULL").uniq.limit(200)

    return nil unless bunch.count > 0

    chosen = bunch.sample
    Sheet.find(chosen[:sheet_id])
  end

  def flags
    Flag.find_all_by_polygon_id(self.polygons, :order => :created_at)
  end

  def self.process_consensus_clusters_for_task(task)
    sheets = Sheet.all
    sheets.each do |s|
      s.save_consensus_clusters_for_task(task)
    end
  end

  def save_consensus_clusters_for_task(task)
    # different name from class method to avoid mistyping
    puts "-- Finding #{task} consensus for sheet id: #{self[:id]} --"
    if task == "address"
      address_consensus = self.consensus_clusters_for_address
      puts "Found #{address_consensus.count} consensus for task #{task}"
      address_consensus.each_pair do |elem,c|
        polygon_id = elem.to_i
        cp = Consensuspolygon.find_or_initialize_by_polygon_id_and_task(:polygon_id => polygon_id, :task => task)
        cp[:consensus] = c.to_json
        if !cp.save
          puts "===============  Could not save #{task} consensus with params: #{params}"
        end
      end
    elsif task == "polygonfix"
      # get all polygons that have 3 or more polygonfix flags
      flags = Flag.flags_for_sheet_for_task(self[:id])
      pids = flags.map {|fl| fl["polygon_id"].to_i}
      polys = []
      pids.each do |pid|
        polyflags = flags.select { |fl| fl["polygon_id"] = pid }
        features = polyflags.map { |item| { :type => "Feature", :properties => { :id => pid }, :geometry => { :type=>"Polygon", :coordinates => JSON.parse(item["flag_value"]) } } }
        geo = { :type => "FeatureCollection", :features => features }
        consensus = GeoJsonUtils.calculate_polygonfix_consensus(geo.to_json)
        # save it
        cp = Consensuspolygon.find_or_initialize_by_polygon_id_and_task(:polygon_id => pid, :task => task)
        cp[:consensus] = consensus.to_json
        if !cp.save
          puts "===============  Could not save #{task} consensus with params: #{params}"
        end
      end
    end
  end

  def calculate_polygonfix_consensus(geo)
  end

  def consensus_clusters_for_address(min_count=3, threshold=0.75)
    task = 'address'
    cluster_records = self.clusters_for_task(task)
    # organize clusters as a hash of arrays (one array per cluster)
    clusters = {}
    cluster_records.each do |c|
      dmn = c["dmn"]
      if clusters[dmn] == nil
        clusters[dmn] = []
      end
      clusters[dmn].push(c)
    end
    # find consensus in cluster for those with 3 or more votes
    # NOTE:
    # since some flags will not belong to the 'right' polygon_id
    # we find the most popular polygon_id from the cluster
    # so we avoid doing a BIG GIS nearest neighbor calculation
    address_consensus = {}
    clusters.each_pair do |elem,c|
      if c.count < min_count
        next
      end
      total_votes = 0
      tally = {} # saves the address popularity
      ids = {} # saves the polygon_id popularity
      session_ids = []
      c.each do |vote|
        value = vote["flag_value"]
        id = vote["polygon_id"]
        sid = vote["session_id"]
        # ignore vote if session_id already exists
        # to reduce trolling
        if session_ids.index(sid) != nil
          next
        end
        session_ids.push(sid)
        # now tally values
        if tally[value] == nil
          tally[value] = 0
        end
        if ids[id] == nil
          ids[id] = 0
        end
        tally[value] = tally[value] + 1
        ids[id] = ids[id] + 1
        total_votes = total_votes + 1
      end
      # in case there was trolling
      if total_votes < min_count
        next
      end
      # sort tally by value
      tally_sorted = tally.sort_by { |value,votes| votes }
      # sort tally by value
      ids_sorted = ids.sort_by { |id,count| count }
      # and the winner is...
      winner_address = tally_sorted.last
      winner_id = ids_sorted.last

      votes = winner_address[1].to_i
      consensus = votes.to_f/total_votes.to_f
      polygon_id = winner_id[0].to_i
      flag_value = winner_address[0]
      latitude = c[0]["latitude"] # TODO: this should be some sort of average
      longitude = c[0]["longitude"] # TODO: this should be some sort of average

      # check if consensus is above threshold
      if consensus > threshold
        if address_consensus[polygon_id.to_s] == nil
          address_consensus[polygon_id.to_s] = []
        end
        winner_mark = {}
        winner_mark[:latitude] = latitude
        winner_mark[:longitude] = longitude
        winner_mark[:flag_value] = flag_value
        winner_mark[:votes] = votes
        winner_mark[:total_votes] = total_votes
        winner_mark[:polygon_id] = polygon_id
        address_consensus[polygon_id.to_s].push(winner_mark)
      end
    end
    # now we group the addresses by polygons (many addresses - 1 polygon)

    address_consensus
  end

  def clusters_for_task(task, radius=3)
    # NOTE: only working for task = 'address'
    # returns flags clustered by the distance radius (in meters) as a recordset
    # see: /db/sql/cluster_sheet_flags_for_task.sql
    sql = "SELECT * FROM cluster_sheet_flags_for_task(#{radius}, #{self.id}, '#{task}') AS g(dmn integer, id integer, polygon_id integer, session_id varchar, flag_value text, latitude numeric, longitude numeric)"
    r = Flag.connection.execute(sql)
    r
  end

end
