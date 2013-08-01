class ProductCategory < ActiveRecord::Base

  has_many :products, :dependent => :destroy

  attr_accessible :name
end
