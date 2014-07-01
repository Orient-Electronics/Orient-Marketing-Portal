class ApplicationController < ActionController::Base

  include PublicActivity::StoreController

  before_filter :authenticate_user!
  before_filter :fetch_notification, :fetch_activities
  layout :change_layout
  before_filter :check_admin
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => "You are not authorize for this action"
  end
  protect_from_forgery

  def change_layout
      if current_user
        current_user.user_employee? ? 'employee' : 'application'
      else
        'application'
      end
  end

  def fetch_notification
    if current_user
      params[:page] = params[:page].blank? ? 1 : params[:page]
      @notifications_count = current_user.subscribers.collect(&:notifications).flatten.sort{|a, b| b[:created_at] <=> a[:created_at]}.count
      @notifications = Kaminari.paginate_array(current_user.subscribers.collect(&:notifications).flatten.sort{|a, b| b[:created_at] <=> a[:created_at]}).page(params[:page]).per(5)
    end
  end

  def fetch_activities
    if current_user
      params[:page] = params[:page].blank? ? 1 : params[:page]
      @activities = PublicActivity::Activity.order("created_at desc").where(owner_id: current_user.id, owner_type: "User").page(params[:page]).per(5)
    end
  end
  def check_admin
    if params[:controller] == 'rails_admin/main'
      unless current_user.user_admin?
        return redirect_to "/"
      end
    end
  end

  def after_sign_in_path_for(resource)
    resource.user_admin? ? '/admin' : session["user_return_to"]
  end

  # def current_user
  #   @current_user ||= User.find(session[:user_id]) if session[:user_id]
  # end
  helper_method :current_user
  hide_action :current_user

end