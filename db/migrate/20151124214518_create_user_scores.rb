class CreateUserScores < ActiveRecord::Migration
  def change
    create_table :user_scores do |t|
      t.integer :user_id
      t.string :flag_type
      t.integer :score

      t.timestamps
    end
  end
end
