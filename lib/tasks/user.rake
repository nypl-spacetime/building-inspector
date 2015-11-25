namespace :user do

  desc "Calculate user scores for ranking/leaderboard"
  task :calculate_scores => :environment do
    # truncate the table
    UserScores.connection.execute("TRUNCATE table user_scores")
    UserScores.connection.execute(build_score_query())
  end

  def build_score_query()
    "INSERT INTO user_scores (user_id, flag_type, score, created_at, updated_at)
        SELECT U.id AS user_id, C.flag_type AS flag_type, COUNT(*) AS score, current_timestamp AS created_at, current_timestamp AS updated_at
        FROM users U
        INNER JOIN usersessions S ON S.user_id=U.id
        INNER JOIN flags C ON C.session_id=S.session_id
        GROUP BY U.id, C.flag_type
    "
  end

end