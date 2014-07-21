class ImagesController < ApplicationController

  def show

      @shop = Shop.where(id: params[:shop_id]).first if params[:shop_id].present?
      @dealer = Dealer.where(id: params[:dealer_id]).first if params[:dealer_id].present?

      if params[:type] == 'upload'
        @image = Upload.where(id: params[:id]).first
      else
        @image = Avatar.where(id: params[:id]).first
      end
      @length = @image.comments.length
      @comments = @image.comments.last(10)
  end

  def create_comment
    if params[:type] == 'upload'
      @image = Upload.where(id: params[:id]).first
    else
      @image = Avatar.where(id: params[:id]).first
    end
    comment = @image.comments.build(params[:comment])
    comment.user_id = current_user.id
    if comment.save
      flash[:notice] = "Successfully comment posted"
    else
      flash[:warning] = "Failed comment posting"
    end
    redirect_to :back
  end

  def view_more_comments
    if params[:type] == 'upload'
      @image = Upload.where(id: params[:id]).first
    else
      @image = Avatar.where(id: params[:id]).first
    end
    @comments = @image.comments
  end
  respond_to do |format|
    format.js
  end
end
