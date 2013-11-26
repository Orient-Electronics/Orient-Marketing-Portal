class ShopCategoriesController < ApplicationController
  # GET /shop_categories
  # GET /shop_categories.json
  def index
    authorize! :read, ShopCategory
    @shop_categories = ShopCategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @shop_categories }
    end
  end

  # GET /shop_categories/1
  # GET /shop_categories/1.json
  def show
    authorize! :read, ShopCategory
    @shop_category = ShopCategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @shop_category }
    end
  end

  # GET /shop_categories/new
  # GET /shop_categories/new.json
  def new
    authorize! :create, ShopCategory
    @shop_category = ShopCategory.new
    @shop_category.build_avatar
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @shop_category }
    end
  end

  # GET /shop_categories/1/edit
  def edit
    authorize! :update, ShopCategory
    @shop_category = ShopCategory.find(params[:id])
    @shop_category.build_avatar
  end

  # POST /shop_categories
  # POST /shop_categories.json
  def create
    @shop_category = ShopCategory.new(params[:shop_category])
    @shop_category.build_avatar params[:shop_category][:avatar_attributes]
    respond_to do |format|
      if @shop_category.save
        format.html { redirect_to @shop_category, notice: 'Shop category was successfully created.' }
        format.json { render json: @shop_category, status: :created, location: @shop_category }
      else
        format.html { render action: "new" }
        format.json { render json: @shop_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /shop_categories/1
  # PUT /shop_categories/1.json
  def update
    @shop_category = ShopCategory.find(params[:id])

    respond_to do |format|
      if @shop_category.update_attributes(params[:shop_category])
        format.html { redirect_to @shop_category, notice: 'Shop category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @shop_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shop_categories/1
  # DELETE /shop_categories/1.json
  def destroy
    authorize! :destroy, ShopCategory
    @shop_category = ShopCategory.find(params[:id])
    @shop_category.destroy

    respond_to do |format|
      format.html { redirect_to shop_categories_url }
      format.json { head :no_content }
    end
  end
end
