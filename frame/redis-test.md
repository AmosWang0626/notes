---
title: 框架相关 redis 八大数据结构
date: 2020-01-13
categories: 框架相关
tags:
- redis
---


# Redis 八大数据结构
1. 字符串 `get/set/del/rename/getset`
2. Hash `hget/hset/hdel/hlen/hkeys/hexists/hgetall/hvals/hincrby/hincrbyfloat/hsetnx/hscan/hmset/hmget`
3. 列表 `blpop/brpop/brpoplpush/lindex/linsert/llen/lpop/lpush/lpushx/lrange/lrem/lset/ltrim/rpop/rpoplpush/rpush/rpushx`
4. 集合 ``
5. 有序集合 ``
6. 字符串位操作 bitmaps `setbit/getbit/bitcount/bitpos`
7. 基数统计的算法 HyperLogLog ``
8. 地理空间,索引半径查询（geospatial） 

### 简单单条操作
- 增加: `set key value`
- 查询: `get key`
- 修改值: `set key value2`
- 修改键: `rename key key2`
- 查询并修改: `getset key2 amos`
- 删除: `del key2`
- 删除所有key: `flushdb`
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


### xxx
> 因为 HyperLogLog 只会根据输入元素来计算基数，而不会储存输入元素本身，所以 HyperLogLog 不能像集合那样，返回输入的各个元素。
