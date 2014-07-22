class Dealer < ActiveRecord::Base

  include PublicActivity::Common
  attr_accessible :name, :avatar_attributes, :comments_attributes

  has_many :shops, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_one :avatar, :as => :avatarable, :dependent => :destroy

  has_many :posts, :dependent => :destroy

  accepts_nested_attributes_for :avatar

  validates :name,  :presence => true
  #validates_presence_of :avatar, :message => "^please upload the picture"
  accepts_nested_attributes_for :comments, :allow_destroy => true
  before_destroy :remove_public_activities

  def remove_public_activities
    PublicActivity::Activity.where(trackable_id: self.id, trackable_type: "Dealer").destroy_all
  end

end
