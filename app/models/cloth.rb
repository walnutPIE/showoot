class Cloth < ApplicationRecord
  belongs_to :codi

  @@clothes_info = { "원피스": ["롱", "미니", "패턴", "니트", "뷔스티에"],
    "아우터": ["코트", "자켓", "패딩", "점퍼", "후드집업", "가디건", "청자켓"],
    "상의": ["블레이저", "무지티셔츠", "패턴티셔츠", "프린팅티셔츠", "맨투맨", "후드", "민소매", "니트", "7부"],
    "셔츠/블라우스": ["오프숄더", "베이직", "반팔", "7부", "체크/패턴"],
    "하의": ["데님", "슬랙스", "7부", "스키니진", "일자", "나팔", "레깅스", "반바지", "숏스커트", "테니스치마", "미니스커트", "롱치마", "청바지", "면바지"],
    "점프수트": ["점프수트"] }

  def self.index(current_user=nil)
    clothes = ClothDm.getAllClothes
    if current_user == nil
      return clothes
    else
      return clothes.where(user_id: current_user.id)
    end
  end

  def self.new_cloth
    return ClothDm.createCloth
  end

  def self.create_cloth(params)
    ClothDm.createCloth(params)
  end

  def self.edit_cloth(cloth)
  end

  def self.update_cloth(cloth)
    ClothDm.setCloth(cloth.id, set_cloth_params)

  end

  def self.show_cloth(cloth)
    cloth = ClothDm.getCloth(cloth.id)
  end

  def self.destroy_cloth(cloth)
    ClothDm.destroyCloth(cloth.id)
  end

  def self.find_cloth_by_term(user_id, term)
    # posts = Post.where(user_id: user_id) #CodiDm.getAllCodis
    # codis = []
    # posts.each do |post|
    #   if post.codi.event == term
    #     codis.append(post.codi)
    #   end
    # end
    # return codis

    clothes = ClothDm.getAllClothes
    return clothes.where('user_id LIKE ? AND (main_category LIKE ? OR sub_category LIKE ? OR color LIKE ?)',user_id, term, term, term)
  end

  private
  def self.get_clothes_info
    return @@clothes_info
  end
end
