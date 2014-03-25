class ReportsController < ApplicationController

  def index
    authorize! :read, Post
    @categories = ProductCategory.all
    unless params[:shop_id].blank?
      @parent = Shop.find params[:shop_id]
      @brands = Brand.all
      if current_user.user_type.name == "employee"
        @posts =  Post.where(:shop_id => params[:shop_id].to_i, :user_id => current_user.id)
        @reports = @posts.collect(&:reports).flatten
      else   
        @posts =  Post.where(:shop_id => params[:shop_id].to_i)
        @reports = @posts.collect(&:reports).flatten
      end
    else
      @posts =  Post.where(:user_id => current_user.id)
      @reports = @posts.collect(&:reports).flatten
    end  
  end

  def show
    authorize! :read, Post
    @shop = Shop.find(params[:shop_id])
    @post = Post.find(params[:id])
    @report = @post.reports.first
    @reports = @post.reports
    @display_report  = @reports.where(:report_type => "display").collect(&:report_lines).flatten
    @sales_report   = @reports.where(:report_type => "sales").collect(&:report_lines).flatten
    @corner_report  = @reports.where(:report_type => "display_corner").collect(&:report_lines).flatten
    @brand_report_lines = @corner_report.group_by {|d| d[:brand_id] }
    @category_report_lines = @corner_report.group_by {|d| d[:product_category_id] }
    @report_lines_avatars = @corner_report.collect(&:avatars).flatten
    @brands = Brand.all
    @categories = ProductCategory.all
  end

  def new
    authorize! :create, Post
    @shop = Shop.find params[:shop_id]
    @category = ProductCategory.find params[:product_category_id]
    if !params[:product_id].blank?
      @product = Product.find params[:product_id]
      @brands = @product.brands
    else
      @brands = @category.brands
    end
    unless params[:task_id].blank?
      @post = Post.new :shop_id => @shop.id, :dealer_id => @shop.dealer.id, :product_category_id => @category.id, :user_id => current_user.id, :task_id => params[:task_id].to_i
    else
      @post = Post.new :shop_id => @shop.id, :dealer_id => @shop.dealer.id, :product_category_id => @category.id, :user_id => current_user.id
    end
    report_one = @post.reports.build :shop_id => @shop.id, :report_type => 'display', :user_id => current_user.id
    @brands.each do |brand|
      report_one.report_lines.build :brand_id => brand.id, :product_category_id => @category.try(:id), :product_id => @product.try(:id)
    end
    report_two = @post.reports.build :shop_id => @shop.id, :report_type => 'sales', :user_id => current_user.id
    @brands.each do |brand|
      report_two.report_lines.build :brand_id => brand.id, :product_category_id => @category.try(:id), :product_id => @product.try(:id)
    end
    report_three = @post.reports.build :shop_id => @shop.id, :report_type => 'display_corner', :user_id => current_user.id
    @brands.each do |brand|
      line = report_three.report_lines.build :brand_id => brand.id, :product_category_id => @category.try(:id), :product_id => @product.try(:id)
    end
  end

  def edit
    authorize! :update, Post
    @post = Post.find params[:id]
    @shop = Shop.find params[:shop_id]
    unless !@post.published? 
      redirect_to shop_reports_path(@shop), notice: 'access denied to edit this report'
    end 
    
  end

  def create
    @shop = Shop.find params[:shop_id]
    @post = Post.new params[:post]
    if @post.save
      @post.create_activity :create, owner: current_user
      redirect_to shop_path(@shop)
    else
      render 'new'
    end
  end

  def update
    @post = Post.find params[:id]
    @shop = Shop.find params[:shop_id]
    if @post.update_attributes(params[:post])
      @post.create_activity :update, owner: current_user
      redirect_to shop_path(@shop)
    else
      render 'edit'
    end
  end   

  def destroy
    authorize! :delete, Post
    @post = Post.find params[:id]
    @shop = Shop.find params[:shop_id]
    unless !@post.published? 
      redirect_to shop_reports_path(@shop), notice: 'access denied to edit this report'
    end
    @post.destroy
      redirect_to shop_reports_path(@shop)
  end

  def brand_search
    unless params[:search][:product].blank?
      @parent = Product.find_by_name params[:search][:product]
      @pc = ProductCategory.find_by_name params[:search][:product] if @parent.blank?
      @reports = ReportLine.where(:product_id=> @parent.id).collect(&:report).uniq unless @parent.blank?
      @reports = ReportLine.where(:product_category_id=> @pc.id).collect(&:report).uniq if @parent.blank?
    else
      @reports = Report.all
    end
    if !params[:search][:week].blank? and params[:search][:week].size > 1
      week = params[:search][:week].reject{|w| w.blank?}.map{|w| w.to_i}
      @reports = @reports.select{|r| week.include?(r[:week])}
    end
    if !params[:search][:year].blank? and params[:search][:year].size > 1
      year = params[:search][:year].reject{|y| y.blank?}.map{|y| y.to_i}
      @reports = @reports.select{|r| year.include?(r[:year])}
    end
    unless params[:shop_id].blank?
      @reports = @reports.select{|r| r.shop_id==params[:shop_id].to_i}.flatten
    end
    @brands = Brand.all
    render(:partial => "/reports/bar", :locals => {:brands => @brands, :reports => @reports, :type => params[:search][:type]})
  end

  def category_search
    @reports = Report.all
    if !params[:search][:week].blank? and params[:search][:week].size > 1
      week = params[:search][:week].reject{|w| w.blank?}.map{|w| w.to_i}
      @reports = @reports.select{|r| week.include?(r[:week])}
    end
    if !params[:search][:year].blank? and params[:search][:year].size > 1
      year = params[:search][:year].reject{|y| y.blank?}.map{|y| y.to_i}
      @reports = @reports.select{|r| year.include?(r[:year])}
    end
    unless params[:shop_id].blank?
      @reports = @reports.select{|r| r.shop_id==params[:shop_id].to_i}.flatten
    end
    unless params[:dealer_id].blank?
      dealer = Dealer.find params[:dealer_id].to_i
      shops = dealer.shops.collect(&:id).flatten
      @reports = @reports.select{|r| shops.include?(r.shop_id)}.flatten
    end
    unless params[:search][:brand].blank?
      @parent = Brand.find params[:search][:brand]
    end
    brand = nil
    brand = @parent.id unless @parent.blank?
    @categories = ProductCategory.all
    render(:partial => "/reports/category_bar", :locals => {:categories => @categories, :reports => @reports, :type => params[:search][:type], :brand => brand })
  end

  def file_field
    render(:partial => "/reports/reportline_avatars", :locals => {:index => params[:index], :temp => params[:length]})
  end

  def remove_report_line
    report_line = ReportLine.find params[:id]
    report_line.avatars.clear
      render :text => "Successfully Removed"   
  end

end
  