class AreasController < ApplicationController
  # GET /areas
  # GET /areas.json
  def index
    authorize! :read, Area
    params[:page] = params[:page].blank? ? 1 : params[:page]
    @areas = Area.page(params[:page]).per(10)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @areas }
    end
  end

  # GET /areas/1
  # GET /areas/1.json
  def show
    authorize! :read, Area
    @area = Area.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @area }
    end
  end

  # GET /areas/new
  # GET /areas/new.json
  def new
    authorize! :create, Area
    @area = Area.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @area }
    end
  end

  # GET /areas/1/edit
  def edit
    authorize! :update, Area
    @area = Area.find(params[:id])
  end

  # POST /areas
  # POST /areas.json
  def create

    @area = Area.new(params[:area])

    respond_to do |format|
      if @area.save
        @area.create_activity :create, owner: current_user
        format.html { redirect_to @area, notice: 'Area was successfully created.' }
        format.json { render json: @area, status: :created, location: @area }
      else
        format.html { render action: "new" }
        format.json { render json: @area.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /areas/1
  # PUT /areas/1.json
  def update
    @area = Area.find(params[:id])

    respond_to do |format|
      if @area.update_attributes(params[:area])
        @area.create_activity :update, owner: current_user
        format.html { redirect_to @area, notice: 'Area was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @area.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /areas/1
  # DELETE /areas/1.json
  def destroy
    authorize! :destroy, Area
    @area = Area.find(params[:id])
    @area.create_activity :destroy, owner: current_user
    @area.destroy

    respond_to do |format|
      format.html { redirect_to areas_url }
      format.json { head :no_content }
    end
  end
end
