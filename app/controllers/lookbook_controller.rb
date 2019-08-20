class LookbookController < ApplicationController
  def index
    @my_posts = Post.index(current_user)
    @others_posts = Post.where.not(user_id: current_user.id)
  end

  def likes
    likes = UserPost.find_by(user_id: current_user.id, post_id: params[:id])
    #좋아요가 눌렸는지 체크
    if likes.nil?
      UserPost.create(user_id: current_user.id, post_id: params[:id])
    else
      likes.destroy
    end
    @others_posts = Post.where.not(user_id: current_user.id)
    respond_to do |format|
      format.js { render :nothing => true }
    end
  end
end
