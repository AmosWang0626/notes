---
title: 数据库表优化
date: 2019-01-01
categories: 数据库
tags:
- 索引
- SQL优化
- 数据库锁
---


# 数据库表优化

## 1、锁
### SELECT ... LOCK IN SHARE MODE 走的是IS锁 (意向共享锁)
即在符合条件的rows上都加了共享锁，这样的话，其他session可以读取这些记录，也可以继续添加IS锁，
但是无法修改这些记录直到你这个加锁的session执行完成(否则直接锁等待超时)。

### SELECT ... FOR UPDATE 走的是IX锁 (意向排它锁)
即在符合条件的rows上都加了排它锁，其他session也就无法在这些记录上添加任何的S锁或X锁。
如果不存在一致性非锁定读的话，那么其他session是无法读取和修改这些记录的，
但是innodb有非锁定读(快照读并不需要加锁)，for update之后并不会阻塞其他session的快照读取操作，
除了select ...lock in share mode和select ... for update这种显示加锁的查询操作。

通过对比，发现for update的加锁方式无非是比lock in share mode的方式
多阻塞了select...lock in share mode的查询方式，并不会阻塞快照读。

### 2、总结
通过对比，lock in share mode适用于两张表存在业务关系时的一致性要求，
for update适用于操作同一张表时的一致性要求。
