require "net/http"
require "uri"
uri = URI('http://www.jianshu.com/users/ef49e6b7ec1e/latest_articles')
req = Net::HTTP::Get.new(uri)
req['Accept'] = "text/javascript, application/javascript, application/ecmascript, application/x-ecmascript, */*; q=0.01"
req['X-Requested-With'] = "XMLHttpRequest"

res = Net::HTTP.start(uri.hostname, uri.port) {|http|
  http.request(req)
}
latest_articles_html = res.body.to_s
if /\$\('ul.latest-notes'\).append\("(.*?)\)/ =~ latest_articles_html
  print $1
end

#print latest_articles_html