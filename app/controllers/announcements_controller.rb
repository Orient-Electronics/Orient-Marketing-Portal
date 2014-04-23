class AnnouncementsController < ApplicationController
	
	def index
		authorize! :read, Announcement
		@announcements = Announcement.order("created_at desc")
	end

	def show
		authorize! :read, Announcement
		@announcement =  Announcement.find(params[:id])
	end

	def new
		authorize! :create, Announcement
		@announcement =  Announcement.new
	end

	def edit
		authorize! :update, Announcement
		@announcement =  Announcement.find(params[:id])
	end

	def create
		@announcement =  Announcement.new(params[:announcement])
		respond_to do |format|
      if @announcement.save
        @announcement.create_activity :create, owner: current_user
        format.html { redirect_to @announcement, notice: 'Announcement was successfully created.' }
        format.json { render json: @announcement, status: :created, location: @announcement }
      else
        format.html { render action: "new" }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
	end

	def update
		@announcement =  Announcement.find(params[:id])
		respond_to do |format|
      if @announcement.update_attributes(params[:city])
        @announcement.create_activity :update, owner: current_user
        format.html { redirect_to @announcement, notice: 'Announcement was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
	end

	def destroy
		@announcement =  Announcement.find(params[:id])
		@announcement.create_activity :destroy, owner: current_user
		@announcement.destroy
		respond_to do |format|
      format.html { redirect_to announcement_url, notice: 'Announcement was successfully deleted.'  }
      format.json { head :no_content }
    end
	end

end
