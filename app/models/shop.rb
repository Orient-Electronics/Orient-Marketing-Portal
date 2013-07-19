class Shop < ActiveRecord::Base

  belongs_to :shop_category
  belongs_to :location

  has_one :owner
  has_one :manager

  attr_accessible :address, :dealer, :dealer_name, :email, :location_id, :phone, :shop_category_id, :website

end
