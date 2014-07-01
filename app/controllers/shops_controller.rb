class ShopsController < ApplicationController


  def index
    page = params[:page].nil? ? 1: params[:page]
    if params[:filter].present?
      search = Sunspot.search (Shop) do
        with(:city_id, params[:filter][:city_id]) if params[:filter][:city_id].present?
        with(:area_id, params[:filter][:area_id]) if params[:filter][:area_id].present?
        with(:shop_category_id, params[:filter][:shop_category_id]) if params[:filter][:shop_category_id].present?
      end
      from = params[:filter][:from].present? ? ((params[:filter][:from]).to_date).to_time : Post.first.created_at.to_date.to_time
      to = params[:filter][:to].present? ? ((params[:filter][:to]).to_date).to_time : Date.today.to_date.to_time

      @shops = search.results
      shop_ids = flatten_data(@shops, &:id)
      @limited_shops =  apply_array_pagination(@shops,params[:page])
      @shop_categories = flatten_data(@shops, &:shop_category)
      @peoples = apply_array_pagination(flatten_data(@shops, &:peoples), 1)
      @posts = Post.with_shops(shop_ids).where('created_at >= ? AND created_at <= ?',from, to)
      post_ids = flatten_data(@posts,&:id)
      @reports = Report.with_posts(post_ids)
      report_ids = flatten_data(@reports,&:id)

      @corner_reports  = apply_array_pagination(ReportLine.with_reports(report_ids), 1)
      @corner_brand_report_lines = @corner_reports.group_by {|d| d[:brand_id] }
      @corner_category_report_lines = @corner_reports.group_by {|d| d[:product_category_id]}
      @categories= flatten_data(@posts,&:product_category).uniq
      @brands = flatten_data(@categories,&:brands).uniq
      @uploads = apply_array_pagination((Upload.with_shops(shop_ids) + Upload.with_posts(post_ids)), 1)
    else
      @limited_shops = Shop.page(params[:page]).per(10)
      @shops = Shop.all
      @shop_categories = ShopCategory.all
      @posts = Post.published_reports
      @peoples = People.page(1).per(10)
      if @posts.present?
        @reports = flatten_data(@posts,&:reports)
        @corner_reports = apply_array_pagination(flatten_data(Report.with_corner_report_lines,&:report_lines).flatten,1)
        @corner_brand_report_lines = @corner_reports.group_by {|d| d[:brand_id] }
        @corner_category_report_lines = @corner_reports.group_by {|d| d[:product_category_id]}

        @categories= flatten_data(@posts,&:product_category).uniq
        @brands = flatten_data(@categories,&:brands).uniq
        @uploads = Upload.page(1).per(10)
      end
    end
    respond_to do |format|
      format.html
      format.js
      format.json
    end
  end

  def load_more_shops
    page = params[:page].nil? ? 1 : params[:page]
    if params[:filter].present?
      search = Sunspot.search (Shop) do
        keywords params[:dealer_name] do
          fields(:dealer_name)
        end
        with(:city_id, params[:filter][:city_id]) if params[:filter][:city_id].present?
        with(:area_id, params[:filter][:area_id]) if params[:filter][:area_id].present?
        with(:shop_category_id, params[:filter][:shop_category_id]) if params[:filter][:shop_category_id].present?
      end
      @limited_shops = apply_array_pagination(search.results,params[:page])
    else
      unless params[:dealer_name].blank?
        search = Sunspot.search (Shop) do
          keywords params[:dealer_name] do
            fields(:dealer_name)
          end
        end
        @limited_shops = apply_array_pagination(search.results,page)
      else
        @limited_shops = Shop.page(page).per(10)
      end
    end
    respond_to do |format|
      format.js
    end
  end

  def load_more_peoples
    @peoples = load_filter_peoples
    render :partial => '/shops/more_peoples', :layout => false
  end

  def load_more_brand_corner_report_lines
    @corner_reports = load_filtered_corner_report_line
    @corner_brand_report_lines = @corner_reports.group_by {|d| d[:brand_id] }
    render :partial => '/shops/more_brand_corner_images'
  end

  def load_more_category_corner_report_lines
    @corner_reports = load_filtered_corner_report_line
    @corner_category_report_lines = @corner_reports.group_by {|d| d[:product_category_id]}
    render :partial => '/shops/more_category_corner_images'
  end

  def load_more_uploads
    @uploads = load_filter_uploads
    render :partial => '/shops/load_more_upload_images'
  end


  def load_filtered_corner_report_line
    params[:page] = params[:page].blank? ? 1 : params[:page]
    if params[:filter].present?
      search = Sunspot.search (Shop) do
        with(:city_id, params[:filter][:city_id]) if params[:filter][:city_id].present?
        with(:area_id, params[:filter][:area_id]) if params[:filter][:area_id].present?
        with(:shop_category_id, params[:filter][:shop_category_id]) if params[:filter][:shop_category_id].present?
      end
      from = params[:filter][:from].present? ? ((params[:filter][:from]).to_date).to_time : Post.first.created_at.to_date.to_time
      to = params[:filter][:to].present? ? ((params[:filter][:to]).to_date).to_time : Date.today.to_date.to_time
      @shops = search.results
      shop_ids = flatten_data(@shops, &:id)
      @posts = Post.with_shops(shop_ids).where('created_at >= ? AND created_at <= ?',from, to)
      post_ids = flatten_data(@posts,&:id)
      @reports = Report.with_posts(post_ids)
      report_ids = flatten_data(@reports,&:id)
      @corner_reports  = apply_array_pagination(ReportLine.with_reports(report_ids), params[:page])
    else
      @corner_reports =  apply_array_pagination(flatten_data(Report.with_corner_report_lines,&:report_lines).flatten, params[:page])
    end
  end

  def load_filter_uploads
    params[:page] = params[:page].blank? ? 1 : params[:page]
    if params[:filter].present?
      search = Sunspot.search (Shop) do
        with(:city_id, params[:filter][:city_id]) if params[:filter][:city_id].present?
        with(:area_id, params[:filter][:area_id]) if params[:filter][:area_id].present?
        with(:shop_category_id, params[:filter][:shop_category_id]) if params[:filter][:shop_category_id].present?
      end
      from = params[:filter][:from].present? ? ((params[:filter][:from]).to_date).to_time : Post.first.created_at.to_date.to_time
      to = params[:filter][:to].present? ? ((params[:filter][:to]).to_date).to_time : Date.today.to_date.to_time
      @shops = search.results
      shop_ids = flatten_data(@shops, &:id)
      @posts = Post.with_shops(shop_ids).where('created_at >= ? AND created_at <= ?',from, to)
      post_ids = flatten_data(@posts,&:id)
      apply_array_pagination((Upload.with_shops(shop_ids) + Upload.with_posts(post_ids)), params[:page])
    else
      Upload.page(params[:page]).per(10)
    end
  end

  def load_filter_peoples
    params[:page] = params[:page].blank? ? 1 : params[:page]
    if params[:filter].present?
      search = Sunspot.search (Shop) do
        with(:city_id, params[:filter][:city_id]) if params[:filter][:city_id].present?
        with(:area_id, params[:filter][:area_id]) if params[:filter][:area_id].present?
        with(:shop_category_id, params[:filter][:shop_category_id]) if params[:filter][:shop_category_id].present?
      end
      from = params[:filter][:from].present? ? ((params[:filter][:from]).to_date).to_time : Post.first.created_at.to_date.to_time
      to = params[:filter][:to].present? ? ((params[:filter][:to]).to_date).to_time : Date.today.to_date.to_time
      @shops = search.results
      apply_array_pagination(flatten_data(@shops, &:peoples), params[:page])
    else
      People.page(params[:page]).per(10)
    end
  end

  # GET /shops/1
  # GET /shops/1.json
  def show
    authorize! :read, Shop
    unless params[:dealer_id].blank?
      @dealer = Dealer.find(params[:dealer_id])
    end
    @product_categories = ProductCategory.all
    @shop = Shop.where(id: params[:id]).first

    if params[:filter].present?
      from = params[:filter][:from].present? ? ((params[:filter][:from]).to_date).to_time : Post.first.created_at.to_date.to_time
      to  = params[:filter][:to].present? ? ((params[:filter][:to]).to_date).to_time : Date.today.to_date.to_time
      @posts = @shop.posts.published_reports.flatten.select{|a| a.created_at >= from and a.created_at <= to }.flatten
    else
      @posts = @shop.posts.published_reports.flatten
    end


    @reports = @posts.collect(&:reports).flatten
    shop_report_lines = @reports.select{|a| a.report_type == "display_corner"}.collect(&:report_lines).flatten
    @brand_report_lines = shop_report_lines.group_by {|d| d[:brand_id] }
    @category_report_lines = shop_report_lines.group_by {|d| d[:product_category_id] }
    @report_lines_avatars = shop_report_lines.collect(&:avatars).flatten
    shop_upload = (Shop.find(params[:id]).uploads)
    @shop_uploads = (shop_upload + @report_lines_avatars).flatten.sort {|a,b| b[:created_at] <=> a[:created_at]}
    if current_user.user_type.name == "employee"
      reports = Post.published_reports.where(:shop_id => params[:id].to_i, :user_id => current_user.id).collect(&:reports).flatten
      @display_report = reports.select{|a| a.report_type == "display"}.collect(&:report_lines).flatten
      @sales_report   = reports.select{|a| a.report_type == "sales"}.collect(&:report_lines).flatten
      @corner_report  = reports.select{|a| a.report_type == "display_corner"}.collect(&:report_lines).flatten
      @categories = @posts.collect(&:product_category).uniq
      @brands = @categories.collect(&:brands).uniq.flatten
      @posts =  Post.where(:shop_id => params[:id].to_i, :user_id => current_user.id).sort_by{ |a| a.published ? 1 : 0 }
      @shop = Shop.find(params[:id])
    else
      @posts =  Post.where(:shop_id => params[:id].to_i).sort_by{ |a| a.published ? 1 : 0 }
      @shop = Shop.find(params[:id])
      @categories = @posts.collect(&:product_category).uniq
      @brands = @categories.collect(&:brands).uniq.flatten
      respond_to do |format|
        format.html # index.html.erb
        format.js
        format.json { render json: @shop }
      end
    end
  end

  # GET /shops/new
  # GET /shops/new.json
  def new
    authorize! :create, Shop
    unless params[:dealer_id].blank?
      @dealer = Dealer.find(params[:dealer_id])
      @shop = @dealer.shops.build
    else
      @shop = Shop.new
    end
    @shop.build_location
    @shop.build_avatar


    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @shop }
    end
  end

  # GET /shops/1/edit
  def edit
    authorize! :update, Shop
    unless params[:dealer_id].blank?
      @dealer = Dealer.find(params[:dealer_id])
      @shop = @dealer.shops.find(params[:id])
    else
      @shop = Shop.find(params[:id])
    end
  end

  # POST /shops
  # POST /shops.json
  def create
    unless params[:dealer_id].blank?
      @dealer = Dealer.find(params[:dealer_id])
      @shop = @dealer.shops.build(params[:shop])
    else
      @shop = Shop.new(params[:shop])
    end
    @shop.build_avatar params[:shop][:avatar_attributes ]
    respond_to do |format|
      if @shop.save
        @shop.create_activity :create, owner: current_user
        format.html { redirect_to @shop, notice: 'Shop was successfully created.' }
        format.json { render json: @shop, status: :created, location: @shop }
      else
        flash.now[:error] = "Could not save Shop"
        format.html { render action: "new" }
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /shops/1
  # PUT /shops/1.json
  def update
    unless params[:dealer_id].blank?
      @dealer = Dealer.find(params[:dealer_id])
      @shop = @dealer.shops.find(params[:id])
    else
      @shop = Shop.find(params[:id])
    end
    respond_to do |format|
      if @shop.update_attributes(params[:shop])
        @shop.create_activity :update, owner: current_user
        format.html { redirect_to @shop, notice: 'Shop was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shops/1
  # DELETE /shops/1.json
  def destroy
    authorize! :destroy, Shop
    @shop = Shop.find(params[:id])
    @shop.destroy
    @dealer.create_activity :destroy, owner: current_user
    respond_to do |format|
      format.html { redirect_to shops_url }
      format.json { head :no_content }
    end
  end

  def delete
    authorize! :destroy, Shop
    @shop = Shop.find(params[:id])
    @shop.destroy
    @dealer.create_activity :destroy, owner: current_user
    respond_to do |format|
      format.html { redirect_to shops_url }
      format.json { head :no_content }
    end
  end

  def area_field
    @city = City.find(params[:id])
    @areas = @city.areas
    render(:partial => "shops/get_area_field", :locals => {:@area => @area })
  end

  def people_field
    render(:partial => "shops/get_people_field", :locals => {:index => params[:index]})
  end

  private

  def flatten_data(data,&block)
    data.collect(&block).flatten
  end

  def apply_array_pagination (data, page)
    Kaminari.paginate_array(data).page(page).per(10)
  end

end
