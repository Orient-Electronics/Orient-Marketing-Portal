class Report < ActiveRecord::Base

  has_many :report_lines, :dependent => :destroy
  has_many :products, :through => :report_lines

  belongs_to :shop
  belongs_to :representative

  attr_accessible :data, :end_at, :report_type, :representative_id, :shop_id, :start_at, :report_lines_attributes

  accepts_nested_attributes_for :report_lines

end
