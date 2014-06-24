class ShopsController < ApplicationController
  

  def index
    page = params[:draw].nil? ? 1 : params[:draw].to_i
    limit = params[:length].to_i
    offset = params[:start].to_i
    
    
    if params[:filter].present?
      search = Sunspot.search (Shop) do
        with(:city_id, params[:filter][:city_id]) if params[:filter][:city_id].present?
        with(:area_id, params[:filter][:area_id]) if params[:filter][:area_id].present?
        with(:shop_category_id, params[:filter][:shop_category_id]) if params[:filter][:shop_category_id].present?
      end
      
      @shops = search.results
      shop_ids = @shops.collect(&:id)
      @posts = Post.shop_posts(shop_ids)
      
      from = params[:filter][:from].present? ? ((params[:filter][:from]).to_date).to_time : Post.first.created_at.to_date.to_time
      to  = params[:filter][:to].present? ? ((params[:filter][:to]).to_date).to_time : Date.today.to_date.to_time
      @posts = @posts.flatten.select{|a| a.created_at >= from and a.created_at <= to }.flatten
    else
      @shops = Shop.all
      shop_ids = @shops.collect(&:id)
      @shop_results = Shop.offset(offset).limit(limit)
      @shop_categories = ShopCategory.all
      @posts = Post.shop_posts(shop_ids)
    end

    if @posts.present?
      post_ids = @posts.collect(&:id)
      @reports = Report.post_reports(post_ids).flatten
      report_ids = @reports.collect(&:id)
      corner_reports = Report.corner_reports(report_ids)
      @corner_reports = ReportLine.report_lines(corner_reports.collect(&:id)).flatten
      @corner_brand_report_lines = @corner_reports.group_by {|d| d[:brand_id] }
      @corner_category_report_lines = @corner_reports.group_by {|d| d[:product_category_id] }
      @categories= @posts.collect(&:product_category).uniq
      @brands = @categories.collect(&:brands).uniq.flatten
      post_uploads =  Upload.post_uploads(post_ids).flatten
      report_lines = ReportLine.report_lines(report_ids)
      report_lines_ids = report_lines.collect(&:id)
      avatars = Avatar.report_line_avatars(report_lines_ids)
      uploads = Upload.shop_uploads(shop_ids).flatten    
      @uploads = (post_uploads + uploads + avatars).flatten.sort {|a,b| b[:created_at] <=> a[:created_at]}
    else  
      @uploads = Upload.shop_uploads(shop_ids).flatten.sort {|a,b| b[:created_at] <=> a[:created_at]}
    end
    
    @peoples = Kaminari.paginate_array(@shops.collect(&:peoples).flatten.reject{|a| a.blank?}).page(1).per(5)
    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.json do
        return render :json =>  {draw: page,  recordsTotal: Shop.count,  recordsFiltered: Shop.count , :data => @shop_results.collect{|a| ["<a src=#{shop_path(a)}>#{a.dealer_name}</a>", a.orient_dealer ? "<span class='label label-satgreen'>Dealer</span>".html_safe : "<span class='label label-lightred'>Non Dealer</span>".html_safe, "<a src=#{edit_shop_path(a)} class='btn'><i class='fa fa-edit' title ='edit'></i></a> <a src=#{delete_shop_path(a)} class='btn'><i class='hi hi-off' title='delete' data-confirm='are you sure?'></i></a>"]} }
      end
    end
  end

  def load_more_peoples
    if params[:filter].present?
      search = Sunspot.search (Shop) do
        with(:city_id, params[:filter][:city_id]) if params[:filter][:city_id].present?
        with(:area_id, params[:filter][:area_id]) if params[:filter][:area_id].present?
        with(:shop_category_id, params[:filter][:shop_category_id]) if params[:filter][:shop_category_id].present?
      end
      @shops = search.results
    else
     @shops = Shop.all 
    end
    unless @shops.blank?
      params[:page] = params[:page].blank? ? 1 : params[:page]
      @peoples = Kaminari.paginate_array(@shops.collect(&:peoples).flatten.reject{|a| a.blank?}).page(params[:page]).per(5)
    else
      @peoples = []
    end  
    render :partial => '/shops/more_peoples', :layout => false
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
  
end