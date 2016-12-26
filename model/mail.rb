# encoding: UTF-8
require 'net/smtp'
require './lib/mailfactory'
# require 'wicked_pdf'
class Mail
  def initialize()

  end

  def sendMailFromHtmlFile(toName, toAddr, subject, fileName)
    mail = MailFactory.new()
    #加了join(',")后， 收件人在邮箱里看到的收件人列表为：xx1 <xx1@qq.com>; xx2<xx2@qq.com>
    #否则看到的是：xx1@qq.comxx2@qq.com  ，用户之间没有逗号分隔
    htmlFile=fileName
    mail.to = toAddr.join(';')
    mail.from = "思沃简书爬虫团队 <tw_report@wangbaiyuan.cn>"
    mail.subject = subject
    # pdfFile = WickedPdf.new.pdf_from_html_file(htmlFile)
    # File.open(fileName+".pdf", 'wb') do |file|
    #   file << pdfFile
    # end
    mail.attach(htmlFile,"text/plain","content-type:text/plain; charset=utf-8")
    htmlFile = open htmlFile
    htmlFileContent = htmlFile.read

    mail.html = "<div style=\"margin:15px;background:#FFF\">同学，#{subject}报告发布了！<br>如果本报告阅读体验不佳，请<span style=\"color:red;font-weight:bold\">下载查看附件</span>；邮件由系统发出，请勿回复！<br>
</div>"+htmlFileContent.force_encoding('utf-8')

    #  mail.attach("D://script//ruby//中文正常abc.doc")

    #另外声明一个接收人的地址列表

    Net::SMTP.start("smtp.exmail.qq.com", 25, "localhost", "tw_report@wangbaiyuan.cn", "Thoughtworks2017", :plain) { |smtp|
#     mail.to = toaddress
      smtp.send_message(mail.to_s(), "tw_report@wangbaiyuan.cn", toAddr)
    }
  end


end
