class Task < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :assigned_by, :assigned_to, :comment, :shop_id, :status, :important

  belongs_to :shop
  belongs_to :user
  
  validates_presence_of :assigned_to, :message => "^ select the assigned to"
  validates_presence_of :shop_id, :message => "^ select the shop" 
  validates_presence_of :comment

  def completed?
    status == "completed"
  end

  def parent
    User.find(assigned_by).name
  end

  def child
    User.find(assigned_to).name
  end

end
