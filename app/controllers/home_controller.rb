class HomeController < ApplicationController

  def index
    @subscriber_activities = current_user.subscribers.collect(&:activities).flatten.sort{|a, b| b[:created_at] <=> a[:created_at]}
  end

end
