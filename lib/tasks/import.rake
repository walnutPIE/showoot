# encoding: UTF-8
require 'csv'
namespace :import do

	task posts: :environment do
		filename = File.join Rails.root, "posts2.csv"
		file = CSV.read(filename, col_sep:',', encoding: "EUC-KR")
		cnt=0
		file.each do |row|
			user_id,post_id,title, body,created_at, updated_at,open_range, like_count, posted_at, index = row

			post = Post.new(user_id:user_id,title:title,body:body,created_at:created_at,updated_at:updated_at,open_range:open_range,like_count:like_count,posted_at:posted_at)
			post.id=post_id
			post.save
			cnt+=1 if post.persisted?
		end
		puts "Imported #{cnt} posts"
	end

	task codis: :environment do
		filename = File.join Rails.root, "codis2.csv"
		file = CSV.read(filename, col_sep:',', encoding: "EUC-KR")
		cnt=0
		response = HTTParty.get('http://api.openweathermap.org/data/2.5/weather?id=524901&APPID=9470ef016a30a1dd8fe2e39a52be2097&q=seoul&units=metric', headers: { 'APPID' => '9470ef016a30a1dd8fe2e39a52be2097' }).parsed_response
        w=response['main']
    
		file.each do |row|
			post_id,codi_id,e,p,c,u,i=row

			codi = Codi.new(post_id:post_id,event:e,preference:p,created_at:c,updated_at:u,weather:w)
			codi.id=codi_id
			codi.save
			cnt+=1 if codi.persisted?
		end
		puts "Imported #{cnt} codis"
	end
	task clothes: :environment do
		filename = File.join Rails.root, "clothes2.csv"
		file = CSV.read(filename, col_sep:',', encoding: "EUC-KR")
		cnt=0
		file.each do |row|
			codi_id,cloth_id,m,s,co,c,u=row

			cloth = Cloth.new(codi_id:codi_id,main_category:m,sub_category:s,color:co,created_at:c,updated_at:u)
			cloth.id=cloth_id
			mainarr = ["원피스", "아우터","상의","셔츠/블라우스","하의","점프수트"]
      		subarr = ["롱","미니","패턴","니트","뷔스티에","코트","자켓","패딩","점퍼","후드집업","가디건","청자켓","블레이저","무지티셔츠","패턴티셔츠","프린팅티셔츠","맨투맨","후드","민소매","니트","7부","오프숄더","베이직","반팔","7부","체크/패텅","데님","슬랙스","7부","스키니진","일자","나팔","레깅스","반바지","숏스커트","테니스치마","미디스커트","롱치마","청바지","면바지","점프수트"]
      		colorarr = ["빨강","노랑","녹색","파랑","보라","주황","연두","청록","군청","자주","흰색","회색","검정","분홍","하늘","브라운"]
      		code=0
      		code+=(mainarr.index(cloth.main_category)+1)*10000
      		code+=(subarr.index(cloth.sub_category)+1)*100
      		code+=(colorarr.index(cloth.color)+1)
      		cloth.code = code
      

			cloth.save
			cnt+=1 if cloth.persisted?
		end
		puts "Imported #{cnt} clothes"
	end

end