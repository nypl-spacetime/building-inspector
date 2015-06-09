class Polygon < ActiveRecord::Base
  has_many :flags, as: :flaggable
  has_many :consensuspolygons, as: :flaggable, :dependent => :destroy
  belongs_to :sheet
  attr_accessible :color, :geometry, :sheet_id, :vectorizer_json, :dn, :centroid_lat, :centroid_lon, :flag_count

  def self.grouped_by_sheet(layer_id)
    # returns polygon counts grouped by sheet for a given layer (used in the progress maps)
    Polygon.select("COUNT(polygons.id) AS total, sheet_id, sheets.bbox").where("sheets.layer_id = ?",layer_id).joins(:sheet).group("polygons.sheet_id, sheets.bbox")
  end

  # def as_feature
  #    { :type => "FeatureCollection", :features => [JSON.parse(self[:vectorizer_json])] }
  # end

  def to_geojson
     { :type => "Feature", :properties => { :id => id, :dn => dn, :sheet_id => sheet_id, :consensus => (consensus ? (consensus != "NONE" ? JSON.parse(consensus) : consensus) : "") }, :geometry => { :type => "Polygon", :coordinates => JSON.parse(geometry) } }
  end

  def to_point_geojson
     { :type => "Feature", :properties => { :id => id, :dn => dn, :sheet_id => sheet_id }, :geometry => { :type => "Point", :coordinates => [centroid_lon, centroid_lat] } }
  end

  def poly_consensus(task)
    c = Consensuspolygon.where({:flaggable_id => id, :flaggable_type => "Polygon", :task => task}).first
    return "N/A" if c == nil
    c[:consensus]
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
    cp = Consensuspolygon.find_or_initialize_by_flaggable_id_and_flaggable_type_and_task(:flaggable_id => id, :flaggable_type => "Polygon", :task => 'polygonfix')
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
