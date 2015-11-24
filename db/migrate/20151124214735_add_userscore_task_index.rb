class AddUserscoreTaskIndex < ActiveRecord::Migration
  def up
    add_index(:user_scores,[:user_id, :flag_type],{unique: true, name: "user_task_index"})
  end

  def down
    remove_index(:user_scores,name: "user_task_index")
  end
end
