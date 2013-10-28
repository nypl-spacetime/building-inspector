class RemoveCentroidFromPolygon < ActiveRecord::Migration
  def change
  	remove_column :polygons, :centroid
  	add_column :polygons, :centroid_lat, :decimal, :precision => 15, :scale => 12
  	add_column :polygons, :centroid_lon, :decimal, :precision => 15, :scale => 12
  end
end
