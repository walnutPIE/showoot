class MypageController < ApplicationController
  def index
    @my_posts = Post.index(current_user)
  end

  def category
    #원피스, 아우터, 상의, 셔츠/블라우스, 하의, 점프수트
    @my_clothes = {}
    @my_clothes.store("원피스", [])
    @my_clothes.store("아우터", [])
    @my_clothes.store("상의", [])
    @my_clothes.store("셔츠/블라우스", [])
    @my_clothes.store("하의", [])
    @my_clothes.store("점프수트", [])

    Post.index(current_user).each do |post|
      post.codi.cloths.each do |cloth|
        @my_clothes[cloth.main_category].append(cloth)
      end
    end
  end

end
