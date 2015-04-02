class CreateLayers < ActiveRecord::Migration
  def change
    create_table :layers do |t|
      t.string :name
      t.string :tilejson
      t.string :description
      t.integer :year

      t.timestamps
    end

    # Layer.create({id: 859, name: 'New York, 1857', description: 'Maps of the city of New York', tilejson: 'https://s3.amazonaws.com/maptiles.nypl.org/859/859spec.json', year: 1857, bbox: '-74.04,40.69,-73.93,40.77', external_id:859}, :without_protection => true)

    # Layer.create({id: 860, name: 'Brooklyn, 1855', description: 'Maps of the city of Brooklyn', tilejson: 'https://s3.amazonaws.com/maptiles.nypl.org/860/860spec.json', year: 1855, bbox: '-74.03,40.63,-73.94,40.71', external_id:860}, :without_protection => true)
  end
end
