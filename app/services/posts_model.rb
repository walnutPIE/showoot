class PostsModel
  # 전체 포스트 가져오기
  def self.getAllPosts
    return Post.all
  end

  def self.createPost
    return Post.new
  end

  def self.createPostWithParams(params)
    post = Post.new(set_post_params(params))
    post.save
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

  private
  def self.set_post_params(params)
    params.require(:post).permit(:user_id, :title, :body)
  end
end
