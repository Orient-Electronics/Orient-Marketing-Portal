class Avatar < ActiveRecord::Base

  belongs_to :avatarable, :polymorphic => true

  attr_accessible :avatar, :avatarable_id, :avatarable_type
  has_attached_file :avatar,
                    :styles => {
                        :thumb => "75x75#",
                        :small_thumb => "27x27#",
                        :small => "150x150#",
                        :medium => "500x500>"
                    },
                    :default_url => '/assets/noimage.jpg'
  validates_attachment_size :avatar, :less_than => 5.megabytes, :message => "^ Please select image with size less than 5MB" 
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
end
