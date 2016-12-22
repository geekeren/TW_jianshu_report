require "net/http"
require "uri"
require "json"
require "nokogiri"
require "date"

# spider模块
$LOAD_PATH << "."
require "spider"

$host = "http://www.jianshu.com"

END {
	case ARGV.length
	when 1
		puts Spider.getUUID(ARGV[0])
	when 2
		if ARGV[1] == "*"
			articles = Spider.getLatestArticles(ARGV[0])
			printArticle(articles)
		elsif Spider.testDate(ARGV[1])
			dateStrat, dateEnd = Spider.testDate(ARGV[1])
			dateStrat = DateTime.parse(dateStrat)
			dateEnd = DateTime.parse(dateEnd)
			articles = Spider.getLatestArticles(ARGV[0])
			articles.delete_if do |article|
				time = DateTime.parse(article["time"])
				!(time >= dateStrat && time <= dateEnd)
			end
			printArticle(articles)
		else
			puts "参数错误-_-"
		end
	else
		puts "你别乱输啊-_-"
	end
}

# 打印数据
def printArticle(articles)
	puts "一共有#{articles.length}篇文章"
	articles.each do |article|
		article.each do |key, val|
			case key
			when "title"
				puts "标题: #{val}"
			when "time"
				puts "时间: #{val}"
			when "link"
				puts "文章地址: #{val}"
			when "readed"
				puts "阅读: #{val}"
			when "comment"
				puts "评论: #{val}"
			when "like"
				print "喜欢: #{val}\n\n"
			end
		end
	end
end
