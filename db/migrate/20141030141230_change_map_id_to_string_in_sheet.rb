class ChangeMapIdToStringInSheet < ActiveRecord::Migration
  def up
    change_column :sheets, :map_id, :string
  end

  def down
    change_column :sheets, :map_id, :integer
  end
end
