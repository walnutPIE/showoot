class RecommendController < ApplicationController
  #before_action :set_post, except: [:index, :new, :create]


  def getalluser
    userset = Set.new([])
    user = User.all
    user.each do |user|
      userset.add(user.id)
    end
    return userset
  end

  def fillcodiinfo(userset)
    time = Time.new
    tmp = {}
    userset.each do |user|
      codiinfo ={}
      posts = Post.getallpostswithid(user)
      posts.each do |post|
        #if post.created_at > time.4.months.ago
          if post.codi==nil

          end
          prefer = post.codi.preference

          clothlist=[]
          post.codi.cloths.each do |cloth|
              clothlist.push(cloth.code)

          end
          clothlist.sort
          if codiinfo.include?(clothlist)
            cnt =codiinfo[clothlist]["count"]+1
            codiinfo[clothlist]["count"]=cnt
            codiinfo[clothlist]["preference"]+=prefer
            codiinfo[clothlist]["avg"] = codiinfo[clothlist]["preference"]/cnt
          else
            tmphash={}
            tmphash["count"]=1
            tmphash["preference"] = prefer
            tmphash["avg"] = prefer
            codiinfo[clothlist]=tmphash
          end
        #end
      end
      likes = UserPost.find_by(user_id:user)

      Array(likes).each do |like|
        post = PostDm.getPost(like.post_id)
        if post.codi==nil
            byebug
          end
          prefer = 4

          clothlist=[]
          post.codi.cloths.each do |cloth|
              clothlist.push(cloth.code)

          end
          clothlist.sort
          if codiinfo.include?(clothlist)
            cnt =codiinfo[clothlist]["count"]+1
            codiinfo[clothlist]["count"]=cnt
            codiinfo[clothlist]["preference"]+=prefer
            codiinfo[clothlist]["avg"] = codiinfo[clothlist]["preference"]/cnt
          else
            tmphash={}
            tmphash["count"]=1
            tmphash["preference"] = prefer
            tmphash["avg"] = prefer
            codiinfo[clothlist]=tmphash
          end
      end
      tmp[user]=codiinfo
    end
    return tmp
  end

  def getpearsoncorr(myinfolist,others)
    pearsoncorr = {}
    others.each_key do |user|
      sumx=0
      sumy=0
      sumpowx=0
      sumpowy=0
      sumxy=0
      cnt=0

      infos=others[user]

      infos.each_key do |x|
        myinfolist.each_key do |y|
          if x==y
            y=myinfolist[x]
            cnt+=1
            sumx += infos[x]["avg"]
            sumy += y["avg"]
            sumpowx += (infos[x]["avg"])**2
            sumpowy += (y["avg"])**2
            sumxy += infos[x]["avg"]*y["avg"]
          end
        end
      end
      #byebug
      if cnt==0
        pearsoncorr[user]=0
      else
        t = sumxy - ((sumx*sumy)/cnt)
        dx = sumpowx - ((sumx**2)/cnt)
        dy = sumpowy - ((sumy**2)/cnt)
        #byebug
        if Math.sqrt(dx*dy)==0
          pearsoncorr[user]=0
        else
          pearsoncorr[user]=(t/Math.sqrt(dx*dy))
        end
      end

    end
    return pearsoncorr
  end

  def gettopcorr(dict,cur_id)
    arr=[]
    dict.each_key do |id|
      if id==cur_id
      else
        tmp = [dict[id],id]
        if dict[id]>0
          arr.push(tmp)
        end
      end
    end
    arr=arr.sort.reverse
    return arr
  end

  def tmpcheck(a,b,c,d)
    if a+5<=c and a-5>=c
      if b+5<=d and b-5>=d
        return true
      end
    end
    return false
  end

  def get_current_weather
    response = HTTParty.get('http://api.openweathermap.org/data/2.5/weather?id=524901&APPID=9470ef016a30a1dd8fe2e39a52be2097&q=seoul&units=metric', headers: { 'APPID' => '9470ef016a30a1dd8fe2e39a52be2097' }).parsed_response
    if response['main']
      return response['main']
    else
      return false
    end
  end

  def getrecom(id)
    business=[]
    daily=[]
    date=[]
    friend=[]
    posts = Post.getallpostswithid(id)
    posts.each do |post|
      if post.codi.event == "데이트"
        cur = get_current_weather
        cmp = post.codi.weather
        date.push([post.codi.preference,post.id])
      elsif post.codi.event == "비즈니스"
        cur = get_current_weather
        cmp = post.codi.weather
        business.push([post.codi.preference,post.id])
      elsif post.codi.event == "데일리"
        cur = get_current_weather
        cmp = post.codi.weather
        daily.push([post.codi.preference,post.id])
      elsif post.codi.event == "친구"
        cur = get_current_weather
        cmp = post.codi.weather
        friend.push([post.codi.preference,post.id])

        #if tmpcheck(cmp["temp_min"],cmp["temp_max"],cur["temp_min"],cur["temp_max"])==true
        #  date.push([post.codi.preference,post.id])
        #end
      end
    end

    business = business.sort.reverse
    daily = daily.sort.reverse
    date = date.sort.reverse
    friend = friend.sort.reverse
    result = []
    result.push(business[0][1])
    result.push(daily[0][1])
    result.push(date[0][1])
    result.push(friend[0][1])
    return result
  end

  def checkformin(myinfolist)
    cnt =0
    myinfolist.each_key do |x|
      if myinfolist[x]["count"]==nil

      else
        cnt+=myinfolist[x]["count"]
      end
    end
    if cnt>=50
      return false
    else
      return true
    end
  end

  def result

    userset = getalluser
    me = Set.new([current_user.id])
    myinfolist = fillcodiinfo(me)
    #if checkformin(myinfolist)==true
      #byebug
    #  flash.now[:notice]=t('need more posts')
    #  redirect_to(root_path)
    #end

    otherinfolist = fillcodiinfo(userset)
    total ={}
    userset.each do |user|
      total[user] = getpearsoncorr(otherinfolist[user],otherinfolist)
    end

    topcorr = gettopcorr(total[current_user.id],current_user.id)


    final=getrecom(topcorr[0][1])
    byebug
    @target_posts = Post.find(final)
    #@target_posts = Post.index(current_user)
    #test = @target_posts.first.codi
    if @target_posts.blank?
      redirect_to(home_path)
    end
    return @target_posts
  end

end
