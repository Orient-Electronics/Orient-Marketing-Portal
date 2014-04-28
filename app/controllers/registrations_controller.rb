class RegistrationsController < Devise::RegistrationsController

  def create
    super
    current_user.create_activity :create, :owner => current_user
  end

  def update
    
    if params[:user][:password].blank?
      params[:user].delete :current_password
      params[:user].delete :password
      params[:user].delete :password_confirmation
      if current_user.update_attributes(params[:user]) 
    	  current_user.create_activity :update, :owner => current_user
        redirect_to '/'
      else
        redirect_to '/'
      end
    else
      if current_user.update_with_password(params[:user]) 
        current_user.create_activity :update, :owner => current_user
        sign_in @user, :bypass => true
        redirect_to '/'
      else
        redirect_to '/'
      end
    end    
  end

  def destroy
  	super
  	current_user.create_activity :destroy, :owner => current_user
  end
end