class ApplicationController < ActionController::Base

  before_filter :authenticate_representative!

  protect_from_forgery

end
