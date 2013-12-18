class Owner < ActiveRecord::Base

  belongs_to :shop
  has_one :avatar, :as => :avatarable, :dependent => :destroy

  attr_accessible :cell_number, :dob, :name, :shop_id

  validates :name, :presence => :true, :length => {:minimum => 3, :maximum => 25}
  #validates_numericality_of :cell_number,  :presence => true
end
