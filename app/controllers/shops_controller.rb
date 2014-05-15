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
          @shops = Shop.all 
        end
      end  
    end
    @shop_categories = ShopCategory.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @shops }
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
    @posts =  Post.published_reports.where(:shop_id => params[:id].to_i)
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
        format.html # show.html.erb
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

  def area_field
    @city = City.find(params[:id])
    @areas = @city.areas
    render(:partial => "shops/get_area_field", :locals => {:@area => @area })
  end
  
end