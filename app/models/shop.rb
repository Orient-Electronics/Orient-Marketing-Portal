class Shop < ActiveRecord::Base
  attr_accessible :address, :dealer, :dealer_name, :email, :location_id, :phone, :shop_category_id, :website
end
