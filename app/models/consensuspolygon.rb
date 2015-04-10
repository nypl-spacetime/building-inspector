class Consensuspolygon < ActiveRecord::Base
  attr_accessible :consensus, :polygon_id, :task, :override_id
  belongs_to :polygon

  def self.remove_from_flaggable_id_and_type(id, type, task)
    # TODO: consensus is still poly-based so change this in the future to support sheet/any
    consensus = where(:polygon_id => id, :task => task)
    consensus.destroy if consensus != nil
  end
end
