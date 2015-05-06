class AddFlaggableTypeToConsensuspolygons < ActiveRecord::Migration
  def up
    rename_column :consensuspolygons, :polygon_id, :flaggable_id
    add_column :consensuspolygons, :flaggable_type, :string, :default => "Polygon"
  end

  def down
    rename_column :consensuspolygons, :flaggable_id, :polygon_id
    remove_column :consensuspolygons, :flaggable_type
  end
end
