class HomeController < ApplicationController

  def index
  	params[:page] = params[:page].blank? ? 1 : params[:page]
    @subscriber_activities = Kaminari.paginate_array(current_user.subscribers.collect(&:activities).flatten.sort{|a, b| b[:created_at] <=> a[:created_at]}).page(params[:page]).per(5)
  end

  def activities
  	params[:page] = params[:page].blank? ? 1 : params[:page]
  	@activities = PublicActivity::Activity.order("created_at desc").where(owner_id: current_user.id, owner_type: "User").page(params[:page]).per(5)
  	render :partial => '/home/activities', :layout => false
  end

end
