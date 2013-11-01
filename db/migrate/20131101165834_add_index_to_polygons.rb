class AddIndexToPolygons < ActiveRecord::Migration
  def change
    add_index(:polygons,:consensus,name: "consensus_index2")
  end
end
