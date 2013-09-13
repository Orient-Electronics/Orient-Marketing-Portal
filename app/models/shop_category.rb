class ShopCategory < ActiveRecord::Base

  has_many :shops

  attr_accessible :name

  validates :name, :length => {:minimum => 3, :maximum => 20}, :presence => true 
end
