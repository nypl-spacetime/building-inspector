class AddLatLonToFlag < ActiveRecord::Migration
  def change
    add_column :flags, :latitude, :decimal, :precision => 15, :scale => 12
    add_column :flags, :longitude, :decimal, :precision => 15, :scale => 12
  end
end
