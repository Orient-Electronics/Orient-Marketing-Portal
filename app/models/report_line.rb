class ReportLine < ActiveRecord::Base

  belongs_to :report
  belongs_to :product
  belongs_to :brand
  belongs_to :product_category
  
  has_many :avatars, :as => :avatarable, :dependent => :destroy

  attr_accessible :brand_id, :data, :product_id, :report_id, :product_category_id, :avatars_attributes

  accepts_nested_attributes_for :avatars
end
