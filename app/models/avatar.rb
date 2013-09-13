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
                    :default_url => '/assets/default.png'

  validates :avatar, :presence => true                  
end
