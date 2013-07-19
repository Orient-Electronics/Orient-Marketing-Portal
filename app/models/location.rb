class Location < ActiveRecord::Base
  attr_accessible :area, :city_id, :latitude, :longitude
end
