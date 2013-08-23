class CreateFlags < ActiveRecord::Migration
  def change
    create_table :flags do |t|
      t.string :type
      t.integer :polygon_id
      t.string :session_id
      t.string :flag_value
      t.boolean :is_primary

      t.timestamps
    end
  end
end
