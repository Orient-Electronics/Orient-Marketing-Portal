class ActivitySetting < ActiveRecord::Base
  belongs_to :subscriber
  attr_accessible :activity_name, :activity_type, :subscriber_id
end
