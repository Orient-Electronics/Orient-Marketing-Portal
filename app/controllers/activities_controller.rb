class ActivitiesController < ApplicationController
  def index
  	@user = User.find  params[:user_id]
    @activities = PublicActivity::Activity.order("created_at desc").where(owner_id: params[:user_id], owner_type: "User")
    @subscribers = @user.subscribers
  end

  def create_subscriber
  	@subscriber = Subscriber.new(params[:subscriber])
  	if @subscriber.save
  		redirect_to  activities_path(:user_id => @subscriber.subscribe_id)
  	else
  		redirect_to  activities_path(:user_id => @subscriber.subscribe_id)
  	end
  end

  def destroy_subscriber
  	@user = current_user
  	@subscriber = Subscriber.find_by_user_id_and_subscribe_id(current_user.id, params[:id])
  	if @subscriber.destroy
  		redirect_to  activities_path(:user_id => params[:id])
  	else
  		redirect_to  activities_path(:user_id => params[:id])
  	end
  end

  def update_activity
    @activity = PublicActivity::Activity.find(params[:id])
    
    @activity.status = "read"
    if @activity.save
      render :text => 'success'
    else
      render :text => 'falied'
    end  
  end
end
