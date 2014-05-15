class Brand < ActiveRecord::Base
 
  include PublicActivity::Common	
  has_and_belongs_to_many :products
  has_and_belongs_to_many :product_categories
  has_many :report_lines
  attr_accessible :name
  
  validates_uniqueness_of :name, :length => {:minimum => 3, :maximum => 30}, :presence => true 
  before_destroy :remove_public_activities

  def remove_public_activities
    PublicActivity::Activity.where(trackable_id: self.id, trackable_type: "Brand").destroy_all
  end

end