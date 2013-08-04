class Brand < ActiveRecord::Base

  has_and_belongs_to_many :products
  has_and_belongs_to_many :product_categories

  has_many :report_lines

  attr_accessible :name
end
