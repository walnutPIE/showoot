class SearchController < ApplicationController

  def search_by(search_term)
    arr = Set.new([])
    term = "%#{search_term}%"
    user_id = current_user.id
    #post = Post.where('title LIKE ? OR body LIKE ?', term, term)
    posts = Post.find_post_by_term(user_id, term)
    #codi = Codi.where('event LIKE ?', term)
    codis = Codi.find_codi_by_term(user_id, term)
    #cloth = Cloth.where('main_category LIKE ? OR sub_category LIKE ? OR color LIKE ?', term, term, term)
    #clothes = Cloth.find_cloth_by_term(user_id, term)

    # clothes.each do |cloth|
    #   arr.add(cloth.codi.post_id)
    # end
    codis.each do |codi|
      arr.add(codi.post_id)
    end
    posts.each do |post|
      arr.add(post.id)
    end

    target = Post.where(id: arr)

    target
  end

  def result
    if params[:search]
      @search_term = params[:search]
    end
    @target_posts = search_by(@search_term)
  end

end
