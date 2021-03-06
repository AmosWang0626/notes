---
title: 框架相关 redis
date: 2019-01-01
categories: 框架相关
tags:
- redis
---


# Redis学习(2017.7.9)

## 缓存相关问题
> 缓存虽好，用好更优

### 1.缓存雪崩
> 大量缓存同时失效，导致数据库压力瞬间增大，甚至宕机

- 均匀分布: 过期时间 = 基础过期时间 + 随机过期时间；
- 熔断机制: 设定阈值或监控服务，如果达到阈值(QPS,服务无法响应,服务超时)，则直接返回，不再调用目标服务；同时含检测机制，目标服务可正常使用时，则重置阈值，恢复使用；
- 隔离机制: 一个服务遇到问题不会影响其他服务。此处可以使用线程池来达到隔离的目的，当线程池执行拒绝策略后则直接返回，不再向线程池中增加任务;
- 限流机制: 和熔断机制类似。

### 2.缓存穿透
> 此时要查询的数据不存在,缓存无法命中所以需要查询完数据库,但是数据是不存在的,此时数据库肯定会返回空,也就无法将该数据写入到缓存中,那么每次对该数据的查询都会去查询一次数据库

- 布隆过滤: 我们可以预先将数据库里面所有的 key 全部存到一个大的 map 里面，然后在过滤器中过滤掉那些不存在的 key。但是需要考虑数据库的key是会更新的，此时需要考虑【数据库 --- map】的更新频率问题
- 缓存空值: 哪怕这条数据不存在但是我们任然将其存储到缓存中去,设置一个较短的过期时间即可,并且可以做日志记录,寻找问题原因

### 3.缓存预热
> 这是一种机制，在上线前先将需要缓存的数据放到缓存中去。可以留一个口子，定时刷新缓存。

### 4.缓存更新
- 定期更新
- 数据更新时更新，或数据更新时删除

### 5.缓存降级
> 服务降级是不得已而为之的，在关键的时候丢卒保帅，保证核心功能正常运行

- 服务拒绝: 直接拒绝掉非核心功能的所有请求,其实基本就是直接废弃掉某些模块；
- 服务延迟: 将请求加入到线程池中或队列中,延迟执行这些请求；
- 注意: 服务降级一定要有对应的恢复策略，不能降下去就不回来了，我们可以监测服务的状态，当状态适当时恢复服务的正常使用。

----------
## Redis 安装
- 由于redis是c++写的，需要下载安装包，并且编译
- 编译c++环境安装 `yum install gcc-c++`

### Docker

`docker run -d -p 6379:6379 --name redis -v /opt/redis/data:/data redis redis-server --appendonly yes --requirepass Amos@6379`

### 阿里云

1. 安装redis `yum install redis`
2. 连接redis `redis-cli`
    > 首次安装肯定没启动，会报错，继续如下操作即可。报错信息: 
    `Could not connect to Redis at 127.0.0.1:6379:Connection refused not connected`
3. 启动redis，并且设置开机启动
    - 启动redis `service redis start`
    - 设置为开机自动启动 `chkconfig redis on`
    - 停止redis `redis-cli shutdown`
    - 根据redis.conf启动redis `redis-server /etc/redis.conf`
4. 再次连接redis `redis-cli`
5. 测试安装
   - `set key "hello world"`
   - `get key`
   - `ping` 输出 pong 即成功
6. 无响应，Ctrl + C

## 查看redis线程ps -ef|grep -i redis
```text
ps 进程查看命令
  -e 显示所有进程
  -f 全格式

grep 一种强大的文本搜索工具(能使用正则表达式搜索文本)
  -i 不区分大小写地搜索，默认区分大小写
```

## Redis 实践

### 简单单条操作
- 增加: `set name AmosWang`
- 修改值: `set name AmosWangDu`
- 修改键名: `rename name new_name`
- 查询并修改: `getset name AMos`
- 删除: `del name`
- 删除所有key: `flushdb`
- 查询: `get name`
- 查询全部: `keys *`
- 查看是否存在 `exists name`

### Set集合操作
- 删除全部: `flushdb`
- 插入多条数据: `sadd set_many aa bb cc dd`
- 查看该集合数据: `smembers set_many`
- 删除一条数据: `srem set_many aa`
- 增加一条数据: `sadd set_mant aa`
- 增加相同的数据: `sadd set_many aa` (不解释，肯定失败，set不允许重复)

### List列表操作




