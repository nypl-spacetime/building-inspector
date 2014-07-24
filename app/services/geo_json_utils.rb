class GeoJsonUtils

  def self.calculate_polygonfix_consensus(geojson)
    # TODO: still lacks a more robust validation/checking
    output = []
    geom = parse(geojson)
    centroids = get_all_centroids(geom)
    centroid_clusters = cluster_centroids(centroids)
    centroid_clusters.each do |ccluster|
      cluster = ccluster[1] # only the set of latlons
      sub_geom = get_polys_for_centroid_cluster(cluster, centroids, geom)
      next if sub_geom.size == 0
      original_points = get_all_poly_points(sub_geom)
      next if original_points == nil
      clusters = cluster_points(original_points)
      next if !validate_clusters(clusters, original_points)
      mean_poly = get_mean_poly(clusters)
      next if mean_poly == {}
      connections = connect_clusters(clusters, original_points)
      next if connections == nil || connections == {}
      poly = connect_mean_poly(mean_poly, connections)
      next if poly == nil || poly.count == 0
      output.push(poly)
    end
    return output
  end

  def self.parse(json)
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

  def self.cluster_centroids(centroids)
    dbscan = DBSCAN( centroids.map{|c| c[1]}, :epsilon => 1.8e-06, :min_points => 2, :distance => :euclidean_distance )
    return dbscan.results
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
  def self.cluster_points(original_points)
    unique_points = original_points.map{|poly| poly[1..-1]}
    #dbscan = DBSCAN( unique_points.flatten(1), :epsilon => 3.5e-6, :min_points => 1, :distance => :haversine_distance2 )
    dbscan = DBSCAN( unique_points.flatten(1), :epsilon => 6e-06, :min_points => 2, :distance => :euclidean_distance )
    return dbscan.results
  end

  def self.validate_clusters(clusters, original_points)
    unique_points = original_points.map{|poly| poly[1..-1]}
    average = (unique_points.flatten.count.to_f / (unique_points.size * 2).to_f).round
    return clusters.select{|k,v| k!=-1}.size >= average
  end

  def self.get_mean_poly(clusters)
    means = {}
    clusters.each do |cluster|
      if cluster[0] != -1 # ignore cluster -1 because not enough points
        lon = cluster[1].map {|c| c[0]}.mean
        lat = cluster[1].map {|c| c[1]}.mean
        means[cluster[0]] = [lon,lat]
      end
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
      done = true if seen[to] || to == nil
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

  def self.to_geojson(consensus, id)
    {:type => "FeatureCollection", :features => consensus.map { |f| {:type => "Feature", :properties => { :polygon_id => id }, :geometry => { :type => "Polygon", :coordinates =>[f] } } } }.to_json
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