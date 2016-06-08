class Sheet < ActiveRecord::Base
  has_many :polygons, :dependent => :destroy
  has_many :flags, as: :flaggable
  has_many :consensuspolygons, as: :flaggable, :dependent => :destroy
  belongs_to :layer
  attr_accessible :bbox, :map_id, :map_url, :layer_id

  def to_geojson
    { :type => "Feature", :properties => self, :geometry => { :type => "Polygon", :coordinates => bbox_to_poly } }
  end

  def bbox_to_poly
    coords = bbox.split ","
    west = coords[0].to_f
    south = coords[1].to_f
    east = coords[2].to_f
    north = coords[3].to_f
    [[[west,south],[west,north],[east,north],[east,south],[west,south]]]
  end

  def consensus(task="toponym")
    c = Consensuspolygon.where({:flaggable_id => id, :flaggable_type => "Sheet", :task => task}).first
    return "[]" if c == nil
    c[:consensus]
  end

  def self.polygons_for_task(sheet_id, session_id = nil, type="geometry")
    return [] if type == "toponym"
    # only the necessary data of a sheet's polygons
    sheet_id = Sheet.sanitize(sheet_id)
    session_id = Sheet.sanitize(session_id)
    if session_id != nil
      # find all the sessions associated to this session_id via its user_id if any
      join = "LEFT JOIN flags AS F ON polygons.id = F.flaggable_id
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
      join += "LEFT JOIN consensuspolygons AS CP ON polygons.id = CP.flaggable_id AND CP.flaggable_type = 'Polygon' AND CP.task = "+ Sheet.sanitize(type)
    when "address", "color"
      join += "INNER JOIN consensuspolygons AS CPG ON polygons.id = CPG.flaggable_id AND CPG.flaggable_type = 'Polygon' AND CPG.task = 'geometry' AND CPG.consensus = 'yes' LEFT JOIN consensuspolygons AS CP ON polygons.id = CP.flaggable_id AND CP.flaggable_type = 'Polygon' AND CP.task = " + Sheet.sanitize(type)
    when "polygonfix"
      join += "INNER JOIN consensuspolygons AS CPG ON polygons.id = CPG.flaggable_id AND CPG.flaggable_type = 'Polygon' AND CPG.task = 'geometry' AND CPG.consensus = 'fix' LEFT JOIN consensuspolygons AS CP ON polygons.id = CP.flaggable_id AND CP.flaggable_type = 'Polygon' AND CP.task = " + Sheet.sanitize(type)
    else
      join += "LEFT JOIN consensuspolygons AS CP ON polygons.id = CP.flaggable_id AND CP.flaggable_type = 'Polygon' AND CP.task = "+ Sheet.sanitize(type)
    end

    Polygon.select("polygons.id, polygons.color, polygons.geometry, polygons.sheet_id, polygons.dn, CP.consensus").joins(join).where(where)
  end

  def self.progress_for_task(sheet_id, type)
    sheet_id = Sheet.sanitize(sheet_id)
    type = Sheet.sanitize(type)

    columns = "DISTINCT polygons.id, geometry, sheet_id, CP.consensus, dn, centroid_lat, centroid_lon"
    join = "INNER JOIN flags AS F ON polygons.id = F.flaggable_id INNER JOIN consensuspolygons AS CP ON CP.flaggable_id = polygons.id AND CP.flaggable_type = 'Polygon' AND CP.task = #{type}"
    where = " sheet_id = #{sheet_id} "

    Polygon.select(columns).joins(join).where(where)
  end

  def self.random_unprocessed(type="geometry")
    join = " "
    case type
    when "geometry"
      # any sheet without consensus
      join = " "
    when "address", "color"
      # sheet has not been totally processed for addresses, colors
      join = "INNER JOIN consensuspolygons AS CPG ON polygons.id = CPG.flaggable_id AND CPG.flaggable_type = 'Polygon' AND CPG.task = 'geometry' AND CPG.consensus = 'yes'"
    when "polygonfix"
      # sheet has not been totally processed for geometry
      join = "INNER JOIN consensuspolygons AS CPG ON polygons.id = CPG.flaggable_id AND CPG.flaggable_type = 'Polygon' AND CPG.task = 'geometry' AND CPG.consensus = 'fix'"
    else
      # any sheet without consensus
      join = " "
    end
    join += " LEFT JOIN consensuspolygons AS CP ON CP.flaggable_id = polygons.id AND CP.flaggable_type = 'Polygon' AND CP.task = " + Sheet.sanitize(type)
    bunch = Polygon.select(:sheet_id).joins(join).where("CP.id IS NULL").uniq.limit(200)

    return nil unless bunch.count > 0

    chosen = bunch.sample
    Sheet.find(chosen[:sheet_id])
  end

  def flags
    Flag.find_all_by_flaggable_id_and_flaggable_type(self.polygons, 'Polygon', :order => :created_at)
  end

  def self.process_consensus_clusters_for_task(task)
    sheets = Sheet.all
    total = sheets.count
    progress = 0
    sheets.each do |s|
      if task == "address"
        s.calculate_address_consensus
      elsif task == "polygonfix"
        s.calculate_polygonfix_consensus
      elsif task == "toponym"
        s.calculate_toponym_consensus
      end
      progress = progress + 1
      puts "processed #{progress} of #{total}"
    end
  end

  def calculate_address_consensus
    puts "\n\nProcessing ADDRESS consensus for sheet #{self[:id]}"
    flags = Flag.flags_for_sheet_for_task(self[:id], "address")
    consensus = ConsensusUtils.calculate_address_consensus(flags)
    puts "Found #{consensus.count} consensus"
    consensus.each_pair do |elem,c|
      polygon_id = elem
      cp = Consensuspolygon.find_or_initialize_by_flaggable_id_and_flaggable_type_and_task(:flaggable_id => polygon_id, :flaggable_type => "Polygon", :task => 'address')
      cp[:consensus] = c.to_json
      if !cp.save
        puts "===============  Could not save address consensus with params: #{self}"
      end
    end
  end

  def calculate_toponym_consensus
    puts "\n\nProcessing TOPONYM consensus for sheet #{id}"
    flags = Flag.flags_for_sheet_for_task(id, "toponym", "Sheet")
    consensus = ConsensusUtils.calculate_toponym_consensus(flags)
    consensus.each_pair do |elem,c|
      puts "Found #{c.count} consensus"
      cp = Consensuspolygon.find_or_initialize_by_flaggable_id_and_flaggable_type_and_task(:flaggable_id => id, :flaggable_type => "Sheet", :task => 'toponym')
      cp[:consensus] = c.to_json
      if !cp.save
        # puts "===============  Could not save address consensus with params: #{self}"
      end
    end
  end

  def calculate_polygonfix_consensus
    # get all polygons that have 3 or more polygonfix flags
    puts "\n\nProcessing POLYGONFIX consensus for sheet #{self[:id]}"
    flags = Flag.flags_for_sheet_for_task_and_threshold(self[:id])
    pids = flags.map {|fl| fl["flaggable_id"]}.uniq
    pids.each do |pid|
      poly = Polygon.find(pid.to_i)
      poly.calculate_polygonfix_consensus
    end
  end

end
