class HomeController < ApplicationController

  def index
    redirect_to reports_path
  end

end
