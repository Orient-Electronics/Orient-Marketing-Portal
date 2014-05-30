class Location < ActiveRecord::Base

  has_one :shop

  belongs_to :city
  belongs_to :area

  attr_accessible :city_id, :latitude, :longitude, :area_id, :area_name
  attr_accessor :area_name
  validates_presence_of :longitude, :latitude, 
                        :presence =>true,
                        :format => {:with => /^[0-9]{1,5}((\.[0-9]{1,5})?)$/i }
  
  accepts_nested_attributes_for :area
  before_save :update_city_to_area

  def update_city_to_area
    self.area.update_attributes(city_id: self.city_id)
  end

  def complete_location
    [city.try(:name), area.try(:name)].join(", ")
  end


  def area_name
    self.area.try(:name) || ""
  end

  def area_name=(name)
    self.area = Area.find_by_name(name)
    if self.area.blank?
      self.area = Area.create :name => name
    end
  end

end
