class City < ActiveRecord::Base

  include PublicActivity::Common	
  has_many :locations
  has_many :shops, through: :locations
  has_many :areas, :dependent => :destroy
  attr_accessible :name

  validates :name, :length => {:maximum => 30}, :presence => true
  before_destroy :remove_public_activities

  def remove_public_activities
    PublicActivity::Activity.where(trackable_id: self.id, trackable_type: "City").destroy_all
  end

  def dealer_shops(dealer)
  	shops.where(dealer_id: dealer.id)
  end
  
end
