class AddCentroidToPolygon < ActiveRecord::Migration
  def change
    add_column :polygons, :centroid, :string
  end
end
