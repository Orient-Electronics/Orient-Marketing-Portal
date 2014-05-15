class ShopCategory < ActiveRecord::Base

  include PublicActivity::Common	
  attr_accessible :name, :avatar_attributes
  has_many :shops
  has_one :avatar, :as => :avatarable, :dependent => :destroy

  accepts_nested_attributes_for :avatar

  validates :name, :presence => true 
  validates_presence_of :avatar, :message => "^please upload the marker pin"
  before_destroy :remove_public_activities

  def remove_public_activities
    PublicActivity::Activity.where(trackable_id: self.id, trackable_type: "ShopCategory").destroy_all
  end
end
