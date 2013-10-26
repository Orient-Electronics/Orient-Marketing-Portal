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
  include Rails.application.routes.url_helpers
end
