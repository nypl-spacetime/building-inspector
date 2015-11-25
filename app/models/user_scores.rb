class UserScores < ActiveRecord::Base
  belongs_to :user
  attr_accessible :flag_type, :score, :user_id

  def self.rank_for_user_task(user_id, task)
    user_score = UserScores.where("user_id = ? AND flag_type = ?", user_id, task).first
    return User.count if user_score == nil # LAST!
    count = UserScores.where("score > ? AND flag_type = ?", user_score[:score], task).count
    return count + 1
  end
end
