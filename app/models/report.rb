class Report < ActiveRecord::Base

  belongs_to :shop
  belongs_to :representative

  attr_accessible :data, :end_at, :report_type, :representative_id, :shop_id, :start_at
end
