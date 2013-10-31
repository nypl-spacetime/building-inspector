class Polygon < ActiveRecord::Base
	has_many :flags, :dependent => :destroy
	belongs_to :sheet
	attr_accessible :color, :geometry, :sheet_id, :status, :vectorizer_json, :dn, :centroid_lat, :centroid_lon, :consensus

	def self.grouped_by_sheet
		Polygon.select("COUNT(polygons.id) AS polygon_count, sheet_id, sheets.bbox").joins(:sheet).where("consensus IS NOT NULL").group("polygons.sheet_id, sheets.bbox")
	end
end
