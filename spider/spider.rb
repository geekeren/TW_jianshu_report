require "net/http"
require "uri"
require "json"
require "nokogiri"
require "date"
require 'yaml'

module Spider
  HOST = "http://www.jianshu.com"

  def Spider.getLatestArticlesByUUID(uuid)
    i = 1
    arr = Array.new
    loop do
      url = URI.escape("#{HOST}/users/#{uuid}/latest_articles?page=#{i}")
      articlesJS = getJsFromUrl(URI(url))

      if /\$\('ul.latest-notes'\).append\("(.*?)"\)/ =~ articlesJS
        articlesHTML= $1
      end
      articlesHTML= String.class_eval(%Q("#{articlesHTML}"))
      #print "content:", YAML.load(%Q("#{articlesHTML}"))
      dom = Nokogiri::HTML("<div>#{articlesHTML}</div>")
      if articlesHTML == ""
        break
      end
      dom.css("li").each do |li|
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
            "author_id" => "#{uuid}",
            "title" => "#{title}",
            "time" => "#{time}",
            "link" => "#{HOST + link}",
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

  def self.getArticlesByUserIdBetweenTime(startTime, endTime)

  end

  #获取用户的所有文章
  def self.getArticlesByUserIdBetweenTime(uuid)

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


  def self.getJsFromUrl(url)
    uri = URI(url)
    req = Net::HTTP::Get.new(uri)
    req['Accept'] = "text/javascript, application/javascript, application/ecmascript, application/x-ecmascript, */*; q=0.01"
    req['X-Requested-With'] = "XMLHttpRequest"
    res = Net::HTTP.start(uri.hostname, uri.port) { |http|
      http.request(req)
    }
    res.body.to_s
  end

  def self.getRawFromUrl(url)
    uri = URI(url)
    req = Net::HTTP::Get.new(uri)
    res = Net::HTTP.start(uri.hostname, uri.port) { |http|
      http.request(req)
    }
    res.body.to_s
  end
end
