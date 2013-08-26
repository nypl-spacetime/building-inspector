class Sheet < ActiveRecord::Base
	has_many :polygons, :dependent => :destroy
	attr_accessible :bbox, :map_id, :map_url, :status

	def mini(session_id)
		Polygon.select("polygons.id, color, geometry, sheet_id, status, dn").joins("LEFT JOIN flags ON polygons.id = flags.polygon_id").where("sheet_id = ? AND (session_id IS NULL OR session_id != ? )", self[:id], session_id)
	end
end
