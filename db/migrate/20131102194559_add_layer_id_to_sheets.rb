class AddLayerIdToSheets < ActiveRecord::Migration
  def change
    add_column :sheets, :layer_id, :integer
    add_index :sheets, :layer_id
    Sheet.update_all layer_id: 859
  end
end
