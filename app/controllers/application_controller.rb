class ApplicationController < ActionController::Base

  before_filter :authenticate_user!
  layout :change_layout
  before_filter :check_admin
  protect_from_forgery

  def change_layout
    if current_user
       if current_user.user_type.try(:name) == 'employee'
          'employee'
       else
          'application'
       end
    else
      'application'
    end
  end

  def check_admin
    if params[:controller] == 'rails_admin/main'
      unless current_user.user_type.name == 'admin'
        return redirect_to "/"
      end
    end
  end
end