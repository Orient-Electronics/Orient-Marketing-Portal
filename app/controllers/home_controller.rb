class HomeController < ApplicationController

  def index
  	params[:page] = params[:page].blank? ? 1 : params[:page]
    @subscriber_activities = Kaminari.paginate_array(current_user.subscribers.collect(&:activities).flatten.sort{|a, b| b[:created_at] <=> a[:created_at]}).page(params[:page]).per(5)
  end

end
