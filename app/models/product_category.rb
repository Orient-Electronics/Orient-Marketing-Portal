class ProductCategory < ActiveRecord::Base

  has_many :products, :dependent => :destroy
  has_many :report_lines, :dependent => :destroy

  attr_accessible :name
end
