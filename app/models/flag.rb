class Flag < ActiveRecord::Base
	belongs_to :polygon
	attr_accessible :flag_value, :is_primary, :polygon_id, :session_id, :flag_type
	validates :flag_value, presence: true
	validates :polygon_id, presence: true
	validates :flag_type, presence: true

	def self.flags_for_session(session_id)
		Flag.select("DISTINCT polygon_id").where(:session_id => session_id).count
	end
	
	def self.flags_for_user(user_id)
		Flag.select("DISTINCT polygon_id").joins('INNER JOIN usersessions ON usersessions.session_id = flags.session_id').where('usersessions.user_id = ?', user_id).count    
	end

	def self.progress_for_session(session_id)
		Flag.select("DISTINCT polygons.id, polygons.geometry, flags.*").joins(:polygon).where(:session_id => session_id)
	end
	
	def self.progress_for_user(user_id)
		Flag.select("DISTINCT polygons.id, polygons.geometry, flags.*").joins(:polygon).joins('INNER JOIN usersessions ON usersessions.session_id = flags.session_id').where('usersessions.user_id = ?', user_id)
	end
  
end
