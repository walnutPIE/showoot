class PostsController < ApplicationController
  #before_action :set_post, except: [:index, :new, :create]

  def self.index(current_user)
    posts = PostModel.getAllPosts
    return posts.where(user_id: current_user.id)
  end

  def self.new_p
    return PostModel.createPost
  end

  def self.create(params)
    PostModel.createPost(params)
    return Post.last.id
  end

  def self.edit(post)
  end

  def self.update(post, params)
    #@post.update_attributes(set_post_params)
    PostModel.setPost(post.id, params)

  end

  def self.show(post)
    post = PostModel.getPost(post.id)
  end

  def self.destroy(post)
    PostModel.destroyPost(post.id)
  end

  def self.search_by(search_term)
    PostModel.search_by(search_term)
  end
end
