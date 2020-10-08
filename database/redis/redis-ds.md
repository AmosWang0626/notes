---
title: 框架相关 redis 八大数据结构
date: 2020-01-13
categories: 框架相关
tags:
- redis
---


# Redis 八大数据结构
1. String字符串 
    - `get/set/del/rename/getset`
2. Hash哈希表
    - `hget/hset/hdel/hlen/hkeys/hexists/hgetall/hvals/hincrby/hincrbyfloat/hsetnx/hscan/hmset/hmget`
3. List列表
    - `blpop/brpop/brpoplpush/lindex/linsert/llen/lpop/lpush/lpushx/lrange/lrem/lset/ltrim/rpop/rpoplpush/rpush/rpushx`
4. Set集合
    - `sadd/scard/sdiff/sdiffstore/sinter/sinterstore/sismember/smembers/smove/spop/srandmember/srem/sunion/sunionstore/sscan`
5. Sorted-Set有序集合
    - `zadd/zcard/zcount/zincrby/zinterstore/zlexcount/zrange/zrangebylex/zrangebyscore/zrank/zrem/zremrangebylex/zremrangebyrank/zremrangebyscore/zrevrange/zrevrangebyscore/zrevrank/zscore/zunionstore/zscan`
6. Bitmaps位图
    - `setbit/getbit/bitcount/bitpos`
7. HyperLogLog基数统计的算法
    - `pfadd/pfcount/pfmerge`
8. GeoSpatial地理空间
    - `geoadd/geodist/geohash/geopos/georadius/georadiusbymember`

## 1、String字符串
- 增加: `set key value`
- 查询: `get key`
- 修改值: `set key value2`
- 修改键: `rename key key2`
- 查询并修改: `getset key2 amos`
- 删除: `del key2`
- 删除所有key: `flushdb`
- 查询全部: `keys *`
- 查看是否存在 `exists name`
- 设置过期时间(秒) `setex key_name 60 "this is value"`
- 查看剩余过期时间(ttl:单位秒; pttl:单位毫秒) `ttl key_name` `pttl key_name`

## 2、Hash哈希表
- 特别适合存储对象
- 给指定哈希表添加field-value
    - 添加单个field-value
        - `hset user1 name amos`
        - `hset user1 age 18`
    - 添加多个field-value
        - `hset user2 name amos.wang age 19 desc "this is description"`
- 获取指定Key中field的值 `hget user1 age`
- 获取指定Key所有field-value `hget user1`
- 查看所有Key `keys user*` 或者 `keys *`
- 删除一个或多个中的field `hdel user2 desc`
- 查看哈希表field是否存在 `hexists user2 desc`
- 同时添加多个field-value `hmset user3 name amos age 18 phone 18937128888`
- 同时获取多个field `hmget user3 name age phone`
- 获取哈希表field-value个数 `hlen user3`
- 获取哈希表所有field `hkeys user3`
- 获取哈希表所有value `hvals user3`

## 3、List列表
- lpush/rpush 从左边push/从右边push
- 从左插入到列表 `lpush citys beijing shanghai guangzhou tianjin dengzhou`
- 从右插入到列表 `rpush citys shenzhen zhengzhou`
- 获取这个列表 `lrange citys 0 -1`
    ```text
    1) "dengzhou"
    2) "tianjin"
    3) "guangzhou"
    4) "shanghai"
    5) "beijing"
    6) "shenzhen"
    7) "zhengzhou"
    ```
- 列表数量 `llen citys`
- 从左弹出第一个元素 `lpop citys` "dengzhou"
- 从右弹出第一个元素 `rpop citys` "zhengzhou"

## 4、Set集合
- 删除全部: `flushdb`
- 插入多条数据: `sadd set_many aa bb cc dd`
- 查看该集合数据: `smembers set_many`
- 查看item是否存在: `sismember set_many ee`
- 删除一条数据: `srem set_many aa`
- 增加一条数据: `sadd set_mant aa`
- 增加相同的数据(失败,set不允许重复): `sadd set_many aa` 

## 5、Sorted-Set有序集合
- 添加 `zadd sort_number 5 five 4 four 3 three 1 one 2 two`
- 正向遍历不带分数 `zrange sort_number 0 -1`
- 正向遍历带分数 `zrange sort_number 0 -1 WITHSCORES`
- 逆向遍历带分数 `zrevrange sort_number 0 -1 WITHSCORES`
- 正向遍历根据分数区间 1 < n <= 4 `zrangebyscore sort_number (1 4`
- 逆向遍历根据分数区间 1 < n <= 4 `zrevrangebyscore sort_number 4 (1`
- 获取某个item下标(从0开始) `zrank sort_number four`
- 删除一个或多个元素 `zrem sort_number two`
- 根据item下标删除一个或多个元素 `zremrangebyrank sort_number 0 2`
- 根据分数区间删除一个或多个元素(包含临界值) `zremrangebyscore sort_number 3 5`

## 6、Bitmaps字符串位操作
> 0 0 0 0 0 0 0 0 0 0 0 0
>
> [Fast, easy, realtime metrics using Redis bitmaps](https://blog.getspool.com/2011/11/29/fast-easy-realtime-metrics-using-redis-bitmaps/)
- 一个大的bit集合，其中 1字节=8位(1byte=8bit)
- 具体操作如下: `setbit`/`getbit`/`bitpos`/`bitcount`

    ```shell script
    redis> setbit bit888 1 1
    (integer) 0
    redis> setbit bit888 3 1
    (integer) 0
    redis> setbit bit888 5 1
    (integer) 0
    redis> getbit bit888 0
    (integer) 0
    redis> getbit bit888 1
    (integer) 1
    redis> bitpos bit888 0
    (integer) 0
    redis> bitpos bit888 1
    (integer) 1
    redis> bitcount bit888
    (integer) 3
    // 下边内容, 和实际数量不符, 故 bitcount 不建议使用区间
    redis> bitcount bit888 0 3
    (integer) 3
    redis> bitcount bit888 0 0
    (integer) 3
    ```

## 7、HyperLogLog基数统计的算法
> HyperLogLog是Redis的高级数据结构，它在做基数统计的时候非常有用，每个HyperLogLog的键可以计算接近2^64不同元素的基数，而大小只需要12KB。
>
> 因为HyperLogLog只会根据输入元素来计算基数，而不会储存输入元素本身，所以HyperLogLog不能像集合那样，返回输入的各个元素。
- 添加 `pfadd nosql redis mongodb` `pfadd sql mysql oracle db2`
- 合并 `pfmerge db nosql sql`
- 计算COUNT `pfcount db`
- 具体操作如下
    ```shell script
    redis> pfadd nosql redis mongodb
    (integer) 1
    redis> pfadd sql mysql oracle db2
    (integer) 1
    redis> pfmerge db nosql sql
    OK
    redis> pfcount db
    (integer) 5
    redis> pfcount sql
    (integer) 3
    redis> pfcount nosql
    (integer) 2
    ```

## 8、GeoSpatial地理空间,索引半径查询

