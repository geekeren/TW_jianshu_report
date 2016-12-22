# TW_jianshu_report

Ruby爬虫统计简书用户的文章信息

## 使用方法

* 下载项目代码并运行


```
git clone https://github.com/geekeren/TW_jianshu_report.git
cd TW_jianshu_report/
bundle
 ruby main.rb 2016-12-18 2016-12-23
```

>ruby main.rb 后面是统计的开始与结束日期

##项目文件

view/default.tpl.html是输出文件的模板，所以可以修改输出文件的样式布局

##输入文件

**studentlist.csv**：用户列表文件，csv格式

* 每一行记录用户ID(简书用户主页URL /users/后面的字段)，用户姓名，小buddy姓名

##输出文件

 位于out文件夹下