class Announcement < ActiveRecord::Base
  include PublicActivity::Common
  attr_accessible :announcement

  after_save :update_user

  def update_user
  	User.all.each do |user|
  		user.update_attributes(:view_announcement => true)
  	end
  end
end


