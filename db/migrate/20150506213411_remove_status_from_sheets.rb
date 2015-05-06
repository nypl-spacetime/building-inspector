class RemoveStatusFromSheets < ActiveRecord::Migration
  def up
    remove_column :sheets, :status if column_exists?(:sheets, :status)
    remove_column :polygons, :status if column_exists?(:polygons, :status)
  end

  def down
  end
end
