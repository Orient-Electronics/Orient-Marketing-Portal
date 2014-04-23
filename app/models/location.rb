class Location < ActiveRecord::Base

  has_one :shop

  belongs_to :city
  belongs_to :area

  attr_accessible :area_id, :city_id, :latitude, :longitude

  validates_presence_of :area_id, :city_id 
  validates_presence_of :longitude, :latitude, 
                        :presence =>true,
                        :format => {:with => /^[0-9]{1,5}((\.[0-9]{1,5})?)$/i }

  def complete_location
    [city.try(:name), area.try(:name)].join(", ")
  end

end
