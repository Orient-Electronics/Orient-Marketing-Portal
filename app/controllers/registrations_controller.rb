class RegistrationsController < Devise::RegistrationsController

  def create
    super
    current_user.create_activity :create, :owner => current_user
  end

  def update
  	super
  	current_user.create_activity :update, :owner => current_user
  end

  def destroy
  	super
  	current_user.create_activity :destroy, :owner => current_user
  end
end