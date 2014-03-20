class CreateConsensusPolygon < ActiveRecord::Migration
  def up
    create_table :consensuspolygons do |t|
      t.string :task
      t.integer :polygon_id
      t.text :consensus
      t.integer :override_id

      t.timestamps
    end
    add_index(:consensuspolygons,[:polygon_id, :task],{unique: true, name: "index_task_consensus_on_polygon_id"})
    add_index(:consensuspolygons,:task,{name: "index_task"})
  end

  def down
    drop_table :consensuspolygons
  end
end
