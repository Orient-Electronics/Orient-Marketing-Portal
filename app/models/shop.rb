class Shop < ActiveRecord::Base

  belongs_to :shop_category
  belongs_to :location
  belongs_to :dealer

  has_one :owner, :dependent => :destroy
  has_one :manager, :dependent => :destroy
  has_one :avatar, :as => :avatarable, :dependent => :destroy

  has_many :reports, :dependent => :destroy
  has_many :uploads, :as => :uploadable, :dependent => :destroy
  has_many :tasks, :dependent => :destroy

  attr_accessible :address, :orient_dealer, :dealer_name, :email, :location_id, :phone, :shop_category_id, :website, :location_attributes, :owner_attributes, :manager_attributes, :branch_of, :dealer_id, :branch_of, :avatar_attributes

  accepts_nested_attributes_for :owner
  accepts_nested_attributes_for :manager
  accepts_nested_attributes_for :location
  accepts_nested_attributes_for :avatar

  searchable do
    text :dealer_name, :address
    text :owner do
      owner.try(:name)
    end
    text :manager do
      manager.try(:name)
    end
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

end