class SearchController < ApplicationController

  def index
    @search = Shop.search() do
      keywords params[:search] do
        highlight :dealer_name
      end

      paginate :page => params[:page], :per_page => 10
    end
    @shops = @search.results
    respond_to do |format|
      format.html
      format.json {render json: @search}
    end
  end

end