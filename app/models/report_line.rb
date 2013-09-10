class ReportLine < ActiveRecord::Base

  belongs_to :report
  belongs_to :product
  belongs_to :brand
  belongs_to :product_category
  
  has_one :avatar, :as => :avatarable, :dependent => :destroy

  attr_accessible :brand_id, :data, :product_id, :report_id, :product_category_id, :avatar_attributes

  accepts_nested_attributes_for :avatar
end
