class ReportsController < ApplicationController

  def new
    @shop = Shop.find params[:shop_id]
    @report = Report.new
  end

  def create
    @shop = Shop.find params[:shop_id]
    @report = Report.new params[:report]
    @report.representative = current_representative
    @report.shop_id = params[:shop_id]
    @report.data = params[:report][:data].to_json
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
