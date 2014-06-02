class Dealer < ActiveRecord::Base

  include PublicActivity::Common	
  attr_accessible :name, :avatar_attributes

  has_many :shops, :dependent => :destroy
  has_one :avatar, :as => :avatarable, :dependent => :destroy

  has_many :posts, :dependent => :destroy

  accepts_nested_attributes_for :avatar

  validates :name,  :presence => true
  #validates_presence_of :avatar, :message => "^please upload the picture"
  
  before_destroy :remove_public_activities

  def remove_public_activities
    PublicActivity::Activity.where(trackable_id: self.id, trackable_type: "Dealer").destroy_all
  end
  
end
