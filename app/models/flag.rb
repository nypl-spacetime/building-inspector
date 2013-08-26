class Flag < ActiveRecord::Base
	belongs_to :polygon
	attr_accessible :flag_value, :is_primary, :polygon_id, :session_id, :flag_type
	validates :flag_value, presence: true
	validates :polygon_id, presence: true
	validates :flag_type, presence: true
end
