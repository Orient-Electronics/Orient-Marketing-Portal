class City < ActiveRecord::Base

  has_many :locations

  attr_accessible :name

  validates_presence_of :name, :length => {:maximum => 30}, :presence => true
end
