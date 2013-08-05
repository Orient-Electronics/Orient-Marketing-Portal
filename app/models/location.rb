class Location < ActiveRecord::Base

  has_one :shop

  belongs_to :city

  attr_accessible :area, :city_id, :latitude, :longitude

  def complete_location
    [city.try(:name), area].join(", ")
  end

end
