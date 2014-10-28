class ConsensusUtils

  def self.calculate_polygonfix_consensus(geojson)
    # TODO: still lacks a more robust validation/checking
    output = []
    geom = parse_geojson(geojson)
    centroids = get_all_centroids(geom)
    centroid_clusters = cluster_centroids(centroids)
    centroid_clusters.each do |ccluster|
      next if ccluster[0] == -1
      cluster = ccluster[1] # only the set of latlons
      sub_geom = get_polys_for_centroid_cluster(cluster, centroids, geom)
      next if sub_geom.size == 0
      original_points = get_all_poly_points(sub_geom)
      next if original_points == nil
      unique_points = original_points.map{|poly| poly[1..-1]}
      vertex_clusters = cluster_points(unique_points)
      next if !validate_clusters(vertex_clusters, unique_points)
      mean_poly = get_mean_poly(vertex_clusters)
      next if mean_poly == {}
      connections = connect_clusters(vertex_clusters, original_points)
      next if connections == nil || connections == {}
      poly = connect_mean_poly(mean_poly, connections)
      next if poly == nil || poly.count == 0
      output.push(poly)
    end
    return output
  end

  def self.calculate_address_consensus(flags)
    # flags are an activerecord list of 'address' type flags for a given sheet
    # cluster them flags
    clusters = cluster_addresses(flags)
    consensus_list = []
    clusters.each do |c|
      next if c[0] == -1
      consensus = address_cluster_consensus(c[1], flags)
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

  def self.cluster_addresses(addresses, epsilon=1.425e-05, min_points=2)
    simple_array = addresses.map { |a| [a["longitude"].to_f, a["latitude"].to_f] }
    dbscan = DBSCAN( simple_array, :epsilon => epsilon, :min_points => min_points, :distance => :euclidean_distance )
    return dbscan.results.select{|k,v| k != -1} # omit the non-cluster
  end

  def self.address_cluster_consensus(cluster, flags, min_count = 3, threshold = 0.75)
    return nil if cluster.count < min_count
    flags = get_address_flags_for_cluster(cluster, flags)
    total_votes = 0
    address_tally = {} # saves the address popularity
    id_tally = {} # saves the flaggable_id popularity
    session_ids = []
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
      if address_tally[value] == nil
        address_tally[value] = 0
      end
      if id_tally[id] == nil
        id_tally[id] = 0
      end
      address_tally[value] = address_tally[value] + 1
      id_tally[id] = id_tally[id] + 1
      total_votes = total_votes + 1
    end
    # in case there was trolling
    return if total_votes < min_count
    # sort tally by value
    address_tally_sorted = address_tally.sort_by { |value,votes| votes }
    # sort tally by value
    id_tally_sorted = id_tally.sort_by { |id,count| count }
    # and the winner is...
    winner_address = address_tally_sorted.last
    winner_id = id_tally_sorted.last
    votes = winner_address[1].to_i
    consensus = votes.to_f / total_votes.to_f
    flaggable_id = winner_id[0].to_i
    flag_value = winner_address[0]
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

  def self.get_address_flags_for_cluster(cluster, flags)
    output = []
    cluster.each do |point|
      flag = get_address_flag_for_point(point, flags)
      output.push(flag) if flag != nil
    end
    return output
  end

  def self.get_address_flag_for_point(point, flags)
    flags.each do |f|
      lat = f["latitude"].to_f
      lon = f["longitude"].to_f
      return f if point[0] == lon and point[1] == lat
    end
    return nil
  end

  def self.parse_geojson(json)
    RGeo::GeoJSON.decode(json, :json_parser => :json)
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

  def self.cluster_centroids(centroids, epsilon=1.8e-06, min_points=2)
    dbscan = DBSCAN( centroids.map{|c| c[1]}, :epsilon => epsilon, :min_points => min_points, :distance => :euclidean_distance )
    return dbscan.results.select{|k,v| k != -1} # omit the non-cluster
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

  # perform point clustering EXCLUDING first item in each poly since it is same as last
  def self.cluster_points(points, epsilon=5.5e-06, min_points=2)
    dbscan = DBSCAN( points.flatten(1), :epsilon => epsilon, :min_points => min_points, :distance => :euclidean_distance )
    return dbscan.results.select{|k,v| k != -1} # omit the non-cluster
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
      if cluster[0] != -1 # exclude invalid cluster
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
        connections[cluster[0]] = cluster_votes.sort_by{|k, v| v}
        next if connections[cluster[0]].size == 0
        connections[cluster[0]] = connections[cluster[0]].reverse[0][0]
      end
    end
    return connections
  end

  def self.sort_connections(connections)
    # does some simple check for non-circularity
    sorted = []
    seen = {}
    as_list = connections.select{|k,v| k}
    done = false
    first = as_list.first[0]
    from = first
    while !done do
      to = connections[from]
      done = true if seen[to] || to == nil || to.size == 0
      seen[to] = true
      from = to
      sorted.push(to)
      done = true if seen.size == connections.size
    end
    return nil if seen.size != connections.size
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

end

# convenience methods for averaging
class Array
    def sum
      inject(0.0) { |result, el| result + el }
    end

    def mean
      sum / size
    end
end