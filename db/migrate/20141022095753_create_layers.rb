class CreateLayers < ActiveRecord::Migration
  def change
    create_table :layers do |t|
      t.string :name
      t.string :tilejson
      t.string :description
      t.integer :year

      t.timestamps
    end

    # Layer.create!(id: 859, name: 'Brooklyn, 1857', description: 'Maps of the city of New York', tilejson: 'https://s3.amazonaws.com/maptiles.nypl.org/859/859spec.json', year: 1857)

    # Layer.create!(id: 860, name: 'Brooklyn, 1855', description: 'Maps of the city of Brooklyn', tilejson: 'https://s3.amazonaws.com/maptiles.nypl.org/860/860spec.json', year: 1855)
  end
end
