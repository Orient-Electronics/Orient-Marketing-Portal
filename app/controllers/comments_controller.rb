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
end
