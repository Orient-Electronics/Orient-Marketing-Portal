class ProductCategory < ActiveRecord::Base

  has_and_belongs_to_many :brands

  has_many :products, :dependent => :destroy
  has_many :report_lines, :dependent => :destroy

  attr_accessible :name, :brand_ids

  accepts_nested_attributes_for :brands

end
