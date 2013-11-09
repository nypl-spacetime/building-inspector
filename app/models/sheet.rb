class Sheet < ActiveRecord::Base
	has_many :polygons, :dependent => :destroy
	attr_accessible :bbox, :map_id, :map_url, :status, :layer_id

	def mini(session_id = nil)
		# only the necessary data of a sheet's polygons
		if session_id != nil
			# all polygons with no consensus that a given session has not processed in a sheet
			Polygon.select("polygons.id, color, geometry, sheet_id, status, dn").joins("LEFT JOIN flags ON polygons.id = flags.polygon_id AND session_id = " + Sheet.sanitize(session_id) ).where("sheet_id = ? AND session_id IS NULL AND consensus IS NULL", self[:id])
		else
			# all polygons in a sheet
			Polygon.select("polygons.id, color, geometry, sheet_id, status, dn").where("sheet_id = ?", self[:id])
		end
	end

	def flags
		Flag.find_all_by_polygon_id(self.polygons, :order => :created_at)
	end
end
