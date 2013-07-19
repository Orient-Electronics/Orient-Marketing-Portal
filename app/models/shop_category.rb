class ShopCategory < ActiveRecord::Base

  has_many :shops

  attr_accessible :name
end
