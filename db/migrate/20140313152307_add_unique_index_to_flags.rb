class AddUniqueIndexToFlags < ActiveRecord::Migration
  def up
    remove_index(:flags,name: "index_flags_on_session_id")
    add_index(:flags,[:session_id, :flag_type, :polygon_id, :flag_value, :latitude, :longitude],{unique: true, name: "index_flags_on_session_id"})
  end

  def down
    remove_index(:flags,name: "index_flags_on_session_id")
    add_index :flags, :session_id, {unique: false, name: "index_flags_on_session_id"}
  end
end
