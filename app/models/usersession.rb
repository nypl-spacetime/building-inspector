class Usersession < ActiveRecord::Base
  belongs_to :user
  attr_accessible :user_id, :session_id
  
  def self.find_user_by_session_id(session_id)
    user = nil
    if session_id
      user = User.joins(:usersessions).where(usersessions: {session_id: session_id}).first
    end
    user
  end
  
  def self.register_user_session(user_id, session_id)
    session = nil
    if session_id and user_id
      session = Usersession.where(:user_id => user_id, :session_id => session_id).first
      unless session
        session = Usersession.create(:user_id => user_id, :session_id => session_id)
      end
    end
    session
  end
  
  def self.merge_user_sessions(user_id, master_session_id=nil)
    sessions = Usersession.where(:user_id => user_id)
    unless sessions.length <= 1
      # select the first session as master session unless otherwise indicated
      master_session_id = sessions.first.session_id unless master_session_id
      # set all user sessions to master session   
      sessions = sessions.map {|s| s.session_id }
      Flag.where(:session_id => sessions).update_all(:session_id => master_session_id)
    end
    sessions
  end
  
end
