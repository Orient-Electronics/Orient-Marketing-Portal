class Product < ActiveRecord::Base

  has_and_belongs_to_many :brands

  has_many :report_lines
  has_many :reports, :through => :report_lines

  belongs_to :product_category

  attr_accessible :info, :name, :brand_ids, :product_category_id, :presence => true

  accepts_nested_attributes_for :brands

  validates_presence_of :name, :length => {:maximum => 30} 
  validates_presence_of :brand_ids, :message => "^ Please select brand/s"
  validates_presence_of :product_category_id,  :message => "^ Please select product_category"
  validates_presence_of :info
end
