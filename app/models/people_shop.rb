class PeopleShop < ActiveRecord::Base
  belongs_to :shop
  belongs_to :people
  attr_accessible :people_id, :shop_id
end
