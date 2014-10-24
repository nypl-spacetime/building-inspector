class Layer < ActiveRecord::Base
  has_many :sheets, :dependent => :restrict
  attr_accessible :description, :name, :tilejson, :year, :bbox, :external_id
end
