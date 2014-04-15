class Subscriber < ActiveRecord::Base
  belongs_to :user
  has_many :activity_settings, :dependent => :destroy
  attr_accessible :subscribe_id, :user_id, :activity_settings_attributes
  accepts_nested_attributes_for :activity_settings
end
