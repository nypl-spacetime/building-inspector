class Polygon < ActiveRecord::Base
	has_many :flags, :dependent => :destroy
	belongs_to :sheet
	attr_accessible :color, :geometry, :sheet_id, :status, :vectorizer_json, :dn
end
