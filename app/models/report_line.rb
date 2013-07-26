class ReportLine < ActiveRecord::Base

  belongs_to :report
  belongs_to :product
  belongs_to :brand

  attr_accessible :brand_id, :data, :product_id, :report_id
end
