class ApplicationController < ActionController::Base

  before_filter :authenticate_user!
  layout :change_layout
  protect_from_forgery

  def change_layout
    if current_user
      if current_user.user_type.name == "employee" 
      'employee'
      else
        'application'
      end
    else
      'application'
    end      
  end
  
end

  