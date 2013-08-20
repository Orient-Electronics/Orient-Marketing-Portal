class Owner < ActiveRecord::Base

  belongs_to :shop
  has_one :avatar, :as => :avatarable, :dependent => :destroy

  attr_accessible :cell_number, :dob, :name, :shop_id
end
