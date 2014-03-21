class Sheet < ActiveRecord::Base
  has_many :polygons, :dependent => :destroy
  attr_accessible :bbox, :map_id, :map_url, :status, :layer_id, :consensus, :consensus_address

  def polygons_for_task(type="geometry", session_id = nil)
    Sheet.polygons_for_task(self[:id], type, session_id)
  end

  def self.polygons_for_task(sheet_id, type="geometry", session_id = nil)
    # only the necessary data of a sheet's polygons
    sheet_id = Sheet.sanitize(sheet_id)
    if session_id != nil
      join = "LEFT JOIN flags AS F ON polygons.id = F.polygon_id AND F.session_id = "+Sheet.sanitize(session_id) + " "
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

  def self.progress_for_task(sheet_id, type, session_id = nil)
    sheet_id = Sheet.sanitize(sheet_id)

    columns = "polygons.id, geometry, sheet_id, CP.consensus, dn, centroid_lat, centroid_lon"
    join = "LEFT JOIN flags AS F ON polygons.id = F.polygon_id LEFT JOIN consensuspolygons AS CP ON CP.polygon_id = polygons.id AND CP.task = "+Sheet.sanitize(type)
    where = " sheet_id = #{sheet_id} "

    if session_id != nil
      where += " AND F.session_id = "+Sheet.sanitize(session_id) + " "
    end

    join += " "

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
    bunch = Polygon.select(:sheet_id).joins(join).where("CP.id IS NULL").limit(200)

    return nil unless bunch.count > 0

    chosen = bunch.sample
    Sheet.find(chosen[:sheet_id])
  end

  def flags
    Flag.find_all_by_polygon_id(self.polygons, :order => :created_at)
  end
end
