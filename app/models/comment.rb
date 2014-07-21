class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :user
  attr_accessible :commentable_id, :commentable_type, :content, :user_id
  validates_presence_of :commentable_id, :commentable_type, :content, :user_id
  def created_at_format
    self.created_at.strftime("%B %d, %Y - %I:%M %p")
  end
end
