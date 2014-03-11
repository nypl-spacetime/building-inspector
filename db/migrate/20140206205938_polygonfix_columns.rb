class PolygonfixColumns < ActiveRecord::Migration
  def up
    change_column :flags, :flag_value, :text

    add_column :polygons, :consensus_polygonfix_value, :text

    add_column :polygons, :consensus_polygonfix, :boolean
    add_index(:polygons,[:sheet_id, :consensus_polygonfix],name: "consensus_polygonfix_index")
    
    add_column :sheets, :consensus_polygonfix, :boolean
    add_index(:sheets,:consensus_polygonfix,name: "sheet_consensus_polygonfix_index")
  end

  def down
    change_column :flags, :flag_value, :string

    remove_column :polygons, :consensus_polygonfix_value

    remove_column :polygons, :consensus_polygonfix
    
    remove_column :sheets, :consensus_polygonfix
  end
end
