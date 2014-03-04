class Post < ActiveRecord::Base
  attr_accessible :dealer_id, :shop_id, :user_id, :product_category_id, :reports_attributes, :year, :week, :published, :task_id

  attr_accessor :week, :year

  belongs_to :dealer
  belongs_to :shop
  belongs_to :user
  belongs_to :product_category
  belongs_to :task
  has_many :reports, :dependent => :destroy

  accepts_nested_attributes_for :reports

  scope :published_reports, where(:published => true)

  before_save :update_reports_attribute

  def update_reports_attribute
    self.reports.each do |report|
      report.year = self.year
      report.week = self.week
    end
  end
end
