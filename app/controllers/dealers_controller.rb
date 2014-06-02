class DealersController < ApplicationController
  # GET /dealers
  # GET /dealers.json
  def index
    authorize! :read, Dealer
    @dealers = Dealer.all
    @shops = Shop.all
    if params[:filter].present?
      if (params[:filter][:to].present?) and (params[:filter][:from].present?)
        to  = ((params[:filter][:to]).to_date).to_time
        from = ((params[:filter][:from]).to_date).to_time
        @posts = Post.published_reports.flatten.select{|a| a.created_at >= from and a.created_at <= to }.flatten
      else
        @posts = Post.published_reports  
      end
    else 
      @posts = Post.published_reports
    end
    @peoples = @shops.collect(&:peoples).flatten.reject{|a| a.blank?}
    @reports = @posts.collect(&:reports).flatten
    @corner_reports = @reports.select{|a| a.report_type == "display_corner"}.collect(&:report_lines).flatten
    @corner_brand_report_lines = @corner_reports.group_by {|d| d[:brand_id] }
    @corner_category_report_lines = @corner_reports.group_by {|d| d[:product_category_id] }
    @categories= @posts.collect(&:product_category).uniq
    @brands = @categories.collect(&:brands).uniq.flatten
    @shop = @dealers.collect(&:shops).flatten
    uploads = @shop.collect(&:uploads).flatten
    avatars = @reports.flatten.collect(&:report_lines).flatten.collect(&:avatars).flatten
    @uploads = (uploads + avatars).flatten.sort {|a,b| b[:created_at] <=> a[:created_at]}
    @shop_categories = ShopCategory.all
    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.json { render json: @dealers }
    end  
  end

  # GET /dealers/1
  # GET /dealers/1.json
  def show
    authorize! :read, Dealer
    @parent = Dealer.where(id: params[:id]).first

    if params[:filter].present?
      search = Sunspot.search (Shop) do
        with(:dealer_id, params[:id])
        with(:city_id, params[:filter][:city_id]) if params[:filter][:city_id].present?
        with(:area_id, params[:filter][:area_id]) if params[:filter][:area_id].present?
        with(:shop_category_id, params[:filter][:shop_category_id]) if params[:filter][:shop_category_id].present?
      end
      @shops = search.results
      @posts = @shops.collect(&:posts).flatten.select{|a| a.published == true }
      if (params[:filter][:to].present?) and (params[:filter][:from].present?)
        to  = ((params[:filter][:to]).to_date).to_time
        from = ((params[:filter][:from]).to_date).to_time
        @posts = @posts.flatten.select{|a| a.created_at >= from and a.created_at <= to }.flatten
      end
    else
      @shops = @parent.shops.flatten

      @posts = @shops.collect(&:posts).flatten.select{|a| a.published == true }
    end

    @peoples = @shops.collect(&:peoples).flatten.reject{|a| a.blank?}
    if @posts.present?
      @reports = @posts.collect(&:reports).flatten
      @corner_reports = @reports.select{|a| a.report_type == "display_corner"}.collect(&:report_lines).flatten
      @corner_brand_report_lines = @corner_reports.group_by {|d| d[:brand_id] }
      @corner_category_report_lines = @corner_reports.group_by {|d| d[:product_category_id] }
      @categories= @posts.collect(&:product_category).uniq
      @brands = @categories.collect(&:brands).uniq.flatten
      post_uploads = @posts.collect(&:uploads).flatten
      avatars = @posts.collect(&:reports).flatten.collect(&:report_lines).flatten.collect(&:avatars).flatten
      uploads = @shops.collect(&:uploads).flatten    
      @uploads = (post_uploads + uploads + avatars).flatten.sort {|a,b| b[:created_at] <=> a[:created_at]}
    else  
      @uploads = @shops.collect(&:uploads).flatten.sort {|a,b| b[:created_at] <=> a[:created_at]}
    end
    
    @shop_categories = ShopCategory.all
    respond_to do |format|
      format.html # show.html.erb
      format.js
      format.json { render json: @dealer }
    end
  end

  # GET /dealers/new
  # GET /dealers/new.json
  def new
    authorize! :create, Dealer
    @dealer = Dealer.new
    @dealer.build_avatar

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @dealer}
    end
  end

  # GET /dealers/1/edit
  def edit
    authorize! :update, Dealer
    @dealer = Dealer.find(params[:id])
    @dealer.build_avatar

  end

  # POST /dealers
  # POST /dealers.json
  def create
    @dealer = Dealer.new(params[:dealer])
    @dealer.build_avatar params[:dealer][:avatar_attributes]
    respond_to do |format|
      if @dealer.save
        @dealer.create_activity :create, owner: current_user
        format.html { redirect_to @dealer, notice: 'Dealer was successfully created.' }
        format.json { render json: @dealer, status: :created, location: @dealer }
      else
        format.html { render action: "new" }
        format.json { render json: @dealer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /dealers/1
  # PUT /dealers/1.json
  def update
    @dealer = Dealer.find(params[:id])
    @dealer.build_avatar params[:dealer][:avatar_attributes]
    respond_to do |format|
      if @dealer.update_attributes(params[:dealer])
        @dealer.create_activity :update, owner: current_user
        format.html { redirect_to @dealer, notice: 'Dealer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @dealer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dealers/1
  # DELETE /dealers/1.json
  def destroy
    authorize! :destroy, Dealer
    @dealer = Dealer.find(params[:id])
    @dealer.create_activity :destroy, owner: current_user
    @dealer.destroy

    respond_to do |format|
      format.html { redirect_to dealers_url }
      format.json { head :no_content }
    end
  end

  def gallery
    @dealer = Dealer.find(params[:id])
    @shop = @dealer.shops.flatten
    uploads = @shop.collect(&:uploads).flatten
    avatars = @shop.collect(&:reports).flatten.collect(&:report_lines).flatten.collect(&:avatars).flatten
    @uploads = (uploads + avatars).flatten.sort {|a,b| b[:created_at] <=> a[:created_at]}
  end


  def showgallery
    @dealers = Dealer.all
    @shop = @dealers.collect(&:shops).flatten
    uploads = @shop.collect(&:uploads).flatten
    avatars = @shop.collect(&:reports).flatten.collect(&:report_lines).flatten.collect(&:avatars).flatten
    @uploads = (uploads + avatars).flatten.sort {|a,b| b[:created_at] <=> a[:created_at]}
  end

  def showmodal
    
    @people = People.find(params[:id])
    render :partial =>"/dealers/show_modal" , :locals => {:person => @people}
  end

  def get_info
    @shop =  Shop.find(params[:id])
    
    render :partial =>"/dealers/get_info" , :locals => {:@shop => @shop}
  end  
end