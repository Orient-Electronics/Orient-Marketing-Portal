class DealersController < ApplicationController
  # GET /dealers
  # GET /dealers.json
  def index
    authorize! :read, Dealer
    @dealers = Dealer.all
    @shops = Shop.all
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
    @shops = @parent.shops

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

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @dealer }
    end
  end

  # GET /dealers/1/edit
  def edit
    authorize! :update, Dealer
    @dealer = Dealer.find(params[:id])
  end

  # POST /dealers
  # POST /dealers.json
  def create
    @dealer = Dealer.new(params[:dealer])

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
    @uploads = @dealer.shops.collect(&:uploads).flatten
    
  end


  def showgallery
    @dealers = Dealer.all
    @shop = @dealers.collect(&:shops)
    @uploads = @shop.flatten.collect(&:uploads).flatten
  end

end