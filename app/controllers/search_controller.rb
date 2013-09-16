class SearchController < ApplicationController

  def index
  
    @search = Shop.search() do
      fulltext params[:search]
      paginate :page => params[:page], :per_page => 10
    end
    @shops = @search.results
    respond_to do |format|
      format.html
      format.json {render json: @search}
    end
  end

end