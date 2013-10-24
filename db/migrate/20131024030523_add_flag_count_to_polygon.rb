class AddFlagCountToPolygon < ActiveRecord::Migration
  def up
    add_column :polygons, :flag_count, :integer, :default => 0
  end
  def down
    remove_column :polygons, :flag_count
  end
end
