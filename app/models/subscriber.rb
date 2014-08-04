class Subscriber < ActiveRecord::Base
  belongs_to :user
  has_many :activity_settings, :dependent => :destroy
  attr_accessible :subscribe_id, :user_id, :activity_settings_attributes
  accepts_nested_attributes_for :activity_settings
  after_create :send_email_sub_notification
  before_destroy :send_email_unsub_notification

  def activities
  	activities ||= []
		self.activity_settings.each do |activity|
			activities.concat(PublicActivity::Activity.where(owner_id: self.subscribe_id, key: activity.activity_name))
		end
		activities
	end

  def notifications
    notifications ||= []
    self.activity_settings.each do |activity|
      notifications.concat(PublicActivity::Activity.where(owner_id: self.subscribe_id, key: activity.activity_name, status: 'unread'))
    end
    notifications
  end

  def send_email_sub_notification
    subscribe = User.find(self.subscribe_id)
    subscriber = self.user
    UserMailer.subscriber_notification(subscriber, subscribe).deliver if subscriber.send_notification?
    UserMailer.subscribe_notification(subscriber, subscribe).deliver if subscribe.send_notification?
  end

  def send_email_unsub_notification
    subscribe = User.find(self.subscribe_id)
    subscriber = self.user
    UserMailer.unsubscriber_notification(subscriber, subscribe).deliver if subscriber.send_notification?
    UserMailer.unsubscribe_notification(subscriber, subscribe).deliver if subscribe.send_notification?
  end

end
