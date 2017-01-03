# TW_jianshu_report

Ruby爬虫统计简书用户的文章信息

## 使用方法

### 安装ruby相关环境

可以直接安装ruby，或者通过[rbenv](https://github.com/rbenv/rbenv)来管理ruby。

然后安装`bundler`:

```
gem install bundler
```

为了加速下载依赖库的速度，可以参考<http://gems.ruby-china.org/>页面使用国内镜像。

### 下载项目代码并运行

```
git clone https://github.com/geekeren/TW_jianshu_report.git
cd TW_jianshu_report/
bundle install
ruby main.rb 2016-12-18 2016-12-23
```

`ruby main.rb`后面是统计的开始与结束日期

注意：在mac进行`bundle install`的过程中，如果出现`nokogiri`相关的错误，可以运行`xcode-select --install`安装需要的依赖，然后重新`bundle install`。如果还无法解决的话，可以提issue。

## 项目文件

`view/default.tpl.html`是输出文件的模板，所以可以修改输出文件的样式布局 

## 输入文件

* `studentlist.csv`：用户列表文件，csv格式
* `data/jianshu.sqlite3`数据库文件：
 主要注意的是JSID是简书的用户ID，一堆字符串，ID是本项目自己的用户ID，从1开始，是整型，因为有些buddy的简书ID没有收集。
 每一行记录用户ID(简书用户主页URL `/users/`后面的字段)，用户姓名，小buddy姓名

## 输出文件

位于`out`文件夹下