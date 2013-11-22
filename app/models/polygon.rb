class Polygon < ActiveRecord::Base
	has_many :flags, :dependent => :destroy
	belongs_to :sheet
	attr_accessible :color, :geometry, :sheet_id, :status, :vectorizer_json, :dn, :centroid_lat, :centroid_lon, :consensus, :flag_count

	def self.grouped_by_sheet
		Polygon.select("COUNT(polygons.id) AS polygon_count, sheet_id, sheets.bbox").joins(:sheet).group("polygons.sheet_id, sheets.bbox")
	end

	def to_geojson
	   { :type => "Feature", :properties => { :consensus => self[:consensus], :id => self[:id], :dn => self[:dn], :sheet_id => self[:sheet_id] }, :geometry => { :type => "Polygon", :coordinates => JSON.parse(self[:geometry]) } }
	end

	def as_feature
	   { :type => "FeatureCollection", :features => [JSON.parse(self[:vectorizer_json])] }
	end
end
