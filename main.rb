require './model/tw_author_info'
require './data_loader'
require './report_creator.rb'
require './spider/spider'
require 'time'

authorInfoList = loadAuthorListFromFile("studentlist.csv")



# p authorInfoList

report=ReportCreator.new(ARGV[0], ARGV[1])
report.setAuthorInfoList(authorInfoList)
report.setTitle("2017届思沃大讲堂文章统计")
report.start
report.out2Html
toAddr=["xn_shelly@qq.com", "18600064502@163.com", "zhangxingzhi777@163.com", "huangydyn@foxmail.com",
        "sunshy_129@sina.com", "137126846@qq.com", "395807491@qq.com", "627478667@qq.com",
        "zcf396720@163.com", "1174980997@qq.com", "jnliuxjtu@163.com", "qxlee65@126.com",
        "wulining441@outlook.com", "xautanyang@163.com", "13488233237@163.com",
        "695331215@qq.com", "chengxiuluo@gmail.com", "liuxinalice@163.com",
        "jiangle.he@foxmail.com", "18829290322@163.com", "wangdanna1995@outlook.com",
        "zhyingjia@163.com", "singleyoungtao@163.com", "283587202@qq.com", "Chauncey.ycx@gmail.com",
        "zh3070388082@163.com", "shamaoxiaogui@gmail.com", "1506622086@qq.com", "727809166@qq.com",
        "qin7zhen@126.com", "shao_nana@126.com", "751524851@qq.com", "825011869@qq.com",
        "1573872488@qq.com", "963054236@qq.com", "573186801@qq.com", "1262240943@qq.com",
        "gaolijuanxd@163.com", "18829042843@163.com", "393714009@qq.com", "hilishuangqi@hotmail.com",
        "425255202@qq.com", "jiayikai1018@163.com", "18829290140@163.com", "18829287015@163.com",
        "18792561236@163.com", "1586320567@qq.com", "1490313846@qq.com", "bme_ritter@foxmail.com",
        "libra1014tyb@163.com", "18829292695@163.com", "wy_b1995@163.com", "550047450@qq.com",
        "1370322806@qq.com", "tw-2017-lecture-volunteers@thoughtworks.com"]
# toAddr=["1586320567@qq.com"]
report.sendEmail("", toAddr)
report.sendToWeChatGroup
print "邮件群发成功！"