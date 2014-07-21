class Post < ActiveRecord::Base

  include PublicActivity::Common

  attr_accessible :dealer_id, :shop_id, :user_id, :product_category_id, :reports_attributes, :year, :week, :published, :task_id, :approved_id, :uploads_attributes, :status

  attr_accessor :week, :year

  belongs_to :dealer
  belongs_to :shop
  belongs_to :user
  belongs_to :product_category
  belongs_to :task
  has_many :reports, :dependent => :destroy
  has_many :uploads, :as => :uploadable, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
  accepts_nested_attributes_for :reports
  accepts_nested_attributes_for :uploads, :allow_destroy => true

  scope :published_reports, where(:published => true)

  scope :with_shops,lambda { |id | where(:shop_id => id, :published => true) }

  scope :with_user, lambda {|user| where(:user_id => user.id)}
  scope :with_admin_user, where('status !=?', 'draft')
  before_save :update_reports_attribute
  before_destroy :remove_public_activities

  def remove_public_activities
    PublicActivity::Activity.where(trackable_id: self.id, trackable_type: "Post").destroy_all
  end

  def self.sort_data(data, sort_by)
    data.joins(:reports).joins(:product_category).joins(:user).joins(:shop).joins("LEFT OUTER JOIN locations ON shops.location_id = locations.id").joins("LEFT OUTER JOIN cities ON locations.city_id = cities.id").order(sort_by)
  end

  def self.apply_search_filter(data,key_word)
    search_keyword = ["%",key_word,"%"].join('')
    data.joins(:reports).joins(:product_category).joins(:user).joins(:shop).joins("LEFT OUTER JOIN locations ON shops.location_id = locations.id").joins("LEFT OUTER JOIN cities ON locations.city_id = cities.id").where('posts.id like ? OR dealer_name like ? OR product_categories.name like ? OR cities.name like ? OR week like ? OR posts.created_at like ? OR first_name like ?', search_keyword, search_keyword, search_keyword, search_keyword, search_keyword, search_keyword, search_keyword)
  end

  def update_reports_attribute
    unless self.year.blank?
      self.reports.each do |report|
        report.year = self.year
        report.week = self.week
      end
    end
  end

  def submit?
    self.status == "submit"
  end

  def week_number
    [self.reports.first.year, self.reports.first.week].join("-")
  end

  def created_at_format
    self.created_at.strftime("%B %d, %Y - %I:%M %p")
  end

end
