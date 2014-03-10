class Brand < ActiveRecord::Base
 
  include PublicActivity::Common	
  has_and_belongs_to_many :products
  has_and_belongs_to_many :product_categories
  has_many :report_lines
  attr_accessible :name

  validates_uniqueness_of :name, :length => {:minimum => 3, :maximum => 30}, :presence => true 
end