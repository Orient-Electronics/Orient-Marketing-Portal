class ActivitiesController < ApplicationController
  def index
    params[:page] = params[:page].blank? ? 1 : params[:page]
  	@user = User.find  params[:user_id]
    @user_activities = PublicActivity::Activity.order("created_at desc").where("owner_id=? OR trackable_id=? AND owner_type=?", params[:user_id],params[:user_id],"User").page(params[:page]).per(5)
    @subscribers = @user.subscribers
  end

  def create
    @activity = PublicActivity::Activity.new
    @activity.message = params[:activity][:message]
    @activity.trackable_id = @activity.recipient_id = params[:activity][:recipient_id]
    @activity.recipient_type = @activity.owner_type = @activity.trackable_type = "User"
    @activity.key = "user.post"
    @activity.owner_id = current_user.id
    if @activity.save
      flash[:notice] = "Activity successfully created"
    else
      flash[:warning] = "Some thing wrong while created your activity"
    end
    respond_to do |format|
      format.js
    end
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
