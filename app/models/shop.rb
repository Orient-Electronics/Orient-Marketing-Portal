class Shop < ActiveRecord::Base

  belongs_to :shop_category
  belongs_to :location

  has_one :owner
  has_one :manager

  attr_accessible :address, :dealer, :dealer_name, :email, :location_id, :phone, :shop_category_id, :website, :location_attributes, :owner_attributes, :manager_attributes

  accepts_nested_attributes_for :owner
  accepts_nested_attributes_for :manager
  accepts_nested_attributes_for :location

end
