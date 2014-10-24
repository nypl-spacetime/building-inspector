class AddExternalIdToLayer < ActiveRecord::Migration
  def change
    add_column :layers, :external_id, :integer
  end
end
