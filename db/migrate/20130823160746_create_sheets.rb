class CreateSheets < ActiveRecord::Migration
  def change
    create_table :sheets do |t|
      t.string :status
      t.string :bbox
      t.integer :map_id
      t.string :map_url

      t.timestamps
    end
  end
end
