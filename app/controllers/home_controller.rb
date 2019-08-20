class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    #tab1 -> diary
    if params[:picked_date].present?
      @picked_date = params[:picked_date]
    else
      @picked_date = Date.today.strftime('%Y-%m-%d')
    end
    @my_posts = Post.index(current_user)
    @target_posts = @my_posts.where(posted_at: @picked_date)
    @others_posts = Post.where.not(user_id: current_user.id)
  end
end
