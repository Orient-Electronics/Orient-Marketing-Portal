class ShopCategory < ActiveRecord::Base

  has_many :shops

  attr_accessible :name

  validates_presence_of :name, :presence => true
end
