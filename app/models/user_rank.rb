class UserRank < ActiveRecord::Base
  belongs_to :user
  attr_accessible :flag_type, :score, :session_id
end
