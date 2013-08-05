class ReportsController < ApplicationController

  def index
    @shop = Shop.find params[:shop_id]
    @reports = @shop.reports
  end

  def new
    @shop = Shop.find params[:shop_id]
    @report = Report.new
    unless params[:product_id].blank?
      @product = Product.find params[:product_id]
    else
      @product = ProductCategory.find params[:product_category_id]
    end
  end

  def create
    @shop = Shop.find params[:shop_id]
    params[:report].each do |report|
      @report = Report.new report.last
      @report.user = current_user
      @report.shop_id = params[:shop_id]
      @report.save
    end
    respond_to do |format|
        format.json { render json: @shop, status: :created, location: @shop }
    end
  end

end
