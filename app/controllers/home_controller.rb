class HomeController < ApplicationController

  def index
    @activities ||= []
    @subscribers = current_user.subscribers
    @subscribers.each do |subscriber|
    	@activities.concat(subscriber.activities)
    end
    @activities = @activities.sort {|a, b| b[:created_at] <=> a[:created_at]}
  end

end
