module PublicActivity
  module ORM
    module ActiveRecord
      # The ActiveRecord model containing
      # details about recorded activity.
      class Activity < ::ActiveRecord::Base
        attr_accessible :comments_attributes
        has_many :comments, :as => :commentable, :dependent => :destroy

        accepts_nested_attributes_for :comments, :allow_destroy => true

        after_create :send_email_to_subscriber

        def send_email_to_subscriber
          subscribers = Subscriber.where(subscribe_id: self.owner.id)
          subscribers.each do |subscriber|
            UserMailer.subscriber_activity(self, subscriber.user, self.owner).deliver if subscriber.user.send_notification?
          end
        end
      end
    end
  end
end