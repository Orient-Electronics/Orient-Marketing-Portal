class Product < ActiveRecord::Base

  include PublicActivity::Common
  has_and_belongs_to_many :brands

  has_many :report_lines
  has_many :reports, :through => :report_lines

  belongs_to :product_category

  attr_accessible :info, :name, :brand_ids, :product_category_id, :presence => true

  accepts_nested_attributes_for :brands

  validates_presence_of :name
  validates_presence_of :brand_ids, :message => "^ Please select brand/s"
  validates_presence_of :product_category_id,  :message => "^ Please select product_category"
  before_destroy :remove_public_activities

  def remove_public_activities
    PublicActivity::Activity.where(trackable_id: self.id, trackable_type: "Product").destroy_all
  end
end
