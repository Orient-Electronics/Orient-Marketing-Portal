class Subscriber < ActiveRecord::Base
  belongs_to :user
  has_many :activity_settings, :dependent => :destroy
  attr_accessible :subscribe_id, :user_id, :activity_settings_attributes
  accepts_nested_attributes_for :activity_settings

  def activities
  	activities ||= []
		self.activity_settings.each do |activity|
			activities.concat(PublicActivity::Activity.where(owner_id: self.subscribe_id, key: activity.activity_name))
		end
		activities
	end
end
