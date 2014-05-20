class Area < ActiveRecord::Base
  include PublicActivity::Common	
  has_many :locations
  has_many :shops, through: :locations
  belongs_to :city
  attr_accessible :name, :city_id

  validates :name, :length => {:maximum => 30}, :presence => true
  validates_presence_of :city_id, :message => "^please select the city"

  def dealer_shops(dealer)
  	shops.where(dealer_id: dealer.id)
  end

  def city_dealer_shops(dealer_shops)
  	shops.where(id: dealer_shops.collect(&:id))
  end
end
