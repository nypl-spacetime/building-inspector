class AddConsensusToPolygon < ActiveRecord::Migration
  def change
    add_column :polygons, :consensus, :string
    add_index(:polygons,[:sheet_id, :consensus],name: "consensus_index")
  end
end
