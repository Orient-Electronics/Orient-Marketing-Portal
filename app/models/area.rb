class Area < ActiveRecord::Base
  include PublicActivity::Common	
  has_many :locations
  belongs_to :city
  attr_accessible :name, :city_id

  validates :name, :length => {:maximum => 30}, :presence => true
  validates_presence_of :city_id, :message => "^please select the city"
end
