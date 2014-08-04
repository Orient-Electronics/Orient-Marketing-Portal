class HomeController < ApplicationController

  def index
  	params[:page] = params[:page].blank? ? 1 : params[:page]
    #@subscriber_activities = Kaminari.paginate_array(current_user.subscribers.collect(&:activities).flatten.sort{|a, b| b[:created_at] <=> a[:created_at]}).page(params[:page]).per(5)
    @user_activities = PublicActivity::Activity.order("created_at desc").where(owner_id: current_user.id, owner_type: "User") if current_user.user_employee?
    @subscriber_activities = current_user.subscribers.collect(&:activities).flatten.sort{|a, b| b[:created_at] <=> a[:created_at]}
  end

  def activities
  	params[:page] = params[:page].blank? ? 1 : params[:page]
  	@activities = PublicActivity::Activity.order("created_at desc").where(owner_id: current_user.id, owner_type: "User").page(params[:page]).per(5)
  	render :partial => '/home/activities', :layout => false
  end

  def notifications
  	 params[:page] = params[:page].blank? ? 1 : params[:page]
     @notifications_count = current_user.subscribers.collect(&:notifications).flatten.sort{|a, b| b[:created_at] <=> a[:created_at]}.count
     @notifications = Kaminari.paginate_array(current_user.subscribers.collect(&:notifications).flatten.sort{|a, b| b[:created_at] <=> a[:created_at]}).page(params[:page]).per(5)
     render :partial => '/home/notifications', :layout => false
  end

  def subscriber_activities
  	params[:page] = params[:page].blank? ? 1 : params[:page]
    @subscriber_activities = Kaminari.paginate_array(current_user.subscribers.collect(&:activities).flatten.sort{|a, b| b[:created_at] <=> a[:created_at]}).page(params[:page]).per(5)
    render :partial => '/home/subscriber_activities', :layout => false
  end

  def user_activities
    params[:page] = params[:page].blank? ? 1 : params[:page]
    user = User.find(params[:user_id])
    @user_activities = PublicActivity::Activity.order("created_at desc").where(owner_id: user.id, owner_type: "User").page(params[:page]).per(5)
    render :partial => '/home/user_activities', :layout => false
  end

  def toggle_email_notifications
    user = current_user
    user.send_notification  =  user.send_notification? ? false : true
    user.save
    flash[:notice] = "Email subscription updated"
    redirect_to :back
  end

end
