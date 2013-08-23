class Flag < ActiveRecord::Base
	belongs_to :polygon
	attr_accessible :flag_value, :is_primary, :polygon_id, :session_id, :type
end
