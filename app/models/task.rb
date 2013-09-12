class Task < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :assigned_by, :assigned_to, :comment, :shop_id, :status, :important

  belongs_to :shop

  
  validates_presence_of :assigned_to, :message => "^ select the assigned_to"
  validates_presence_of :shop_id, :message => "^ select the shop" 
  validates_presence_of :comment
end
