class Report < ActiveRecord::Base
  include PublicActivity::Common
  has_many :report_lines, :dependent => :destroy
  has_many :products, :through => :report_lines

  belongs_to :shop
  belongs_to :user

  belongs_to :post

  attr_accessible :data, :week, :year, :report_type, :user_id, :shop_id, :report_lines_attributes, :post_id

  accepts_nested_attributes_for :report_lines

  scope :post_reports, lambda { |id | where(:post_id => id) }
  scope :corner_reports, lambda {|id| where(:id => id, :report_type => "display_corner") } 


  validates_presence_of :report_type, :user_id
  validates_associated :report_lines

  def self.reports_of(value)
    Report.where(:report_type => value)
  end

  def self.brand_sales(reports,brand_id)
    reports.select{|key| key.report_type=="sales"}.collect(&:report_lines).flatten.select{|key| key.brand_id == brand_id }.collect(&:data).reject {|r|r.nil?}.sum
  end

  def self.brand_display(reports,brand_id)
    count = reports.select{|key| key.report_type=="display"}.collect(&:report_lines).flatten.select{|key| key.brand_id == brand_id }.collect(&:data).reject {|r|r.nil?}.count
    sum = reports.select{|key| key.report_type=="display"}.collect(&:report_lines).flatten.select{|key| key.brand_id == brand_id }.collect(&:data).reject {|r|r.nil?}.sum
    if sum == 0
      0
    else  
      (sum/count)
    end  
  end

  def self.brand_corner(reports,brand_id)
    reports.select{|key| key.report_type=="display_corner"}.collect(&:report_lines).flatten.select{|key| key.brand_id == brand_id }.collect(&:data).reject {|r|r.nil?}.sum
  end

  def self.category_sales(reports,category_id,brand)
    if brand.nil?
      sum = reports.select{|key| key.report_type=="sales"}.collect(&:report_lines).flatten.select{|key| key.product_category_id == category_id }.collect(&:data).reject {|r|r.nil?}.sum
      count = reports.select{|key| key.report_type=="sales"}.collect(&:report_lines).flatten.select{|key| key.product_category_id == category_id }.collect(&:data).reject {|r|r.nil?}.count
    else
      sum = reports.select{|key| key.report_type=="sales"}.collect(&:report_lines).flatten.select{|key| key.product_category_id == category_id && key.brand_id == brand }.collect(&:data).reject {|r|r.nil?}.sum
      count = reports.select{|key| key.report_type=="sales"}.collect(&:report_lines).flatten.select{|key| key.product_category_id == category_id && key.brand_id == brand }.collect(&:data).reject {|r|r.nil?}.count
    end
    if sum == 0
      0
    else  
      (sum/count)
    end
  end

  def self.category_display(reports,category_id,brand)
    if brand.nil?
      reports.select{|key| key.report_type=="display"}.collect(&:report_lines).flatten.select{|key| key.product_category_id == category_id }.collect(&:data).reject {|r|r.nil?}.sum
    else
      reports.select{|key| key.report_type=="display"}.collect(&:report_lines).flatten.select{|key| key.product_category_id == category_id && key.brand_id == brand }.collect(&:data).reject {|r|r.nil?}.sum
    end
  end

  def self.category_corner(reports,category_id,brand)
    if brand.nil?
      reports.select{|key| key.report_type=="display_corner"}.collect(&:report_lines).flatten.select{|key| key.product_category_id == category_id }.collect(&:data).reject {|r|r.nil?}.sum
    else
      reports.select{|key| key.report_type=="display_corner"}.collect(&:report_lines).flatten.select{|key| key.product_category_id == category_id && key.brand_id == brand }.collect(&:data).reject {|r|r.nil?}.sum
    end
  end

  def report_view(brand_id)
    self.report_lines.flatten.select{|key| key.brand_id == brand_id }.collect(&:data).reject {|r|r.nil?}.sum
  end
  
end
