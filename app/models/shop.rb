class Shop < ActiveRecord::Base

  belongs_to :shop_category
  belongs_to :location

  has_one :owner, :dependent => :destroy
  has_one :manager, :dependent => :destroy

  has_many :reports, :dependent => :destroy
  has_many :uploads, :as => :uploadable, :dependent => :destroy

  attr_accessible :address, :dealer, :dealer_name, :email, :location_id, :phone, :shop_category_id, :website, :location_attributes, :owner_attributes, :manager_attributes, :branch_of

  accepts_nested_attributes_for :owner
  accepts_nested_attributes_for :manager
  accepts_nested_attributes_for :location

end
