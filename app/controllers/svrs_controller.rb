class SvrsController < ApplicationController

  def index

    @page = params[:draw].nil? ? 1 : params[:draw].to_i
    limit = params[:length].nil? ? 10 : params[:length].to_i
    offset = params[:start].nil? ? 0 : params[:start].to_i
    search = params[:search].nil? ? '' : params[:search][:value]

    if current_user.user_employee?
      @posts = Post.with_user(current_user).limit(limit).offset(offset)
      @count = Post.with_user(current_user).length
    else
      @posts = Post.with_admin_user.limit(limit).offset(offset)
      @count = Post.with_admin_user.length
    end
    unless params[:order].nil?
      col_number = params[:order]["0"]["column"].to_i
      order_by_type  = params[:order]["0"]["dir"]

      attribute_name = get_sort_attribute_name(col_number)
      sorting_query = [attribute_name,order_by_type].join(' ')
      @posts = Post.sort_data(@posts, sorting_query)
    end
    @posts = Post.apply_search_filter(@posts, search).uniq

    respond_to do |format|
      format.html
      format.json
    end
  end

  def show
    authorize! :read, Post
    @shop = Shop.find(params[:shop_id])
    @post = Post.find(params[:id])
    comments = @post.comments
    @length = comments.length
    @comments = comments.last(10)
    @report = @post.reports.first
    @reports = @post.reports
    @display_report  = @reports.where(:report_type => "display").collect(&:report_lines).flatten
    @sales_report   = @reports.where(:report_type => "sales").collect(&:report_lines).flatten
    @corner_report  = @reports.where(:report_type => "display_corner").collect(&:report_lines).flatten

    @brand_report_lines = @corner_report.group_by {|d| d[:brand_id] }
    @category_report_lines = @corner_report.group_by {|d| d[:product_category_id] }
    @report_lines_avatars = @corner_report.collect(&:avatars).flatten
    @category = @post.product_category
    @brands = @category.brands
    @post_uploads  = @post.uploads.flatten.sort {|a,b| b[:created_at] <=> a[:created_at]}
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
      @post = Post.new :shop_id => @shop.id, :dealer_id => @shop.dealer.id, :product_category_id => @category.id, :user_id => current_user.id, :task_id => params[:task_id].to_i, :status => "draft"
    else
      @post = Post.new :shop_id => @shop.id, :dealer_id => @shop.dealer.id, :product_category_id => @category.id, :user_id => current_user.id, :status => "draft"
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
    if current_user.user_employee?
      unless @post.user_id == current_user.id
        redirect_to :back, notice: 'access denied to edit this report'
      end
    end
  end

  def create
    @shop = Shop.find params[:shop_id]
    @post = Post.new params[:post]
    if @post.save
      @post.create_activity :create, owner: current_user
      redirect_to "/shops/#{@shop.id}/svr/#{@post.id}"
    else
      render 'new'
    end
  end

  def update
    @post = Post.find params[:id]
    @shop = Shop.find params[:shop_id]
    if @post.update_attributes(params[:post])
      @post.create_activity :update, owner: current_user
      redirect_to "/shops/#{@shop.id}/svr/#{@post.id}"
    else
      render 'edit'
    end
  end

  def destroy
    @post = Post.find params[:id]
    @shop = Shop.find params[:shop_id]
    if current_user.user_employee?
      unless @post.user_id == current_user.id
        redirect_to :back, notice: 'access denied to edit this report'
      else
        @post.destroy
        redirect_to shop_svrs_path(@shop)
      end
    else
      @post.destroy
      redirect_to shop_svrs_path(@shop)
    end
  end

  def delete
    @post = Post.find params[:id]
    @shop = Shop.find params[:shop_id]
    if current_user.user_employee?
      unless @post.user_id == current_user.id
        redirect_to :back, notice: 'access denied to edit this report'
      else
        @post.destroy
        redirect_to :back, notice: 'SVR successfuly deleted'
      end
    else
      @post.destroy
      redirect_to :back, notice: 'SVR successfuly deleted'
    end
  end

  def brand_search
    if params[:shop_id].blank?
      @posts = Post.published_reports
    else
      @posts = Post.published_reports.where(:shop_id => params[:shop_id].to_i)
    end
    unless params[:search][:product].blank?
      if params[:search][:product].size > 0
        product = params[:search][:product].reject{|p| p.blank?}.map{|p| p.to_s}
        @parent = Product.all.select{|a| product.include?(a[:name])}
        @pc = ProductCategory.all.select{|a| product.include?(a[:name])}
        @reports = @posts.collect(&:reports).flatten.collect(&:report_lines).flatten.select{|a| @parent.include?(a.product)}.collect(&:report).uniq
        @reports = @reports + @posts.collect(&:reports).flatten.collect(&:report_lines).flatten.select{|a| @pc.include?(a.product_category)}.collect(&:report).uniq
      end
    else
      @reports = @posts.collect(&:reports).flatten
    end
    if !params[:search][:week].blank? and params[:search][:week].size > 1
      week = params[:search][:week].reject{|w| w.blank?}.map{|w| w.to_i}
      @reports = @reports.select{|r| week.include?(r[:week])}
    end
    if !params[:search][:year].blank? and params[:search][:year].size > 1
      year = params[:search][:year].reject{|y| y.blank?}.map{|y| y.to_i}
      @reports = @reports.select{|r| year.include?(r[:year])}
    end
    @categories = @reports.collect(&:report_lines).flatten.collect(&:product_category).uniq
    @brands = @categories.collect(&:brands).uniq.flatten

    render(:partial => "/svrs/brand_bar", :locals => {:brands => @brands, :reports => @reports, :type => params[:search][:type]})
  end

  def category_search
    if params[:shop_id].blank?
      @posts = Post.published_reports
    else
      @posts = Post.published_reports.where(:shop_id => params[:shop_id].to_i)
    end
    @reports = @posts.collect(&:reports).flatten
    if !params[:search][:week].blank? and params[:search][:week].size > 1
      week = params[:search][:week].reject{|w| w.blank?}.map{|w| w.to_i}
      @reports = @reports.select{|r| week.include?(r[:week])}
    end
    if !params[:search][:year].blank? and params[:search][:year].size > 0
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
      if params[:search][:brand].size > 0
        brand = params[:search][:brand].reject{|b| b.blank?}.map{|b| b.to_i}
      end
    end
    @categories = @posts.collect(&:product_category).uniq
    render(:partial => "/svrs/category_bar", :locals => {:categories => @categories, :reports => @reports, :type => params[:search][:type], :brand => brand })
  end

  def file_field
    render(:partial => "/svrs/reportline_avatars", :locals => {:index => params[:index], :temp => params[:length]})
  end

  def upload_field
    render(:partial => "/svrs/report_upload", :locals => {:temp => params[:length]})
  end

  def comments
    @shop = Shop.find(params[:shop_id])
    @post = Post.find(params[:id])
    comments = @post.comments
    @length = comments.length
    @comments = comments.last(10)
  end

  def create_comment
    @post = Post.find(params[:id])
    comment = @post.comments.build(params[:comment])
    comment.user_id = current_user.id
    if comment.save
      flash[:notice] = "Successfully comment created"
    else
      flash[:warning] = "Failed comment creation"
    end
    redirect_to :back
  end

  def view_more_comments
    @shop = Shop.find(params[:shop_id])
    @post = Post.find(params[:id])
    @comments = @post.comments
    respond_to do |format|
      format.js
    end
  end

  private

  def get_sort_attribute_name(column_number)

    case column_number
    when 0
      return "posts.id"
    when 1
      return "shops.dealer_name"
    when 2
      return "product_categories.name"
    when 3
      return "cities.name"
    when 4
      return "reports.week"
    when 5
      return "posts.created_at"
    when 6
      return "users.first_name"
    else
      return "posts.created_at"
    end

  end

end
