class ActivitiesController < ApplicationController
  def index
  	@user = User.find  params[:user_id]
  	@activities = PublicActivity::Activity.order("created_at desc").where(owner_id: params[:user_id], owner_type: "User")
  end

  def subscriber
  	@user = current_user
  	subscribe = User.find(params[:id])
  	@subscriber =  @user.subscribers.build :subscribe_id => subscribe.id

  	p @subscriber
  end

  def create_subscriber
  	@subscriber = Subscriber.new(params[:subscriber])
  	if @subscriber.save
  		redirect_to  activities_path(:user_id => @subscriber.subscribe_id)
  	else
  		redirect_to  activities_path(:user_id => @subscriber.subscribe_id)
  	end
  end
end
