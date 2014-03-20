class Consensuspolygon < ActiveRecord::Base
  attr_accessible :consensus, :polygon_id, :task, :override_id
  belongs_to :polygon
end
