class Dealer < ActiveRecord::Base
  attr_accessible :name, :avatar_attributes

  has_many :shops, :dependent => :destroy
  has_one :avatar, :as => :avatarable, :dependent => :destroy

  accepts_nested_attributes_for :avatar

  validates_presence_of :name, :length => {:minimum => 3, :maximum => 25}
  validates_presence_of :avatar

end
