class Sheet < ActiveRecord::Base
	has_many :polygons, :dependent => :destroy
	attr_accessible :bbox, :map_id, :map_url, :status, :layer_id, :consensus, :consensus_numbers

	def mini(session_id = nil, type="geometry")
		# only the necessary data of a sheet's polygons
		if session_id != nil
			# all polygons with no consensus that a given session has not processed in a sheet
			case type
			when "geometry"
				Polygon.select("polygons.id, color, geometry, sheet_id, status, dn, flag_count, consensus, consensus_numbers").joins("LEFT JOIN flags ON polygons.id = flags.polygon_id AND session_id = " + Sheet.sanitize(session_id) ).where("sheet_id = ? AND session_id IS NULL AND polygons.flag_count < 10 AND polygons.consensus IS NULL", self[:id])
			when "numbers"
				Polygon.select("polygons.id, color, geometry, sheet_id, status, dn, flag_count, consensus, consensus_numbers").joins("LEFT JOIN flags ON polygons.id = flags.polygon_id AND session_id = " + Sheet.sanitize(session_id) ).where("sheet_id = ? AND session_id IS NULL AND polygons.consensus_numbers IS NULL AND polygons.consensus = 'yes'", self[:id])
			when "polygonfix"
				Polygon.select("polygons.id, color, geometry, sheet_id, status, dn, flag_count, consensus, consensus_polygonfix").joins("LEFT JOIN flags ON polygons.id = flags.polygon_id AND session_id = " + Sheet.sanitize(session_id) ).where("sheet_id = ? AND session_id IS NULL AND polygons.consensus_polygonfix IS NULL AND polygons.consensus = 'yes'", self[:id])
			end
		else
			# all polygons in a sheet
			case type
			when "geometry"
				Polygon.select("polygons.id, color, geometry, sheet_id, status, dn, flag_count, consensus, consensus_numbers").where("sheet_id = ? AND polygons.flag_count < 10 AND polygons.consensus IS NULL", self[:id])
			when "numbers"
				Polygon.select("polygons.id, color, geometry, sheet_id, status, dn, flag_count, consensus, consensus_numbers").where("sheet_id = ? AND polygons.flag_count < 10 AND polygons.consensus_numbers IS NULL AND polygons.consensus = 'yes'", self[:id])
			when "polygonfix"
				Polygon.select("polygons.id, color, geometry, sheet_id, status, dn, flag_count, consensus, consensus_polygonfix").where("sheet_id = ? AND polygons.flag_count < 4 AND polygons.consensus_polygonfix IS NULL AND polygons.consensus = 'yes'", self[:id])
			end
		end
	end

	def self.random_unprocessed(type="geometry")
		w = "consensus IS NULL"
		case type
		when "geometry"
			# any sheet without consensus
			w = "consensus IS NULL"
		when "numbers"
			# sheet has not been totally processed for addresses
			w = "consensus_numbers IS NULL AND consensus = 'done'"
		when "polygonfix"
			# sheet has not been totally processed for geometry
			w = "consensus_polygonfix IS NULL AND consensus = 'done'"
		end
		# TODO: SOME SORT OF CHECK FOR WHEN THINGS ARE ALMOST COMPLETE
		#       TO PREVENT DDOS VIA RETRIES
		c = Sheet.where(w).count
		Sheet.where(w).find(:first, :offset =>rand(c))
	end

	def flags
		Flag.find_all_by_polygon_id(self.polygons, :order => :created_at)
	end
end
