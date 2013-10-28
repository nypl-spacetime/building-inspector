class Sheet < ActiveRecord::Base
	has_many :polygons, :dependent => :destroy
	attr_accessible :bbox, :map_id, :map_url, :status

	def mini(session_id)
		Polygon.select("polygons.id, color, geometry, sheet_id, status, dn").joins("LEFT JOIN flags ON polygons.id = flags.polygon_id AND session_id = " + Sheet.sanitize(session_id) ).where("sheet_id = ? AND session_id IS NULL AND consensus IS NULL", self[:id])
	end
end
