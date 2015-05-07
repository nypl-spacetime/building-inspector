class ConsensusUtils

  # POLYGONFIX CONSENSUS
  def self.calculate_polygonfix_consensus(geojson)
    # TODO: still lacks a more robust validation/checking
    output = []
    geom = parse_geojson(geojson)
    centroids = get_all_centroids(geom)
    centroid_clusters = apply_dbscan(centroids.map{|c| c[1]}, 4.5e-06, 2)
    centroid_clusters.each do |ccluster|
      next if ccluster[0] == -1
      # puts "a"
      cluster = ccluster[1] # only the set of latlons
      sub_geom = get_polys_for_centroid_cluster(cluster, centroids, geom)
      next if sub_geom.size == 0
      # puts "b"
      original_points = get_all_poly_points(sub_geom)
      next if original_points == nil
      # puts "c"
      unique_points = original_points.map{|poly| poly[1..-1]}
      vertex_clusters = apply_dbscan(unique_points.flatten(1), 5.0e-06, 2)
      next if vertex_clusters.size == 0
      # puts "d"
      # next if !validate_clusters(vertex_clusters, unique_points)
      # puts "e"
      mean_poly = get_mean_poly(vertex_clusters)
      next if mean_poly == {}
      # puts "f: #{mean_poly}"
      connections = connect_clusters(vertex_clusters, original_points)
      next if connections == nil || connections == {}
      # puts "g: #{connections}"
      poly = connect_mean_poly(mean_poly, connections)
      next if poly == nil || poly.count == 0
      # puts "h: #{poly}"
      next if !validate_final_poly(poly, original_points)
      # puts "i"
      output.push(poly)
    end
    return output
  end

  def self.validate_final_poly(poly, original_polys)
    point_count = original_polys.map { |c| c.size }
    # puts "validation: #{poly.size}, #{point_count.median}, #{point_count.mean}, #{point_count.standard_deviation}"
    poly.size >= (point_count.mean - 2*point_count.standard_deviation).to_i
  end

  # given a list of centroids (lon,lat), find their poly's index in the centroid list (index => lon,lat)
  def self.get_polys_for_centroid_cluster(cluster, centroids, original_polys)
    polys = []
    cluster.each do |cl|
      index = centroids.select {|k,v| v == cl}.keys.first
      polys.push(original_polys[index]) if index != -1
    end
    return polys
  end

  def self.get_points(poly_feature)
    geom = poly_feature.geometry
    return false if (geom.geometry_type.type_name != "Polygon")
    pts = []
    points = geom.exterior_ring.points
    points.each do |point|
      pts.push([point.x,point.y])
    end
    return pts
  end

  def self.get_all_poly_points(polys)
    points = []
    polys.each do |poly|
      points.push(get_points(poly))
    end
    return points
  end

  def self.validate_clusters(clusters, unique_points)
    average = (unique_points.flatten.count.to_f / (unique_points.size * 2).to_f).round
    return clusters.select{|k,v| k!=-1}.size >= average
  end

  def self.get_mean_poly(clusters)
    means = {}
    clusters.each do |cluster|
      next if cluster[0] == -1 # ignore cluster -1 because not enough points
      lon = cluster[1].map {|c| c[0]}.mean
      lat = cluster[1].map {|c| c[1]}.mean
      means[cluster[0]] = [lon,lat]
    end
    return means
  end

  def self.find_connected_point(point, original_points)
    original_points.each do |poly|
      poly.each_with_index do |p,index|
        return poly[index+1] if point === p
      end
    end
    return
  end

  def self.find_cluster_for_point(point, clusters)
    clusters.each do |cluster|
      cluster[1].each do |p|
        return cluster[0] if point === p && cluster[0] != -1
      end
    end
    return
  end

  def self.connect_clusters(clusters, original_points)
    connections = {}
    # for each cluster
    clusters.each do |cluster|
      # for each point in cluster
      next if cluster[0] == -1 # exclude invalid cluster
      cluster_votes = {} # to weigh connection popularity (diff pts might be connected to diff clusters)
      cluster[1].each do |point|
        # find original point connected to it
        connection = find_connected_point(point, original_points)
        connected_cluster = find_cluster_for_point(connection, clusters)
        # if original point belongs to another cluster
        if connected_cluster != nil && connected_cluster != cluster[0]
          # vote for the cluster
          cluster_votes[connected_cluster] = 0 if cluster_votes[connected_cluster] == nil
          cluster_votes[connected_cluster] += 1
        end
      end
      tally = cluster_votes.sort_by{|k, v| v}
      next if tally.size == 0
      connections[cluster[0]] = tally.reverse[0][0]
    end
    # check openness (an orphan vertex)
    vertices = connections.map { |k,v| [k,v]}.flatten.uniq
    vertices.each do |v|
      return nil if connections[v] == nil
    end
    return connections
  end

  def self.sort_connections(connections)
    # does some simple check for non-circularity
    sorted = []
    seen = {}
    as_list = connections.map{|k,v| k}
    done = false
    first = as_list.first
    from = first
    while !done do
      to = connections[from]
      # TODO: there is probably a better way to do this wihtout so many if inside
      done = true if seen[to] || to == nil
      seen[to] = true
      from = to
      sorted.push(to) if !done
      done = true if seen.size == connections.size
    end
    return sorted
  end

  def self.connect_mean_poly(mean_poly, connections)
    connected = []
    # TODO: verify circularity eg: 0 => 1 => 2 => 3 => 4 => 0
    sorted = sort_connections(connections)
    return nil if sorted == nil
    sorted.each do |c|
      connected.push([mean_poly[c][0], mean_poly[c][1]])
    end
    # for GeoJSON, last == first
    first = sorted[0]
    connected.push([mean_poly[first][0], mean_poly[first][1]])
    return connected
  end

  def self.consensus_to_geojson(consensus, id)
    {:type => "FeatureCollection", :features => consensus.map { |f| {:type => "Feature", :properties => { :flaggable_id => id }, :geometry => { :type => "Polygon", :coordinates =>[f] } } } }.to_json
  end

  def self.get_centroid(poly_feature)
    return if (poly_feature.geometry.geometry_type.type_name != "Polygon")
    c = poly_feature.geometry.centroid
    return [c.x, c.y]
  end

  def self.get_all_centroids(geom)
    centroids = {}
    geom.each_with_index do |poly,index|
      next if (poly.geometry.geometry_type.type_name != "Polygon")
      centroids[index] = get_centroid(poly)
    end
    return centroids
  end

  # ADDRESS CONSENSUS
  def self.calculate_address_consensus(flags)
    calculate_point_consensus(flags, 1.425e-05, 2)
  end

  # TOPONYM CONSENSUS
  # TODO: test it
  def self.calculate_toponym_consensus(flags)
    calculate_point_consensus(flags, 1.425e-05, 2)
  end

  # GENERIC POINT CONSENSUS
  def self.calculate_point_consensus(flags, epsilon, min_points)
    # flags are an activerecord list of 'address' type flags for a given sheet
    # cluster them flags
    simple_array = flags.map { |a| [a["longitude"].to_f, a["latitude"].to_f] }
    clusters = apply_dbscan(simple_array, epsilon, min_points)
    consensus_list = []
    byebug if Rails.env.development?
    clusters.each do |c|
      next if c[0] == -1
      consensus = points_cluster_consensus(c[1], flags)
      consensus_list.push(consensus) if consensus != nil
    end
    # group by flaggable_id
    ids = consensus_list.map {|f| f[:flaggable_id]}.uniq
    grouped_list = {}
    ids.each do |id|
      items = consensus_list.select {|x| x[:flaggable_id] == id}
      grouped_list[id] = items
    end
    return grouped_list
  end

  def self.points_cluster_consensus(cluster, rawflags, min_count = 3, threshold = 0.75)
    return nil if cluster.count < min_count
    flags = get_flags_for_cluster(cluster, rawflags)
    total_votes = 0
    flag_tally = {} # saves the address popularity
    id_tally = {} # saves the flaggable_id popularity
    session_ids = []
    byebug if Rails.env.development?
    flags.each do |vote|
      value = vote["flag_value"]
      id = vote["flaggable_id"]
      sid = vote["session_id"]
      # ignore vote if session_id already exists
      # to reduce trolling
      if session_ids.index(sid) != nil
        next
      end
      session_ids.push(sid)
      # now tally values
      if flag_tally[value] == nil
        flag_tally[value] = 0
      end
      if id_tally[id] == nil
        id_tally[id] = 0
      end
      flag_tally[value] = flag_tally[value] + 1
      id_tally[id] = id_tally[id] + 1
      total_votes = total_votes + 1
    end
    # in case there was trolling
    return if total_votes < min_count
    # sort tally by value
    flag_tally_sorted = flag_tally.sort_by { |value,votes| votes }
    # sort tally by value
    id_tally_sorted = id_tally.sort_by { |id,count| count }
    # and the winner is...
    winner_flag = flag_tally_sorted.last
    winner_id = id_tally_sorted.last
    votes = winner_flag[1].to_i
    consensus = votes.to_f / total_votes.to_f
    flaggable_id = winner_id[0].to_i
    flag_value = winner_flag[0]
    # lat/lon is average of points
    latitude = cluster.map {|c| c[1]}.mean
    longitude = cluster.map {|c| c[0]}.mean
    # check if consensus is above threshold
    return if consensus < threshold
    winner_mark = {}
    winner_mark[:latitude] = latitude
    winner_mark[:longitude] = longitude
    winner_mark[:flag_value] = flag_value
    winner_mark[:votes] = votes
    winner_mark[:total_votes] = total_votes
    winner_mark[:flaggable_id] = flaggable_id
    return winner_mark
  end

  def self.get_flags_for_cluster(cluster, flags)
    output = []
    cluster.each do |point|
      flag = get_flag_for_point(point, flags)
      output.push(flag) if flag != nil
    end
    return output
  end

  def self.get_flag_for_point(point, flags)
    flags.each do |f|
      lat = f["latitude"].to_f
      lon = f["longitude"].to_f
      return f if point[0] == lon and point[1] == lat
    end
    return nil
  end

  # GENERIC

  def self.parse_geojson(json)
    RGeo::GeoJSON.decode(json, :json_parser => :json)
  end

  # perform point clustering EXCLUDING first item in each poly since it is same as last
  def self.apply_dbscan(set, epsilon=5.5e-06, min_points=2)
    dbscan = DBSCAN( set, :epsilon => epsilon, :min_points => min_points, :distance => :euclidean_distance )
    return dbscan.results.select{|k,v| k != -1} # omit the non-cluster
  end

end

# convenience methods for averaging
class Array
  def sum
    inject(0.0) { |result, el| result + el }
  end

  def mean
    sum / size
  end

  def median
    sorted = sort
    len = sorted.length
    (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
  end

  def sample_variance
    m = self.mean
    sum = self.inject(0){|accum, i| accum +(i-m)**2 }
    sum/(self.length - 1).to_f
  end

  def standard_deviation
    return Math.sqrt(self.sample_variance)
  end

end