require 'pathname'
class ReportCreator

  def initialize(authorArticlesList)
    @tpl="view/default.tpl.html"
    @authorArticlesList = authorArticlesList
  end

  def self.loadAuthorArticlesList(authorArticlesList)
    ReportCreator.new(authorArticlesList)
  end


  def installTpl(tpl)
    @tpl=tpl
    self
  end

  def render()

  end

  def rank

  end

  def setTime(startTime, endTime)
    @time = startTime, endTime
    self
  end

  def out2Html(title)
    tplFile = open @tpl
    tplContent = tplFile.read
    tplFile.close
    content ="<ul>"
    for i in 0 .. @authorArticlesList.length-1
      authorArticle = @authorArticlesList[i]
      articles = authorArticle["articles"]
      if articles.length != 0
        content+=format(" <li>
            <span class=\"author_title\"><a target= \"_blank\" href=\"http://jianshu.com/users/%s\">%s</a></span>
             小buddy：<span class=\"buddy_title\">%s</span>", authorArticle["authorID"], authorArticle["authorName"], authorArticle["authorBuddy"])
        content+="<ol>"
        articles.each { |article|
          content+=format(" <li>
            <span  class=\"article_title\"><a target= \"_blank\" href=\"%s\">%s</a></span>
            <span  class=\"article_time\">%s</span>", article["link"], article["title"], article["time"])

        }
        content+="</ol></li>"
      end

    end

    content+="</ul>"
    today = Time.new
    timeStr= today.strftime("(%Y-%m-%d %H:%M:%S)");
    if @time
      startTime, endTIme=@time
      timeStr= "#{startTime} 到 #{endTIme}";
    end
    footer="Powered By <a target=\"_blank\" href=\"http://www.jianshu.com/collection/efbfebc85205\">思沃大讲堂@ThoughtWorks</a>"
    out = tplContent.gsub(/@\{title\}/, title)
    out = out.gsub(/@\{content\}/, content)
    out = out.gsub(/@\{footer\}/, footer)
    out = out.gsub(/@\{time\}/, timeStr)
    timeStr= today.strftime("(%Y-%m-%d)");
    file=open("output/#{title+timeStr}.html", "w")
    file.write out
    print "\n输出文件位于", Pathname.new(File.dirname(__FILE__)).realpath, "/", file.path, "\n"
    file.close

  end


end
