class ProductCategory < ActiveRecord::Base

  include PublicActivity::Common
  has_and_belongs_to_many :brands

  has_many :products, :dependent => :destroy
  has_many :report_lines, :dependent => :destroy

  has_many :posts, :dependent => :destroy

  attr_accessible :name, :brand_ids

  accepts_nested_attributes_for :brands

  validates :name , :presence => true
  validates_presence_of :brand_ids, :presence => true, :message => "^ please select brand/s"
  before_destroy :remove_public_activities

  def remove_public_activities
    PublicActivity::Activity.where(trackable_id: self.id, trackable_type: "ProductCategory").destroy_all
  end
end
