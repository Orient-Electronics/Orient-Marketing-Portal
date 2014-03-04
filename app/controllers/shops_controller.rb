class ShopsController < ApplicationController
  # GET /shops
  # GET /shops.json
  def index
    if params[:dealer_id].present?
      @parent = Dealer.find params[:dealer_id]
      @shops = @parent.shops
    else
      if params[:shop_category_id].present?
        @parent = ShopCategory.find params[:shop_category_id]
        @shops = @parent.shops
      else
        if params[:city_id].present?
          @parent = City.find params[:city_id]
          @shops = @parent.locations.collect(&:shop).flatten.reject {|r| r.nil? }
        else
          if current_user.user_type.name == "employee"  
             @shops = current_user.get_assigned_shops
          else
             @shops = Shop.all 
          end
        end
      end  
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @shops }
    end
  end

  # GET /shops/1
  # GET /shops/1.json
  def show
    authorize! :read, Shop
    @product_categories = ProductCategory.all
    @posts =  Post.published_reports.where(:shop_id => params[:id])
    @reports = @posts.collect(&:reports).flatten
    shop_report_lines = @reports.select{|a| a.report_type == "display_corner"}.collect(&:report_lines).flatten
    @brand_report_lines = shop_report_lines.group_by {|d| d[:brand_id] }
    @category_report_lines = shop_report_lines.group_by {|d| d[:product_category_id] }
    @report_lines_avatars = shop_report_lines.collect(&:avatars).flatten
    shop_upload = (Shop.find(params[:id]).uploads)
    @shop_uploads = (shop_upload + @report_lines_avatars).flatten.sort {|a,b| b[:created_at] <=> a[:created_at]}
    if current_user.user_type.name == "employee"
      shops = current_user.get_assigned_shops.collect(&:id)
      reports = current_user.posts.where(:shop_id => Shop.find(params[:id])).collect(&:reports).flatten
      @display_report = reports.select{|a| a.report_type == "display"}.collect(&:report_lines).flatten
      @sales_report   = reports.select{|a| a.report_type == "sales"}.collect(&:report_lines).flatten
      @corner_report  = reports.select{|a| a.report_type == "display_corner"}.collect(&:report_lines).flatten
      @brands = Brand.all
      @categories = ProductCategory.all
      if shops.include?(params[:id].to_i) 
        @shop = Shop.find(params[:id])
      else
        respond_to do |format|
          format.html {redirect_to '/shops'} 
        end
      end   
    else 
      @shop = Shop.find(params[:id])     
        
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @shop }
      end  
    end
  end

  # GET /shops/new
  # GET /shops/new.json
  def new
    authorize! :create, Shop
    @shop = Shop.new
    @shop.build_owner
    @shop.build_manager
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
    @shop = Shop.find(params[:id])
  end

  # POST /shops
  # POST /shops.json
  def create
    @shop = Shop.new(params[:shop])
    @shop.build_avatar params[:shop][:avatar_attributes ]
    respond_to do |format|
      if @shop.save
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
    @shop = Shop.find(params[:id])

    respond_to do |format|
      if @shop.update_attributes(params[:shop])
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

    respond_to do |format|
      format.html { redirect_to shops_url }
      format.json { head :no_content }
    end
  end
  
end