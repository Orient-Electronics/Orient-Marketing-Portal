class Dealer < ActiveRecord::Base

  include PublicActivity::Common	
  attr_accessible :name, :avatar_attributes

  has_many :shops, :dependent => :destroy
  has_one :avatar, :as => :avatarable, :dependent => :destroy

  has_many :posts, :dependent => :destroy

  accepts_nested_attributes_for :avatar

  validates :name,  :presence => true
  #validates_presence_of :avatar, :message => "^please upload the picture"

end
