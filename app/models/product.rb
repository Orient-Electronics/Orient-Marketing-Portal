class Product < ActiveRecord::Base

  has_and_belongs_to_many :brands

  has_many :report_lines
  has_many :reports, :through => :report_lines

  belongs_to :product_category

  attr_accessible :info, :name, :brand_ids, :product_category_id

  accepts_nested_attributes_for :brands

end
