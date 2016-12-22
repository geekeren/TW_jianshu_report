require "net/http"
require "uri"
#抓取源数据的“蜘蛛/爬虫”
class Spider

  def self.getJsFromUrl(url)
    uri = URI(url)
    req = Net::HTTP::Get.new(uri)
    req['Accept'] = "text/javascript, application/javascript, application/ecmascript, application/x-ecmascript, */*; q=0.01"
    req['X-Requested-With'] = "XMLHttpRequest"
    res = Net::HTTP.start(uri.hostname, uri.port) {|http|
      http.request(req)
    }
    res.body.to_s
  end

  def self.getRawFromUrl(url)
    uri = URI(url)
    req = Net::HTTP::Get.new(uri)
    res = Net::HTTP.start(uri.hostname, uri.port) {|http|
      http.request(req)
    }
    res.body.to_s
  end


end
puts Spider.getJsFromUrl("http://www.jianshu.com/users/ef49e6b7ec1e/latest_articles")
puts Spider.getRawFromUrl("http://www.jianshu.com/users/ef49e6b7ec1e/latest_articles")