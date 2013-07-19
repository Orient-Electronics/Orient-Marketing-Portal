class Manager < ActiveRecord::Base
  attr_accessible :cell_number, :dob, :name, :shop_id
end
