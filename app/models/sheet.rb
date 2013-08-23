class Sheet < ActiveRecord::Base
	has_many :polygons, :dependent => :destroy
	attr_accessible :bbox, :map_id, :map_url, :status

	def mini
		Polygon.select("id, color, geometry, sheet_id, status, dn").where(:sheet_id => self[:id])
	end
end
