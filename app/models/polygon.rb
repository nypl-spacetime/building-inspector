class Polygon < ActiveRecord::Base
	has_many :flags, :dependent => :destroy
	belongs_to :sheet
	attr_accessible :color, :geometry, :sheet_id, :status, :vectorizer_json, :dn, :centroid_lat, :centroid_lon, :consensus, :flag_count, :consensus_address

	def self.grouped_by_sheet(type="geometry")
		w = "1=1"
		if type == "address"
			w = "polygons.consensus = 'yes'"
		end
		Polygon.select("COUNT(polygons.id) AS polygon_count, sheet_id, sheets.bbox").joins(:sheet).where(w).group("polygons.sheet_id, sheets.bbox")
	end

	def to_geojson
	   { :type => "Feature", :properties => { :consensus => self[:consensus], :consensus_address => self[:consensus_address], :id => self[:id], :dn => self[:dn], :sheet_id => self[:sheet_id] }, :geometry => { :type => "Polygon", :coordinates => JSON.parse(self[:geometry]) } }
	end

	def to_point_geojson
	   { :type => "Feature", :properties => { :consensus => self[:consensus], :consensus_address => self[:consensus_address], :id => self[:id], :dn => self[:dn], :sheet_id => self[:sheet_id] }, :geometry => { :type => "Point", :coordinates => [self[:centroid_lon], self[:centroid_lat]] } }
	end

	def as_feature
	   { :type => "FeatureCollection", :features => [JSON.parse(self[:vectorizer_json])] }
	end

	def fixes_as_features
		f = flags.where(:flag_type => "polygonfix")
		features = []
		f.each do |feature|
			features.push({:type => "Feature", :geometry => { :type => "Polygon", :coordinates => JSON.parse(feature[:flag_value]) }})
		end
		{ :type => "FeatureCollection", :features => features }
	end
end
