class DealersController < ApplicationController
  # GET /dealers
  # GET /dealers.json
  def index
    authorize! :read, Dealer
    page = params[:page].nil? ? 1: params[:page]

    @shops = Shop.all
    if params[:filter].present?
      from = params[:filter][:from].present? ? ((params[:filter][:from]).to_date).to_time : Post.first.created_at.to_date.to_time
      to  = params[:filter][:to].present? ? ((params[:filter][:to]).to_date).to_time : Date.today.to_date.to_time
      @posts = Post.published_reports.where('created_at >= ? AND created_at <= ?',from, to).flatten
    else
      @posts = Post.published_reports.flatten
    end
    @dealers =  Dealer.page(params[:page]).per(10)
    @peoples = People.page(1).per(10)
    @reports = flatten_data(@posts,&:reports)
    @corner_reports = apply_array_pagination(flatten_data(Report.with_corner_report_lines,&:report_lines).flatten,1)
    @corner_brand_report_lines = @corner_reports.group_by {|d| d[:brand_id] }
    @corner_category_report_lines = @corner_reports.group_by {|d| d[:product_category_id] }
    @categories= flatten_data(@posts,&:product_category).uniq

    @brands = flatten_data(@categories,&:brands).uniq
    @uploads = Upload.page(1).per(10)
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
    page = params[:page].nil? ? 1: params[:page]
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
      from = params[:filter][:from].present? ? ((params[:filter][:from]).to_date).to_time : Post.first.created_at.to_date.to_time
      to  = params[:filter][:to].present? ? ((params[:filter][:to]).to_date).to_time : Date.today.to_date.to_time
      @posts = @posts.flatten.select{|a| a.created_at >= from and a.created_at <= to }.flatten
    else
      @shops = apply_array_pagination(@parent.shops,params[:page])
      @posts = @shops.collect(&:posts).flatten.select{|a| a.published == true }
    end
    @peoples = apply_array_pagination(flatten_data(@shops, &:peoples), 1)
    shop_ids = flatten_data(@shops, &:id)
    post_ids = flatten_data(@posts,&:id)
    @shop_categories = ShopCategory.all
    if @posts.present?
      @reports = Report.with_posts(post_ids)
      report_ids = flatten_data(@reports,&:id)
      @corner_reports  = apply_array_pagination(ReportLine.with_reports(report_ids), 1)
      @corner_brand_report_lines = @corner_reports.group_by {|d| d[:brand_id] }
      @corner_category_report_lines = @corner_reports.group_by {|d| d[:product_category_id]}
      @categories= flatten_data(@posts,&:product_category).uniq
      @brands = flatten_data(@categories,&:brands).uniq
      @uploads = apply_array_pagination((Upload.with_shops(shop_ids) + Upload.with_posts(post_ids)), 1)
    else
      @uploads = apply_array_pagination(Upload.with_shops(shop_ids), 1)
    end

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

  def load_more_dealers
    authorize! :read, Dealer
    page = params[:page].nil? ? 1: params[:page]
    unless params[:name].blank?
      params[:name] = ["%",params[:name],"%"].join('')
      @dealers = apply_array_pagination(Dealer.where('name like ?', params[:name]),params[:page])
    else
      @dealers =  Dealer.page(params[:page]).per(10)
    end
    respond_to do |format|
      format.js
    end
  end

  def load_more_shops
    page = params[:page].nil? ? 1 : params[:page]
    if params[:filter].present?
      search = Sunspot.search (Shop) do
        with(:dealer_id, params[:id])
        keywords params[:dealer_name] do
          fields(:dealer_name)
        end
        with(:city_id, params[:filter][:city_id]) if params[:filter][:city_id].present?
        with(:area_id, params[:filter][:area_id]) if params[:filter][:area_id].present?
        with(:shop_category_id, params[:filter][:shop_category_id]) if params[:filter][:shop_category_id].present?
      end
      @shops = apply_array_pagination(search.results,params[:page])
    else
      unless params[:dealer_name].blank?
        search = Sunspot.search (Shop) do
          keywords params[:dealer_name] do
            fields(:dealer_name)
          end
          with(:dealer_id, params[:id])
        end
        @shops = apply_array_pagination(search.results,page)
      else
        @dealer = Dealer.where(id: params[:id]).first
        @shops = apply_array_pagination(@dealer.shops, params[:page])
      end
    end
    respond_to do |format|
      format.js
    end
  end

  def load_more_peoples
    params[:page] = params[:page].blank? ? 1 : params[:page]

    if params[:id].present?

      @parent = Dealer.where(id: params[:id]).first
      if params[:filter].present?
        search = Sunspot.search (Shop) do
          with(:dealer_id, params[:id])
          with(:city_id, params[:filter][:city_id]) if params[:filter][:city_id].present?
          with(:area_id, params[:filter][:area_id]) if params[:filter][:area_id].present?
          with(:shop_category_id, params[:filter][:shop_category_id]) if params[:filter][:shop_category_id].present?
        end
        @shops = search.results
      else
        @shops = @parent.shops.flatten
      end
      @peoples = apply_array_pagination(flatten_data(@shops, &:peoples), 1)
    else
      @peoples = People.page(params[:page]).per(10)
    end
    render :partial => '/dealers/more_peoples', :layout => false
  end

  def load_more_brand_corner_report_lines
    @corner_reports = load_filtered_corner_report_line
    @corner_brand_report_lines = @corner_reports.group_by {|d| d[:brand_id] }
    render :partial => '/dealers/more_brand_corner_images'
  end

  def load_more_category_corner_report_lines
    @corner_reports = load_filtered_corner_report_line
    @corner_category_report_lines = @corner_reports.group_by {|d| d[:product_category_id]}
    render :partial => '/dealers/more_category_corner_images'
  end

  def load_filtered_corner_report_line
    page = params[:page].nil? ? 1: params[:page]
    if params[:filter].present?
      from = params[:filter][:from].present? ? ((params[:filter][:from]).to_date).to_time : Post.first.created_at.to_date.to_time
      to  = params[:filter][:to].present? ? ((params[:filter][:to]).to_date).to_time : Date.today.to_date.to_time
      @posts = Post.published_reports.where('created_at >= ? AND created_at <= ?',from, to).flatten
    else
      @posts = Post.published_reports.flatten
    end
    post_ids = flatten_data(@posts,&:id)
    @reports = Report.with_posts(post_ids)
    report_ids = flatten_data(@reports,&:id)
    apply_array_pagination(ReportLine.with_reports(report_ids), params[:page])
  end

  def load_more_uploads
    page = params[:page].nil? ? 1: params[:page]
    @uploads = Upload.page(params[:page]).per(10)
    render :partial => '/dealers/load_more_upload_images'
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

  private

  def flatten_data(data,&block)
    data.collect(&block).flatten
  end

  def apply_array_pagination (data, page)
    Kaminari.paginate_array(data).page(page).per(10)
  end
end