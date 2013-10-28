class RemoveCentroidFromPolygon < ActiveRecord::Migration
  def change
  	remove_column :polygons, :centroid
  	add_column :polygons, :centroid_lat, :float
  	add_column :polygons, :centroid_lon, :float
  end
end
