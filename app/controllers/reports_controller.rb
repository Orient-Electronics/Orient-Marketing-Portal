class ReportsController < ApplicationController

  def index
    authorize! :read, Report
    @categories = ProductCategory.all
    if params[:shop_id].present?
      @parent = Shop.find params[:shop_id]
      @reports = @shop.reports
    else
      if params[:product_id].present?
        @parent = Product.find params[:product_id]
        @brands = Brand.all
        @reports = ReportLine.where(:product_id=> params[:product_id]).collect(&:report).uniq
      else
        if params[:product_category_id].present?
          @parent = ProductCategory.find params[:product_category_id]
          @brands = Brand.all
          @reports = ReportLine.where(:product_category_id=> params[:product_category_id]).collect(&:report).uniq
        else
          @reports = Report.all
          @brands = Brand.all
        end
      end
    end
  end

  def new
    authorize! :create, Report
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
    params[:report].collect do |key,report|
      @report = Report.new report
      @report.week = params[:week]
      @report.user = current_user
      @report.shop_id = params[:shop_id]
      @report.save

    end
    respond_to do |format|
        format.html {redirect_to root_url}
        format.json { render json: @shop, status: :created, location: @shop }
    end
  end

  def brand_search
    unless params[:search][:product].blank?
      @parent = Product.find_by_name params[:search][:product]
      @parent = ProductCategory.find_by_name params[:search][:product] if @parent.blank?
      @reports = ReportLine.where(:product_id=> @parent.id).collect(&:report).uniq unless @parent.blank?
      @reports = ReportLine.where(:product_category_id=> @parent.id).collect(&:report).uniq if @parent.blank?
    else
      @reports = Report.all
    end
    if !params[:search][:week].blank? and params[:search][:week].size > 1
      week = params[:search][:week].reject{|w| w.blank?}.map{|w| w.to_i}
      @reports = @reports.select{|r| week.include?(r[:week])}
    end
    @brands = Brand.all
    render(:partial => "/reports/bar", :locals => {:brands => @brands, :reports => @reports, :type => params[:search][:type]})
  end

  def category_search
    unless params[:search][:brand].blank?
      @parent = Brand.find params[:search][:brand]
      @reports = ReportLine.where(:brand_id=> @parent.id).collect(&:report).uniq
    else
      @reports = Report.all
    end
    if !params[:search][:week].blank? and params[:search][:week].size > 1
      week = params[:search][:week].reject{|w| w.blank?}.map{|w| w.to_i}
      @reports = @reports.select{|r| week.include?(r[:week])}
    end
    @categories = ProductCategory.all
    render(:partial => "/reports/category_bar", :locals => {:categories => @categories, :reports => @reports, :type => params[:search][:type]})
  end

end
