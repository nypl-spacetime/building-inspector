class CreatePolygons < ActiveRecord::Migration
  def change
    create_table :polygons do |t|
      t.text :geometry
      t.string :status
      t.text :vectorizer_json
      t.integer :sheet_id
      t.string :color

      t.timestamps
    end
  end
end
