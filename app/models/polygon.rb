class Polygon < ActiveRecord::Base
  has_many :flags, as: :flaggable
  has_many :consensuspolygons, :dependent => :destroy
  belongs_to :sheet
  attr_accessible :color, :geometry, :sheet_id, :status, :vectorizer_json, :dn, :centroid_lat, :centroid_lon, :flag_count

  def self.grouped_by_sheet(layer_id)
    # returns polygon counts grouped by sheet for a given layer (used in the progress maps)
    Polygon.select("COUNT(polygons.id) AS total, sheet_id, sheets.bbox").where("sheets.layer_id = ?",layer_id).joins(:sheet).group("polygons.sheet_id, sheets.bbox")
  end

  # def as_feature
  #    { :type => "FeatureCollection", :features => [JSON.parse(self[:vectorizer_json])] }
  # end

  def to_geojson
     { :type => "Feature", :properties => { :id => self[:id], :dn => self[:dn], :sheet_id => self[:sheet_id] }, :geometry => { :type => "Polygon", :coordinates => JSON.parse(self[:geometry]) } }
  end

  def to_point_geojson
     { :type => "Feature", :properties => { :id => self[:id], :dn => self[:dn], :sheet_id => self[:sheet_id] }, :geometry => { :type => "Point", :coordinates => [self[:centroid_lon], self[:centroid_lat]] } }
  end

  def poly_consensus(task)
    c = Consensuspolygon.where({:polygon_id => self.id, :task => task})
    if c.count > 0
      c[0][:consensus]
    else
      "N/A"
    end
  end

  def consensus_color
    poly_consensus("color")
  end

  def consensus_geometry
    poly_consensus("geometry")
  end

  def consensus_address
    c = poly_consensus("address")
    if c == "N/A" || c == "NONE"
      return c
    end
    features = []
    c_array = JSON.parse(c)
    c_array.each do |address|
      feature = address_as_feature(address)
      features.push(feature)
    end
    { :type => "FeatureCollection", :features => features }.to_json
  end

  def consensus_polygonfix
    c = poly_consensus("polygonfix")
    return c
  end

  def calculate_polygonfix_consensus
    features = []

    f = flags.where("flag_type = 'polygonfix' AND flag_value != 'NOFIX'")

    features = f.map { |item| { :type => "Feature", :properties => { :id => id }, :geometry => { :type=>"Polygon", :coordinates => JSON.parse(item[:flag_value]) } } }

    geo = { :type => "FeatureCollection", :features => features }

    consensus = ConsensusUtils.calculate_polygonfix_consensus(geo.to_json)
    return if consensus == nil || consensus.count == 0 # if not a polygon
    # puts "found consensus for polygon: #{id}"
    # save it
    cp = Consensuspolygon.find_or_initialize_by_polygon_id_and_task(:polygon_id => id, :task => 'polygonfix')
    geojson = ConsensusUtils.consensus_to_geojson(consensus, id)
    cp[:consensus] = geojson
    if !cp.save
      return nil
      # puts "!=!=!=!=!=!=!=!=! Could not save polygonfix consensus with params: #{self}"
    end
    return true
  end

  def address_as_feature(address)
    r = {}
    r[:type] = "Feature"
    r[:properties] = {}
    r[:properties][:votes] = address["votes"]
    r[:properties][:total_votes] = address["total_votes"]
    r[:properties][:flag_value] = address["flag_value"]
    r[:geometry] = { :type => "Point", :coordinates => [address["longitude"].to_f, address["latitude"].to_f] }
    r
  end

  def flags_as_features
    features = []

    f = flags.where(:flag_type => "polygonfix")
    f.each do |flag|
      features.push(flag.to_geojson)
    end

    f = flags.where(:flag_type => "address")
    f.each do |flag|
      features.push(flag.to_geojson)
    end

    { :type => "FeatureCollection", :features => features }
  end
end
