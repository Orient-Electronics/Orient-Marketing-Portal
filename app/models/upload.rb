class Upload < ActiveRecord::Base

  belongs_to :uploadable, :polymorphic => true
  acts_as_commentable
  attr_accessible :upload, :uploadable_id, :uploadable_type
  has_attached_file :upload,
                    :styles => {
                        :thumb => "75x75#",
                        :small => "150x150#",
                        :medium => "500x500>"
                    },
                    :default_url => '/assets/noimage.jpg'

  scope :with_shops, lambda {|id| where(:uploadable_type => "Shop", :uploadable_id => id)}
  scope :with_posts, lambda {|id| where(:uploadable_type => "Post", :uploadable_id => id)}
  validates_attachment_presence :upload
  validates_attachment_size :upload, :less_than => 5.megabytes, :message => "^ Please select image with size less than 5MB"
  validates_attachment_content_type :upload, :content_type => /\Aimage\/.*\Z/
  include Rails.application.routes.url_helpers
end
