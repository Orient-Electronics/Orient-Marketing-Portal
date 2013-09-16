class City < ActiveRecord::Base

  has_many :locations

  attr_accessible :name

  validates :name, :length => {:maximum => 30}, :presence => true
end
