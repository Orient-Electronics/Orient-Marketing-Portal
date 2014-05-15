class City < ActiveRecord::Base

  include PublicActivity::Common	
  has_many :locations
  has_many :areas, :dependent => :destroy
  attr_accessible :name

  validates :name, :length => {:maximum => 30}, :presence => true
end
