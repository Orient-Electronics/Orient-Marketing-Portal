class ReportsController < ApplicationController

  def index
    @shop = Shop.find params[:shop_id]
    @reports = @shop.reports
  end

  def new
    @shop = Shop.find params[:shop_id]
    @report = Report.new
    @products = []
    @brands = []
    count = 0
    Product.all.each do |product|
      @products[count] = product
      product.brands.each do |brand|
        @report.report_lines.build(:product_id => product.id,:brand_id => brand.id)
        @brands[count] = brand
        count = count + 1
      end
    end
  end

  def create
    @shop = Shop.find params[:shop_id]
    @report = Report.new params[:report]
    @report.representative = current_representative
    @report.shop_id = params[:shop_id]
    respond_to do |format|
      if @report.save
        format.html { redirect_to @shop, notice: 'Report was successfully submitted.' }
        format.json { render json: @shop, status: :created, location: @shop }
      else
        format.html { render action: "new" }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

end
