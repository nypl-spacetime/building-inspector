class RemoveCentroidFromPolygon < ActiveRecord::Migration
  def change
  	remove_column :polygons, :centroid
  	add_column :polygons, :centroid_lat, :double
  	add_column :polygons, :centroid_lon, :double
  end
end
