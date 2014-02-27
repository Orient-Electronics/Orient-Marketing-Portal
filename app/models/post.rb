class Post < ActiveRecord::Base
  attr_accessible :dealer_id, :shop_id, :user_id, :product_category_id, :reports_attributes, :year, :week

  attr_accessor :week, :year

  belongs_to :dealer
  belongs_to :shop
  belongs_to :user
  belongs_to :product_category

  has_many :reports, :dependent => :destroy

  accepts_nested_attributes_for :reports

  def year
    self.reports.first.year
	end

  def year=(value)
    self.reports.each do |report|
      report.year = value
    end
  end

  def week
    self.reports.first.week
  end

  def week=(value)
    self.reports.each do |report|
      report.week = value
    end
  end

end
