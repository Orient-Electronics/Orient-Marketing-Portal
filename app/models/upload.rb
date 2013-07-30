class Upload < ActiveRecord::Base

  belongs_to :uploadable, :polymorphic => true

  attr_accessible :upload, :uploadable_id, :uploadable_type
  has_attached_file :upload,
                    :styles => {
                        :thumb => "75x75#",
                        :small => "150x150#",
                        :medium => "500x500>"
                    }

  include Rails.application.routes.url_helpers

  def to_jq_upload
    {
      "name" => read_attribute(:upload_file_name),
      "size" => read_attribute(:upload_file_size),
      "url" => upload.url(:original),
      "thumbnail_url" => upload.url(:thumb),
      "delete_url" => upload_path(self),
      "delete_type" => "DELETE" 
    }
  end

end
