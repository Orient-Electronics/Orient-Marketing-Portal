class Avatar < ActiveRecord::Base

  belongs_to :avatarable, :polymorphic => true
  has_many :comments, :as => :commentable, :dependent => :destroy
  attr_accessible :avatar, :avatarable_id, :avatarable_type, :comments_attributes
  has_attached_file :avatar,
                    :styles => {
                        :thumb => "75x75#",
                        :small_thumb => "27x27#",
                        :small => "150x150#",
                        :medium => "500x500>"
                    },
                    :default_url => '/assets/noimage.jpg'
  scope :report_line_avatars, lambda {|id| where(:avatarable_type => "ReportLine", :avatarable_id => id)}
  accepts_nested_attributes_for :comments, :allow_destroy => true
  validates_attachment_size :avatar, :less_than => 5.megabytes, :message => "^ Please select image with size less than 5MB"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
end
