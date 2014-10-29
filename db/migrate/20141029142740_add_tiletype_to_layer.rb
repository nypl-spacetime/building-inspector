class AddTiletypeToLayer < ActiveRecord::Migration
  def change
    add_column :layers, :tileset_type, :string, :default => "tms"
  end
end
