class Manager < ActiveRecord::Base

  belongs_to :shop

  attr_accessible :cell_number, :dob, :name, :shop_id
end
