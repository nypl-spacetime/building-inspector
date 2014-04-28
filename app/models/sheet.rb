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
end
