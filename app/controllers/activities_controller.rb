class ActivitiesController < ApplicationController
  def index
  	@user = User.find  params[:user_id]
  	@activities = PublicActivity::Activity.order("created_at desc").where(owner_id: params[:user_id], owner_type: "User")
  end
end
