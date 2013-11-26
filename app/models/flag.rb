class Flag < ActiveRecord::Base
	belongs_to :polygon
	attr_accessible :flag_value, :is_primary, :polygon_id, :session_id, :flag_type, :latitude, :longitude
	validates :flag_value, presence: true
	validates :polygon_id, presence: true
	validates :flag_type, presence: true

	def self.flags_for_sheet_for_session(sheet_id, session_id, type = "geometry")
		# just need the count
		Flag.select('DISTINCT flags.polygon_id, flags.flag_value, polygons.geometry, polygons.sheet_id, polygons.dn').joins([polygon: :sheet]).where('sheets.id = ? AND flags.session_id = ? AND flags.flag_type = ?', sheet_id, session_id, type)
	end

	def self.flags_for_sheet_for_user(sheet_id, user_id, type = "geometry")
		# just need the count
		Flag.select('DISTINCT flags.polygon_id, flags.flag_value, polygons.geometry, polygons.sheet_id, polygons.dn').joins([polygon: :sheet]).joins('INNER JOIN usersessions ON usersessions.session_id = flags.session_id').where('sheets.id = ? AND usersessions.user_id = ? AND flags.flag_type = ?', sheet_id, user_id, type)
	end

	def self.grouped_flags_for_session(session_id, type = "geometry")
		# just need the count per sheet
		Flag.select('COUNT(DISTINCT flags.polygon_id) as flag_count, sheets.id, sheets.bbox').joins([polygon: :sheet]).where('flags.session_id = ? AND flags.flag_type = ?', session_id, type).group("sheets.id")
	end

	def self.grouped_flags_for_user(user_id, type = "geometry")
		# just need the count per sheet
		Flag.select('COUNT(DISTINCT flags.polygon_id) as flag_count, sheets.id, sheets.bbox').joins([polygon: :sheet]).joins('INNER JOIN usersessions ON usersessions.session_id = flags.session_id').where('usersessions.user_id = ? AND flags.flag_type = ?', user_id, type).group("sheets.id")
	end

	def self.flags_for_session(session_id, type = "geometry")
		Flag.select("DISTINCT polygon_id").where("session_id = ? AND flag_type = ?", session_id, type).count
	end
	
	def self.flags_for_user(user_id, type = "geometry")
		Flag.select("DISTINCT polygon_id").joins('INNER JOIN usersessions ON usersessions.session_id = flags.session_id').where('usersessions.user_id = ? AND flags.flag_type = ?', user_id, type).count    
	end

	def self.progress_for_session(session_id, type = "geometry")
		Flag.select("DISTINCT polygons.id, polygons.centroid_lat, polygons.centroid_lon, polygons.geometry, flags.*").joins(:polygon).where("flags.session_id = ? AND flags.flag_type = ?", session_id, type)
	end
	
	def self.progress_for_user(user_id, type = "geometry")
		Flag.select("DISTINCT polygons.id, polygons.centroid_lat, polygons.centroid_lon, polygons.geometry, flags.*").joins(:polygon).joins('INNER JOIN usersessions ON usersessions.session_id = flags.session_id').where('usersessions.user_id = ? AND flags.flag_type = ?', user_id, type)
	end
  
end
