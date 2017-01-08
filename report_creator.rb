require 'pathname'
require "./model/mail"
class ReportCreator


  def initialize(startTime, endTime)
    @createTime=Time.new
    @tpl="view/default.tpl.html"
    setTime(startTime, endTime)
  end

  def loadAuthorArticlesList(authorArticlesList)
    @authorArticlesList = authorArticlesList
  end


  def installTpl(tpl)
    @tpl=tpl
    self
  end

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

    print "\r完成进度： #{rateStr}  #{completed/total==1 ? "completed!" : format("%s/%s", completed, total) }"
  end

  def start
    startTime, endTime= @time
    dateReg = /\d{4}-\d{2}-\d{2}/
    if startTime==nil || endTime==nil
      today = Time.new
      timeStr= today.strftime("%Y-%m-%d")
      todayYmd=Time.parse(timeStr)
      sevenDayAgoYmd=todayYmd-604800

      @time = sevenDayAgoYmd,todayYmd
      print "默认统计一周内文章……\n"
    elsif startTime=~ dateReg and endTime=~ dateReg
      dateStart = Time.parse(dateStart)
      dateEnd = Time.parse(dateEnd)
      print "统计#{dateStart}到#{dateEnd}内文章……\n"
    else
      print "请输入正确的开始时间和结束时间（如2016-12-23 2017-01-01）"
      exit
    end

    authorArticleInfoList=Array.new
    @authorInfoList.each_with_index { |authorInfo, i|
      #loadAuthorInfoFromNet(authorInfo)
      authorArticleInfo = Hash.new
      startTime, endTime= @time
      articles = Spider.getArticlesByUserIdBetweenTime(authorInfo.id, startTime, endTime)
      authorArticleInfo["authorID"]=authorInfo.id
      authorArticleInfo["authorBuddy"]=authorInfo.buddy
      authorArticleInfo["authorName"]=authorInfo.name
      authorArticleInfo["articles"]=articles
      authorArticleInfoList << authorArticleInfo
      printProcess(i+1, @authorInfoList.length)
    }
    loadAuthorArticlesList(authorArticleInfoList)
  end

  def rank

  end

  def setTime(startTime, endTime)
    @time = startTime, endTime
    self
  end

  def out2Html

    tplFile = open @tpl
    tplContent = tplFile.read
    tplFile.close
    listContent ="<ul  class=\"ul\">"
    this_active_author_count=0
    this_post_count=0
    this_view_count=0
    for i in 0 .. @authorArticlesList.length-1
      authorArticle = @authorArticlesList[i]
      articles = authorArticle["articles"]
      this_post_count+=articles.length
      if articles.length != 0
        this_active_author_count=this_active_author_count+1
        listContent+=format(" <li  class=\"ul_li\">
            <span class=\"title author_title\"><a target= \"_blank\" href=\"http://jianshu.com/users/%s\">%s</a></span>
             小buddy：<span class=\"buddy_title\">%s</span>", authorArticle["authorID"], authorArticle["authorName"], authorArticle["authorBuddy"])
        listContent+="<ol class=\"ol\">"
        articles.each { |article|
          this_view_count=this_view_count+(article["readed"].to_i)
          listContent+=format(" <li class=\"ol_li\">
            <span  class=\"article_title\"><a target= \"_blank\" href=\"%s\">%s</a></span>
<span class=\"post_info\">（ 浏览 <span  class=\"article_view\">%s</span> | 评论 <span  class=\"article_comment\">%s</span> | 喜欢<span  class=\"article_like\">%s</span>）<span  class=\"article_time\">%s</span><span>
            ", article["link"], article["title"], article["readed"], article["comment"], article["like"], article["time"])

        }
        listContent+="</ol></li>"
      end

    end

    listContent+="</ul>"
    today = @createTime
    timeStr= today.strftime("(%Y-%m-%d %H:%M:%S)")
    if @time
      startTime, endTIme=@time
      startTime= startTime.strftime("%Y-%m-%d")
      endTIme= endTIme.strftime("%Y-%m-%d")
      timeStr= "#{startTime} 到 #{endTIme}";
    end
    footer="Powered By <a target=\"_blank\" href=\"http://www.jianshu.com/collection/efbfebc85205\">思沃大讲堂@ThoughtWorks</a>，"
    footer+="<a target=\"_blank\" href=\"https://bbs.excellence-girls.org/topic/257/%E5%A4%A7%E8%AE%B2%E5%A0%82%E7%88%AC%E8%99%AB%E9%A1%B9%E7%9B%AE%E7%BB%84-%E9%A1%B9%E7%9B%AE%E5%AE%97%E6%97%A8\">加入项目组</a>"
    out = tplContent.force_encoding("utf-8").gsub(/@\{title\}/, @title)
    out = out.gsub(/@\{this_active_author_count\}/, this_active_author_count.to_s)
    out = out.gsub(/@\{this_view_count\}/, this_view_count.to_s)
    out = out.gsub(/@\{this_post_count\}/, this_post_count.to_s)
    out = out.gsub(/@\{list\}/, listContent)
    out = out.gsub(/@\{footer\}/, footer)
    out = out.gsub(/@\{time\}/, timeStr)
    timeStr= today.strftime("[%Y-%m-%d]")
    file=open("output/#{timeStr+@title}.html", "w")
    file.write out
    print "\n输出文件位于", Pathname.new(File.dirname(__FILE__)).realpath, "/", file.path, "\n"
    @reportPath = Pathname.new(File.dirname(__FILE__)).realpath.to_s+ "/"+ file.path
    file.close


    self
  end

  def sendEmail(toName, toAddr)
    if @reportPath && @title

      Mail.new().sendMailFromHtmlFile(toName, toAddr, @createTime.strftime("[%Y-%m-%d]")+@title, @reportPath)

    end
  end

  def setTitle(title)
    @title=title
    self
  end

  def setAuthorInfoList(authorInfoList)
    @authorInfoList=authorInfoList
  end
end
