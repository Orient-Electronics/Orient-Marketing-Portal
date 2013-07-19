class Location < ActiveRecord::Base

  has_one :shop

  belongs_to :city

  attr_accessible :area, :city_id, :latitude, :longitude
end
