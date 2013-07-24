class Product < ActiveRecord::Base

  has_and_belongs_to_many :brands

  attr_accessible :info, :name, :brand_ids

  accepts_nested_attributes_for :brands

end
