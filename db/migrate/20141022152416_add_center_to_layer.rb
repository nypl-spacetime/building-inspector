class AddCenterToLayer < ActiveRecord::Migration
  def change
    add_column :layers, :center, :string
  end
end
