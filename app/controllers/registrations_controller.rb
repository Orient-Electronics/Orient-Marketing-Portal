class RegistrationsController < Devise::RegistrationsController

  def new
    return redirect_to user_session_path
  end
end