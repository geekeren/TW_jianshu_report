require './model/tw_author_info'
require './data_loader'
require './report_creator.rb'
require './spider/spider'
require 'time'

dateReg = /\d{4}-\d{2}-\d{2}/

dateStart = ARGV[0]
dateEnd = ARGV[1]
if dateStart=~ dateReg and dateEnd=~ dateReg
  dateStart = Time.parse(dateStart)
  dateEnd = Time.parse(dateEnd)
else
  print "请输入正确的开始时间和结束时间（如2016-12-23 2017-01-01）"
  exit
end


authorInfoList = loadAuthorListFromFile("studentlist.csv")
print "\n开始抓取\n"

def printProcess(completed, total)
  rate = ((completed.to_f/total)*20).to_i
  rateStr="["
  rate.times {
    rateStr+="#"
  }

  (20-rate).times {
    rateStr+=" "
  }
  rateStr+="]"

  print "\r完成进度： #{rateStr}  #{completed/total==1? "completed!":format("%s/%s",completed,total) }"
end




authorArticleInfoList=Array.new
authorInfoList.each_with_index { |authorInfo, i|
  #loadAuthorInfoFromNet(authorInfo)
  authorArticleInfo = Hash.new
  articles = Spider.getLatestArticlesByUUID(authorInfo.id)
  articles.delete_if do |article|
    time = Time.parse(article["time"])
    !(time >= dateStart && time <= dateEnd)
  end
  authorArticleInfo["authorID"]=authorInfo.id
  authorArticleInfo["authorBuddy"]=authorInfo.buddy
  authorArticleInfo["authorName"]=authorInfo.name
  authorArticleInfo["articles"]=articles

  authorArticleInfoList << authorArticleInfo
  printProcess(i+1, authorInfoList.length)
}



# p authorInfoList

ReportCreator.loadAuthorArticlesList(authorArticleInfoList).setTime(ARGV[0],ARGV[1]).out2Html("2017届思沃大讲堂同学简书文章统计")
