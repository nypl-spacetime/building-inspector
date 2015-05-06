class Consensuspolygon < ActiveRecord::Base
    attr_accessible :consensus, :flaggable_id, :flaggable_type, :task, :override_id
    belongs_to :flaggable, polymorphic: true
    validates :flaggable_type, presence: true
    validates :flaggable_id, presence: true
    validates :task, presence: true

    def self.remove_from_flaggable_id_and_type(id, type, task)
        consensus = where(:flaggable_id => id, :flaggable_type => type, :task => task)
        consensus.destroy if consensus != nil
    end
end
