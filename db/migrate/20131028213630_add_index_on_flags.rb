class AddIndexOnFlags < ActiveRecord::Migration
  def up
    add_index(:flags,:polygon_id,name: "polygon_index")
  end

  def down
    remove_index(:flags,:polygon_id,name: "polygon_index")
  end
end
