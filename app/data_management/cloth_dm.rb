class ClothDm
  # 전체 포스트 가져오기
  def self.getAllClothes
    return Cloth.all
  end

  def self.createCloth(params=nil)
    if params==nil
      return Cloth.new
    else
      cloth = Cloth.new
      cloth.codi_id = params[:codi_id]
      cloth.main_category = params[:main_category]
      cloth.sub_category = params[:sub_category]
      cloth.color = params[:color]
      mainarr = ["원피스", "아우터","상의","셔츠/블라우스","하의","점프수트"]
      subarr = ["롱","미니","패턴","니트","뷔스티에","코트","자켓","패딩","점퍼","후드집업","가디건","청자켓","블레이저","무지티셔츠","패턴티셔츠","프린팅티셔츠","맨투맨","후드","민소매","니트","7부","오프숄더","베이직","반팔","7부","체크/패텅","데님","슬랙스","7부","스키니진","일자","나팔","레깅스","반바지","숏스커트","테니스치마","미디스커트","롱치마","청바지","면바지","점프수트"]
      colorarr = ["빨강","노랑","녹색","파랑","보라","주황","연두","청록","군청","자주","흰색","회색","검정","분홍","하늘","브라운","Red"]
      code=0
      code+=(mainarr.index(cloth.main_category)+1)*10000
      code+=(subarr.index(cloth.sub_category)+1)*100
      code+=(colorarr.index(cloth.color)+1)
      cloth.code = code
      
      cloth.save
    end
  end

  def self.getCloth(id)
    return Cloth.find(id)
  end

  def self.setCloth(id, cloth_params)
    cloth = Cloth.find(id)
    cloth.update_attributes(cloth_params)
  end

  def self.destroyCloth(id)
    cloth = cloth.find(id)
    cloth.destroy
  end


end
