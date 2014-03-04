class DealersController < ApplicationController
  # GET /dealers
  # GET /dealers.json
  def index
    authorize! :read, Dealer
    @dealers = Dealer.all
    @shops = Shop.all
    @post = Post.published_reports
    @reports = @post.collect(&:reports).flatten
    @brands = Brand.all
    @categories= ProductCategory.all
    @shop = @dealers.collect(&:shops).flatten
    uploads = @shop.collect(&:uploads).flatten
    avatars = @shop.collect(&:reports).flatten.collect(&:report_lines).flatten.collect(&:avatars).flatten
    @uploads = (uploads + avatars).flatten.sort {|a,b| b[:created_at] <=> a[:created_at]}
    @shop_categories = ShopCategory.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @dealers }
    end
  end

  # GET /dealers/1
  # GET /dealers/1.json
  def show
    authorize! :read, Dealer
    @parent = Dealer.find params[:id]
    @shops = @parent.shops.flatten
    @posts = @shops.collect(&:posts).flatten.select{|a| a.published == true }
    uploads = @shops.collect(&:uploads).flatten
    avatars = @posts.collect(&:reports).flatten.collect(&:report_lines).flatten.collect(&:avatars).flatten
    @uploads = (uploads + avatars).flatten.sort {|a,b| b[:created_at] <=> a[:created_at]}
    @shop_categories = ShopCategory.all
    respond_to do |format|
      format.html # show.html.erb
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
    
    @shop = Shop.find(params[:id])
    params[:type]=="owner" ? @parent=@shop.owner : @parent=@shop.manager
    render :partial =>"/dealers/show_modal" , :locals => {:person => @parent, :shop => @shop}
  end

  def get_info
    @shop =  Shop.find(params[:id])
    
    render :partial =>"/dealers/get_info" , :locals => {:@shop => @shop}
  end  
end