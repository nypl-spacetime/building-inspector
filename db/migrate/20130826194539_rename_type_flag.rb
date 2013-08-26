class RenameTypeFlag < ActiveRecord::Migration
  def up
  	rename_column :flags, :type, :flag_type
  end

  def down
  	rename_column :flags, :flag_type, :type
  end
end
