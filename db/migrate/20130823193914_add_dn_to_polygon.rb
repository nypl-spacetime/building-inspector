class AddDnToPolygon < ActiveRecord::Migration
  def change
    add_column :polygons, :dn, :integer
  end
end
