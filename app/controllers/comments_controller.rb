class CommentsController < ApplicationController

  def destroy
    comment = Comment.find(params[:id])
    if current_user.can_remove_comment?(comment)
      comment.destroy
      flash[:notice] = "Successfully remove comment"
    else
      flash[:warning] = "Access denied to remove this comment"
    end
    redirect_to :back
  end

  def create
    comment = Comment.new(params[:comment])
    if comment.save
      flash[:notice] = "Successfully comment created"
    else
      flash[:warning] = "Access denied to add this comment"
    end
      redirect_to :back
  end

  def load_more_comments
    @activity =  PublicActivity::Activity.find(params[:id])
    @comments = @activity.comments.order("created_at desc")
    respond_to do |format|
      format.js
    end
  end

end
