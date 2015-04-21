class ChangeYearTypeInLayers < ActiveRecord::Migration
  def up
    change_column :layers, :year, :string
  end

  def down
    change_column :layers, :year, :integer
  end
end
