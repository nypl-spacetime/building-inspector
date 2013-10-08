class AddIndexToFlag < ActiveRecord::Migration
  def change
    add_index :flags, :session_id, {unique: false}
  end
end
