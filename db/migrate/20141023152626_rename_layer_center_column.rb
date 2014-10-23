class RenameLayerCenterColumn < ActiveRecord::Migration
  def up
    rename_column :layers, :center, :bbox
  end

  def down
    rename_column :layers, :bbox, :center
  end
end
