class Task < ActiveRecord::Base
  include PublicActivity::Common

  attr_accessible :assigned_by, :assigned_to, :comment, :shop_id, :status, :deadline, :task_type, :shop_name

  belongs_to :shop
  belongs_to :user
  has_one :post
  validates_presence_of :assigned_to, :message => "^ select the assigned to"
  validates_presence_of :shop_name, :message => "^ select the shop" 
  validates_presence_of :comment

  before_destroy :remove_public_activities

  def remove_public_activities
    PublicActivity::Activity.where(trackable_id: self.id, trackable_type: "Task").destroy_all
  end

  def completed?
    status == "completed"
  end

  def parent
    User.find(assigned_by).name
  end

  def child
    User.find(assigned_to).name
  end


  def shop_name
    self.shop.try(:dealer_name) || ""
  end

  def shop_name=(name)
    self.shop = Shop.find_by_dealer_name(name)
  end

end
