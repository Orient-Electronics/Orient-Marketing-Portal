class Dealer < ActiveRecord::Base
  attr_accessible :name

  has_many :shops, :dependent => :destroy

end
