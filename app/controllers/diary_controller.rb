class DiaryController < ApplicationController
  before_action :set_post, except: %i[pick_date index_post new_post create_post update_post]

  def index_post
    if params[:picked_date].present?
      @picked_date = params[:picked_date]
    else
      @picked_date = Date.today.strftime('%Y-%m-%d')
    end

    @my_posts = Post.index(current_user)
    @target_posts = @my_posts.where(posted_at: @picked_date)
  end

  def show_post
    Post.show_post(@post)
  end

  def new_post
    @post = Post.new_post
    @picked_date = params[:picked_date]
  end

  def create_post
    # 날씨정보 받아오기
    weather = get_current_weather

    # post params
    post_params = params[:post]
    post_id = Post.create_post(post_params)

    # codi params
    codi_params = {}
    codi_params.merge!(post_id: post_id)
    codi_params.merge!(weather: weather)
    codi_params.merge!(event: params[:event])
    codi_params.merge!(preference: params[:preference])
    codi_id = Codi.create_codi(codi_params)

    # clothes params
    clothes_info = JSON.parse(params['clothes_info'])
    clothes_info.each do |cloth_info|
      cloth_params = {}
      cloth_params[:codi_id] = codi_id
      cloth_params[:main_category] = cloth_info['main']
      cloth_params[:sub_category] = cloth_info['sub']
      cloth_params[:color] = cloth_info['color']

      Cloth.create_cloth(cloth_params)
    end

    redirect_to root_path
  end

  def edit_post
    Post.edit_post(@post)
    @picked_date = @post.posted_at
  end

  def update_post
    target = Post.where(posted_at: params[:post][:posted_at]).first
    #Post.update_post(target, params[:post])
    target.title = params[:post][:title]
    target.body = params[:post][:body]
    target.image = params[:post][:image]
    target.posted_at = params[:post][:posted_at]
    target.save
    redirect_to root_path
  end

  def destroy_post
    Post.destroy_post(@post)
    redirect_to root_path
  end

  def pick_date
    @picked_date = params[:picked_date]
    my_posts = Post.index(current_user)
    @target_posts = my_posts.where(posted_at: @picked_date)
    # redirect_to index_posts_path(picked_date: @picked_date)
    respond_to do |format|
      format.js {}
    end
  end

  private

  def global_var
    if params[:picked_date].present?
      @picked_date = params[:picked_date]
    else
      @picked_date = Date.today.strftime('%Y-%m-%d')
    end

    @my_posts = Post.index(current_user)
    @target_posts = @my_posts.where(posted_at: @picked_date)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def get_current_weather
    response = HTTParty.get('http://api.openweathermap.org/data/2.5/weather?id=524901&APPID=9470ef016a30a1dd8fe2e39a52be2097&q=seoul&units=metric', headers: { 'APPID' => '9470ef016a30a1dd8fe2e39a52be2097' }).parsed_response
    if response['main']
      return response['main']
    else
      return false
    end
  end
end
