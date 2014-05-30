class Area < ActiveRecord::Base
  include PublicActivity::Common	
  has_many :locations
  has_many :shops, through: :locations
  belongs_to :city
  attr_accessible :name, :city_id

  validates :name, :length => {:maximum => 30}, :presence => true
  before_destroy :remove_public_activities

  def dealer_shops(dealer)
  	shops.where(dealer_id: dealer.id)
  end

  def city_dealer_shops(dealer_shops)
  	shops.where(id: dealer_shops.collect(&:id))
  end

  def city_shops(city_shops)
    shops.where(id: city_shops.collect(&:id))
  end


  def remove_public_activities
    PublicActivity::Activity.where(trackable_id: self.id, trackable_type: "Area").destroy_all
  end
end
