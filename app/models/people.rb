class People < ActiveRecord::Base	
  
  has_one :avatar, :as => :avatarable, :dependent => :destroy
  has_many :shops, through: :people_shops
  has_many :people_shops, :dependent => :destroy
  attr_accessible :cell_number, :date_of_birth, :designation, :name, :avatar_attributes
  accepts_nested_attributes_for :avatar
 
end
