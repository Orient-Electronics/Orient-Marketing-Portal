class Dealer < ActiveRecord::Base
  attr_accessible :name

  has_many :shops, :dependent => :destroy
  has_one :avatar, :as => :avatarable, :dependent => :destroy

end
