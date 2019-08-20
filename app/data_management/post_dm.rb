class PostDm
  # 전체 포스트 가져오기
  def self.getAllPosts
    return Post.all
  end

  def self.createPost(params=nil)
    if params == nil
      return Post.new
    else
      post = Post.new
      post.user_id = params[:user_id]
      post.title = params[:title]
      post.body = params[:body]
      post.image = params[:image]
      post.posted_at = params[:posted_at]
      post.save
    end
  end

  def self.getPost(id)
    return Post.find(id)
  end

  def self.setPost(id, post_params)
    post = Post.find(id)
    post.update_attributes(post_params)
  end

  def self.destroyPost(id)
    post = Post.find(id)
    post.destroy
  end

end
