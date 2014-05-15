class Area < ActiveRecord::Base
  include PublicActivity::Common	

  belongs_to :city
  attr_accessible :name, :city_id

  validates :name, :length => {:maximum => 30}, :presence => true
end
