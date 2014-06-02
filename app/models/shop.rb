class Shop < ActiveRecord::Base

  include PublicActivity::Common 
  belongs_to :shop_category
  belongs_to :location
  belongs_to :dealer

  has_one :owner, :dependent => :destroy
  has_one :manager, :dependent => :destroy
  has_one :avatar, :as => :avatarable, :dependent => :destroy

  has_many :reports, :dependent => :destroy
  has_many :uploads, :as => :uploadable, :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  has_many :posts, :dependent => :destroy
  has_many :peoples, through: :people_shops
  has_many :people_shops, :dependent => :destroy

  attr_accessible :address, :orient_dealer, :dealer_name, :email, :location_id, :phone, :shop_category_id, :website, :location_attributes, :owner_attributes, :manager_attributes, :dealer_id, :branch_of, :category, :avatar_attributes, :peoples_attributes

  accepts_nested_attributes_for :owner
  accepts_nested_attributes_for :manager
  accepts_nested_attributes_for :location
  accepts_nested_attributes_for :avatar
  accepts_nested_attributes_for :peoples, :allow_destroy => true

 
   validates :address, :presence => true, :length => { :maximum => 250 }
   validates_presence_of :dealer_name, :presence => true, :message => "^Shop Name Can't be Blank"

  validates_presence_of :shop_category_id
  before_destroy :remove_public_activities
  

  searchable do
    text :dealer_name, :stored => true
    integer :dealer_id
    integer :city_id do 
      location.city_id
    end
    integer :area_id do 
      location.area_id
    end
    integer :shop_category_id do
      shop_category.id
    end
  end

  def remove_public_activities
    PublicActivity::Activity.where(trackable_id: self.id, trackable_type: "Shop").destroy_all
  end

  def branch_of
    self.dealer.try(:name) || ""
  end

  def branch_of=(name)
    self.dealer = Dealer.find_by_name(name)
    if self.dealer.blank?
      self.dealer = Dealer.create :name => name
    end
  end

  def category=(name)
    self.shop_category = ShopCategory.find_or_create_by_name(name)
    return false if self.shop_category.blank?
    return true
  end
end