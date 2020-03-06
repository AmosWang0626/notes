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

## 1、索引
- 查询：
  - ```SELECT * FROM `now_address` WHERE MEMBER_ID = 11111 AND `STATUS` = 1;```
  - 时间: 0.005s

- 创建多行索引：
  - ```CREATE INDEX idx_address ON `now_address`(`MEMBER_ID` , `STATUS`);```

- 查询：
  - ```SELECT * FROM `now_address` WHERE MEMBER_ID = 11111 AND `STATUS` = 1;```
  - 时间：0.001s

### 1.1 索引基础
- 索引可以包含一列或多列，如果是多列，列的顺序也十分重要；创建一个包含两列的索引，和创建两个一列的索引是大不相同的。

### 1.2索引设计原则
- 适合加索引的列是where子句中的列，或者连接子句中指定的列
- 基数较小的类和区分度小的字段，索引效果较差，不宜建立索引
- 使用短索引，如果对长字符串增加索引，应指定一个前缀，能节省索引空间
- 更新频繁的字段不宜建立索引
- 多表关联时，要保证关联字段上一定有索引
- 不要过度索引

### 1.3优化实战
> 有时候，表格虽然有索引，但是并没被优化器选择使用。
> - 查看索引使用情况：`show status like 'Handler_read%'`
> - **Handler_read_key** 如果索引正在工作，Handler_read_key的值将很高。越高越好
> - **Handler_read_rnd_next** 数据文件中读取下一行的请求数。越低越好

1. 如果使用索引比扫描全表还慢，不会命中索引
   - 返回数据占比越低，越容易命中索引。记住这个范围——30%

2. 前导模糊查询，不会命中索引
   - 反例：`EXPLAIN SELECT * FROM user WHERE name LIKE '%s%';`
   - 正例：`EXPLAIN SELECT * FROM user WHERE name LIKE 's%';`

3. 数据类型出现隐式转换，不会命中索引。尤其是字符串，要 '' 引起来
   - 反例：`EXPLAIN SELECT * FROM user WHERE name=1;`
   - 正例: `EXPLAIN SELECT * FROM user WHERE name='1';`

4. 复合索引，查询条件不满足最左原则，不会命中索引
   - `ALTER TABLE user ADD INDEX index_name (name,age,status);`
   - 注意下边两句，最左原则不是查询条件的顺序，而是索引字段顺序
   - `EXPLAIN SELECT * FROM user WHERE name='hello' AND status=1;`
   - `EXPLAIN SELECT * FROM user WHERE status=1 AND name='hello';`
   - 反例：`EXPLAIN SELECT * FROM user WHERE status=2 ;`

5. union、in、or都能够命中索引，建议使用in
   - union：`EXPLAIN SELECT * FROM user WHERE status=1 UNION ALL SELECT * FROM user WHERE status = 2;`
   - in：`EXPLAIN SELECT * FROM user WHERE status IN (1,2);`
   - or：`EXPLAIN SELECT*FROM user WHERE status=1 OR status=2;`

6. 用or分割开的条件
   > 如果or前的条件中列有索引，而后面的列中没有索引，那么涉及到的索引都不会被用到。因为or后面的条件列中没有索引，那么后面的查询肯定要走全表扫描，在存在全表扫描的情况下，就没有必要多一次索引扫描增加IO访问。
   - `EXPLAIN SELECT * FROM payment WHERE customer_id = 203 OR amount = 3.96;`

7. 负向条件查询不能使用索引，可以优化为in查询
   > 负向条件有：!=、<>、not in、not exists、not like等。
   - 负向条件不能命中缓存：
     - `EXPLAIN SELECT * FROM user WHERE status !=1 AND status != 2;`
   - 可以优化为in查询，但是前提是区分度要高，返回数据的比例在30%以内：
     - `EXPLAIN SELECT * FROM user WHERE status IN (0,3,4);`

8. 范围条件查询可以命中索引。
   > 范围条件有：<、<=、>、>=、between等。
   - `ALTER TABLE user ADD INDEX index_status (status);`
   - `ALTER TABLE user ADD INDEX index_age (age);`
   - `EXPLAIN SELECT * FROM user WHERE status>5;`
     - 会命中：index_status 
   - `EXPLAIN SELECT * FROM user WHERE status>5 AND age<24;`
     - 会命中：index_status  或者 index_age 
     - 如果有两个范围列，则不能同时使用索引
   - `EXPLAIN SELECT * FROM user WHERE status>5 AND age=24;`
     - 会命中：index_age 
     - 优先匹配等值查询列的索引

9. 数据库执行计算不会命中索引
   > 计算逻辑应该尽量放到业务层处理，节省数据库的CPU的同时最大限度的命中索引。
   - `EXPLAIN SELECT * FROM user WHERE age>24;`
   - `EXPLAIN SELECT * FROM user WHERE age+1>24;`

10. 利用覆盖索引进行查询，避免回表
    - `EXPLAIN SELECT status FROM user where status=1;`
    - Extra 为 Using Index 代表从索引中查询。

11. 建立索引的列，不允许为null
    - IS NULL可以命中索引
    - IS NOT NULL不能命中索引


## 2、锁
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

### 总结
通过对比，lock in share mode适用于两张表存在业务关系时的一致性要求，
for update适用于操作同一张表时的一致性要求。
