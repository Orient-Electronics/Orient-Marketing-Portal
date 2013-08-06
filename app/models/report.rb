class Report < ActiveRecord::Base

  has_many :report_lines, :dependent => :destroy
  has_many :products, :through => :report_lines

  belongs_to :shop
  belongs_to :user

  attr_accessible :data, :end_at, :report_type, :user_id, :shop_id, :start_at, :report_lines_attributes

  accepts_nested_attributes_for :report_lines

  def self.reports_of(value)
    Report.where(:report_type => value)
  end

  def self.brand_sales(reports,brand_id)
    reports.select{|key| key.report_type=="sales"}.collect(&:report_lines).flatten.select{|key| key.brand_id == brand_id }.collect(&:data).reject {|r|r.nil?}.sum
  end

  def self.brand_display(reports,brand_id)
    reports.select{|key| key.report_type=="display"}.collect(&:report_lines).flatten.select{|key| key.brand_id == brand_id }.collect(&:data).reject {|r|r.nil?}.sum
  end

  def self.brand_corner(reports,brand_id)
    reports.select{|key| key.report_type=="display_corner"}.collect(&:report_lines).flatten.select{|key| key.brand_id == brand_id }.collect(&:data).reject {|r|r.nil?}.sum
  end

end
