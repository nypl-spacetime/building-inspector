class AddColumnsToPolygonsSheets < ActiveRecord::Migration
  def change
    add_column :polygons, :consensus_numbers, :string
    add_index(:polygons,[:sheet_id, :consensus_numbers],name: "consensus_numbers_index")
    
    add_column :sheets, :consensus, :string
    add_index(:sheets,:consensus,name: "sheet_consensus_index")
    add_column :sheets, :consensus_numbers, :string
    add_index(:sheets,:consensus_numbers,name: "sheet_consensus_numbers_index")
  end
end
