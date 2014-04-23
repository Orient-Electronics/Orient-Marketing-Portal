class Upload < ActiveRecord::Base

  belongs_to :uploadable, :polymorphic => true

  attr_accessible :upload, :uploadable_id, :uploadable_type
  has_attached_file :upload,
                    :styles => {
                        :thumb => "75x75#",
                        :small => "150x150#",
                        :medium => "500x500>"
                    }
  validates_attachment_presence :upload
  validates_attachment_size :upload, :less_than => 1.megabytes, :message => "^ Please select image with size less than 1MB" 
  include Rails.application.routes.url_helpers
end
