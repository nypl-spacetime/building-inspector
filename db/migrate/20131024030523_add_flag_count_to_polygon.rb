class AddFlagCountToPolygon < ActiveRecord::Migration
  def change
    add_column :polygons, :flag_count, :number, :default => 0
  end
end
