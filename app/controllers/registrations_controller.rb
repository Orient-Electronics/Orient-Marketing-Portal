class RegistrationsController < Devise::RegistrationsController

  def new
    current_user.create_activity :create, :owner => current_user
    return redirect_to user_session_path
  end
end