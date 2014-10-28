class AddFlaggableTypeToFlags < ActiveRecord::Migration
  def up
    rename_column :flags, :polygon_id, :flaggable_id
    add_column :flags, :flaggable_type, :string, :default => "Polygon"
  end

  def down
    rename_column :flags, :flaggable_id, :polygon_id
    remove_column :flags, :flaggable_type
  end
end
