# Redis学习(2017.7.9)

----------
## Redis 安装
    由于redis是c++写的，需要下载安装包，并且编译

    编译c++环境安装
        yum install gcc-c++

    gcc安装成功

----------

阿里云安装更简单

1. yum install redis

2. 连接redis

   redis-cli

   首次安装肯定没启动，会报错Could not connect to Redis at 127.0.0.1:6379:    Connection refused not connected> 

3. 启动redis，并且设置开机启动

   service redis start 
   设置为开机自动启动
   chkconfig redis on

4. 连接redis

   redis-cli

5. 测试连接
   redis 127.0.0.1:6379> set key "hello world"
   OK
   redis 127.0.0.1:6379> get key
   "hello world"

6. 或者测试
   输入：ping
   输出：PONG即成功

安装完成

无响应，ctrl + c

----------

## 查看redis线程ps -ef | grep -i redis

    ps 进程查看命令
      -e 显示所有进程
      -f 全格式
    grep 一种强大的文本搜索工具(能使用正则表达式搜索文本)
      -i 不区分大小写地搜索，默认区分大小写

*****************************************************

停止redis redis-cli shutdown

启动redis redis-server /etc/redis.conf

*****************************************************

*****简单单条操作*****

增加：

set name AmosWang

删除：

del name

删除所有key:

flushdb

修改键名：

rename name new_name

修改值：

set name AmosWangDu

特殊用法：
此时会输出name的值，然后将name的值修改为AMos

getset name AMos

查询：

get name

查询全部：

keys *

查看是否存在

exists name

*****************************************************

*****Set集合操作*****

删除全部：flushdb

插入多条数据：

sadd set_many aa bb cc dd

查看该集合数据：

smembers set_many

删除一条数据：

srem set_many aa

增加一条数据:

sadd set_mant aa

增加相同的数据：

sadd set_many aa

不解释，肯定失败，set不允许重复

*****************************************************

*****List*****




