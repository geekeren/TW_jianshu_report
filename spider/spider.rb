require "net/http"
require "uri"
require "json"
require "nokogiri"
require "date"

module Spider
	HOST = "http://www.jianshu.com"
	# 获取用户名的UUID
	def Spider.getUUID(userName)
		puts "正在查询..."
		url = URI.escape("#{$host}/search/do?q=#{userName}&page=1&type=users")
		authorsJSON = Net::HTTP.get(URI(url))
		authorsOBJ = JSON.parse(authorsJSON)
		name = authorsOBJ["entries"][0]["nickname"]
		if name !=userName
			return "未找到此用户"
		end
		return authorsOBJ["entries"][0]["slug"]
	end
	#获取用户的所有文章
	def Spider.getLatestArticles(userName)
		uuid = getUUID(userName)
		i = 1
		arr = Array.new
		loop do
			url = URI.escape("#{$host}/users/#{uuid}/latest_articles?page=#{i}")
			articlesHTML = Net::HTTP.get(URI(url))
			dom = Nokogiri::HTML(articlesHTML)
			if dom.css("ul.article-list").children.to_s.strip == ""
				break
			end
			dom.css("ul.article-list").css("li").each do |li|
				# 时间
				time = DateTime.parse(li.css("span.time").attr("data-shared-at").to_s).strftime('%Y-%m-%d')
				# 标题
				title = li.css("h4.title").css("a").text.to_s
				# 文章地址
				link = li.css("h4.title").css("a").attr("href").to_s
				# 阅读量
				readedStr = li.css("div.list-footer").css("a")[0].text.to_s.strip
				readedNumber = readedStr[3..readedStr.length]
				# 评论
				commentStr = li.css("div.list-footer").css("a")[1].text.to_s.strip
				commentNumber = commentStr[5..commentStr.length]
				# 喜欢
				likeStr = li.css("div.list-footer").css("span").text.to_s.strip
				likeNumber = likeStr[5..likeStr.length]
				articleObj = Hash.new
				articleObj = {
					"title" => "#{title}",
					"time" => "#{time}",
					"link" => "#{$host + link}",
					"readed" => "#{readedNumber}",
					"comment" => "#{commentNumber}",
					"like" => "#{likeNumber}"
				}
				arr.push(articleObj)
			end
			i +=1
		end
		return arr
	end
	# 测试用户输入日期
	def Spider.testDate(str)
		dateReg = /\d{4}-\d{2}-\d{2}/
		datelist = str.split(" ")
		if datelist.length < 2
			return nil
		end
		dateStrat = datelist[0]
		dateEnd = datelist[1]
		if dateStrat =~ dateReg && dateEnd =~ dateReg
			return dateStrat, dateEnd
		else
			return nil
		end
	end
end
