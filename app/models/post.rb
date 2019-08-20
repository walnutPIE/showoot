class Post < ApplicationRecord
  mount_uploader :image, ImageUploader

  belongs_to :user, optional: true
  has_many :user_posts, dependent: :destroy
  has_one :codi, dependent: :destroy

  #엔티티 클래스 function

  def self.index(current_user)
    posts = PostDm.getAllPosts
    return posts.where(user_id: current_user.id)
  end

  def self.new_post
    return PostDm.createPost
  end

  def self.create_post(params)
    PostDm.createPost(params)
    return Post.last.id
  end

  def self.edit_post(post)
  end

  def self.update_post(post, params)
    #@post.update_attributes(set_post_params)
    PostDm.setPost(post.id, params)

  end

  def self.show_post(post)
    post = PostDm.getPost(post.id)
  end

  def self.destroy_post(post)
    PostDm.destroyPost(post.id)
  end

  def self.find_post_by_term(user_id, term)
    posts = PostDm.getAllPosts
    return posts.where('user_id LIKE ? AND (title LIKE ? OR body LIKE ?)',user_id, term, term )
  end

  def self.getallpostswithid(id)
    posts = PostDm.getAllPosts
    return posts.where(user_id:id)
  end
end
