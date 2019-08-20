class CodiDm
  # 전체 포스트 가져오기
  def self.getAllCodis
    return Codi.all
  end

  def self.createCodi(params=nil)
    if params==nil
      return Codi.new
    else
      codi = Codi.new
      codi.post_id = params[:post_id]
      codi.weather = params[:weather] if params[:weather] != false
      codi.event = params[:event]
      codi.preference = params[:preference]
      codi.save
    end
  end

  def self.getCodi(id)
    return Codi.find(id)
  end

  def self.setCodi(id, codi_params)
    codi = Codi.find(id)
    codi.update_attributes(codi_params)
  end

  def self.destroyCodi(id)
    codi = Codi.find(id)
    codi.destroy
  end
end
