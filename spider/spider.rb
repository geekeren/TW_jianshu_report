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
      url = URI.escape("#{HOST}/u/#{uuid}?order_by=shared_at&page=#{i}")
      articlesHTML = getHtmlWithXMLRequestFromUrl(URI(url))

      # if /\$\('ul.latest-notes'\).append\("(.*?)"\)/ =~ articlesJS
      #   articlesHTML= $1
      # end
      # print articlesHTML
      # articlesHTML= String.class_eval(%Q("#{articlesHTML}"))
      #print "content:", YAML.load(%Q("#{articlesHTML}"))
      dom = Nokogiri::HTML("<div>#{articlesHTML}</div>")
      if articlesHTML =~ /^[\s]*$/
        break
      end
      dom.css("li").each do |li|
        # 时间
        time = DateTime.parse(li.css("span.time").attr("data-shared-at").to_s).strftime('%Y-%m-%d')
        # 标题
        title = li.css("div.content").css("a.title").text.to_s
        # 文章地址
        link = li.css("div.content").css("a.title").attr("href").to_s
        # 阅读量
        readedStr = li.css("div.meta").css("a")[0].text.to_s.strip
        readedNumber = readedStr
        # 评论
        commentStr = li.css("div.meta").css("a")[1].text.to_s.strip
        commentNumber = commentStr
        # 喜欢
        likeStr = li.css("div.meta").css("a")[2].text.to_s.strip
        likeNumber = likeStr
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

  def Spider.getArticlesByUserIdBetweenTime(uuid, startTime, endTime)
    articles = Spider.getLatestArticlesByUUID(uuid)
    articles.delete_if do |article|
      time = Time.parse(article["time"])
      !(time >= startTime && time <= endTime)
    end
    articles
  end

  def self.getArticlesByUserIdWithinThisWeek(uuid)

    today = Time.new
    timeStr= today.strftime("%Y-%m-%d")
    todayYmd=Time.parse(timeStr)
    sevenDayAgoYmd=todayYmd-604800


    articles = Spider.getArticlesByUserIdBetweenTime(uuid, sevenDayAgoYmd, todayYmd)
    articles
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


  def self.getHtmlWithXMLRequestFromUrl(url)
    uri = URI(url)
    req = Net::HTTP::Get.new(uri)
    req['Accept'] = "text/html, */*; q=0.01"
    req['X-INFINITESCROLL'] = "true"
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

# today = Time.new
# timeStr= today.strftime("%Y-%m-%d")
# todayYmd=Time.parse(timeStr)
# sevenDayAgoYmd=todayYmd-604800
# sevenDayAgoYmdStr = sevenDayAgoYmd.strftime("%Y-%m-%d")
# puts Spider.getLatestArticlesByUUID("ef49e6b7ec1e")