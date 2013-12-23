class ShopCategory < ActiveRecord::Base

  attr_accessible :name, :avatar_attributes
  has_many :shops
  has_one :avatar, :as => :avatarable, :dependent => :destroy

  accepts_nested_attributes_for :avatar

  validates :name, :length => {:minimum => 3, :maximum => 20}, :presence => true 
  validates_presence_of :avatar, :message => "^please upload the marker pin"

end
