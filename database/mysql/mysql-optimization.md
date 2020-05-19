---
title: MySQL 索引优化
date: 2020-05-04
categories: 数据库
tags:
- MySQL
---


# MySQL 索引优化实战
> 索引可以包含一列或多列，如果是多列，列的顺序也十分重要；创建一个包含两列的索引，和创建两个一列的索引是大不相同的。

## 目录
1. 索引分类
2. 索引命名规范
3. 测试表SQL
4. 索引设计原则
4. 索引优化实战

## 1、索引分类
- 主键索引（Primary Key）
- 唯一索引（Unique  Key）
- 普通索引（Normal  Key）

## 2、索引命名规范
- 主键索引 pk_字段名
- 唯一索引 uk_字段名
- 普通索引 idx_字段名

## 3、测试表SQL
> 其中包含三个索引：（1）`ID` 主键索引；（2）`USERNAME` 列唯一索引；（3）`ID`,`USERNAME`,`NAME` 组合普通索引
```mysql
CREATE TABLE `org_user` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增id',
  `USERNAME` varchar(64) NOT NULL COMMENT '用户名',
  `NAME` varchar(128) DEFAULT NULL COMMENT '姓名',
  `AGE` tinyint(4) DEFAULT NULL COMMENT '年龄',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uk_username` (`USERNAME`) USING BTREE,
  KEY `idx_id_username_name` (`ID`,`USERNAME`,`NAME`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1016 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户表';

INSERT INTO `org_user` VALUES ('1000', 'muwq', '木婉清', '25');
INSERT INTO `org_user` VALUES ('1001', 'wang', '王语嫣', '23');
INSERT INTO `org_user` VALUES ('1002', 'ren', '任盈盈', '17');
INSERT INTO `org_user` VALUES ('1003', 'cheng', '程灵素', '14');
INSERT INTO `org_user` VALUES ('1004', 'zhou', '周芷若', '16');
INSERT INTO `org_user` VALUES ('1005', 'yulz', '俞莲舟', '19');
INSERT INTO `org_user` VALUES ('1006', 'song', '宋远桥', '20');
INSERT INTO `org_user` VALUES ('1007', 'yudy', '俞岱岩', '18');
INSERT INTO `org_user` VALUES ('1008', 'zhangsx', '张松溪', '26');
INSERT INTO `org_user` VALUES ('1009', 'zhangcs', '张翠山', '15');
INSERT INTO `org_user` VALUES ('1010', 'yin', '殷梨亭', '12');
INSERT INTO `org_user` VALUES ('1011', 'mo', '莫声谷', '21');
INSERT INTO `org_user` VALUES ('1012', 'qiao', '乔峰', '18');
INSERT INTO `org_user` VALUES ('1013', 'xu', '虚竹', '19');
INSERT INTO `org_user` VALUES ('1014', 'duan', '段誉', '20');
INSERT INTO `org_user` VALUES ('1015', 'murf', '慕容复', '21');
```

## 4、索引设计原则
- 适合加索引的列是where子句中的列，或者连接子句中指定的列
- 基数较小的类和区分度小的字段，索引效果较差，不宜建立索引
- 使用短索引，如果对长字符串增加索引，应指定一个前缀，能节省索引空间
- 更新频繁的字段不宜建立索引
- 多表关联时，要保证关联字段上一定有索引
- 不要过度索引

## 5、索引优化实战
> 有时候，表虽然有索引，但是并没被优化器选择使用。
> - 查看索引使用情况：`show status like 'Handler_read%'`
> - **Handler_read_key** 如果索引正在工作，Handler_read_key的值将很高。越高越好
> - **Handler_read_rnd_next** 数据文件中读取下一行的请求数。越低越好

1. 返回数据占比越低，越容易命中索引。
   - 如果查询的数据与全部数据的占比，大于 30%，那么索引的效果可能不好。

2. 前导模糊查询，不会命中索引
   - 反例：`EXPLAIN SELECT * FROM org_user WHERE USERNAME LIKE '%wang';`
   - 正例：`EXPLAIN SELECT * FROM org_user WHERE USERNAME LIKE 'wang%';`

3. 数据类型出现隐式转换，不会命中索引。尤其是字符串，要 '' 引起来
   - 反例：`EXPLAIN SELECT * FROM org_user WHERE USERNAME = 1;`
   - 正例：`EXPLAIN SELECT * FROM org_user WHERE USERNAME = '1';`

4. 复合索引，查询条件不满足索引最左原则，不会命中索引
   - `ALTER TABLE user ADD INDEX index_name (name,age,status);`
   - 注意下边两句，最左原则不是查询条件的顺序，而是索引字段顺序
   - ```EXPLAIN SELECT * FROM `org_user` WHERE `NAME` = '宋远桥' AND USERNAME = 'song';```
   - ```EXPLAIN SELECT * FROM `org_user` WHERE USERNAME = 'song' AND `NAME` = '宋远桥';```
   - 反例：```EXPLAIN SELECT * FROM `org_user` WHERE `NAME` = '宋远桥';```

5. union、in、or都能够命中索引，建议使用in
   - union：`EXPLAIN SELECT * FROM org_user WHERE USERNAME = 'wang' UNION ALL SELECT * FROM org_user WHERE USERNAME = 'song';`
   - in：`EXPLAIN SELECT * FROM org_user WHERE USERNAME IN ('wang', 'song');`
   - or：`EXPLAIN SELECT * FROM org_user WHERE USERNAME = 'wang' OR USERNAME = 'song';`

6. 用or分割开的条件
   > 如果or前的条件中列有索引，而后面的列中没有索引，那么涉及到的索引都不会被用到。
   > 因为or后面的条件列中没有索引，那么后面的查询肯定要走全表扫描，在存在全表扫描的情况下，就没有必要多一次索引扫描增加IO访问。
   - `EXPLAIN SELECT * FROM org_user WHERE USERNAME = 'wang' OR AGE = 18;`

7. 负向条件查询不能使用索引，可以优化为in查询
   > 负向条件有：!=、<>、not in、not exists、not like等。测试环境：MySQL 8.0
   - 经测试 `!=、<>、not in` 可以命中索引：
        - ```EXPLAIN SELECT * FROM org_user WHERE `USERNAME` != 'wang';```
        - ```EXPLAIN SELECT * FROM org_user WHERE `USERNAME` <> 'wang';```
        - ```EXPLAIN SELECT * FROM org_user WHERE `USERNAME` not in ('wang', 'admin');```
   - 负向条件 `not like、not exists` 不能命中缓存：
     - ```EXPLAIN SELECT * FROM org_user WHERE NOT EXISTS (SELECT * FROM org_user WHERE USERNAME = 'wang');```
     > EXISTS 语法：如上，如果子句返回 true，则查询全部；如果返回 false，则查询结果为空

8. 范围条件查询可以命中索引
   > 范围条件有：<、<=、>、>=、between等。
   - `ALTER TABLE user ADD INDEX idx_age (AGE);`
   - 单条件查询 `EXPLAIN SELECT * FROM org_user WHERE AGE > 18;`
     - 会命中：idx_age 
   - 多条件查询 `EXPLAIN SELECT * FROM org_user WHERE AGE > 18 AND ID > 1000;`
     - 会命中：主键ID索引 或者 idx_age 
     - 如果有两个范围列，则不能同时使用索引
   - 优先原则 `EXPLAIN SELECT * FROM org_user WHERE ID > 1000 AND AGE = 18;`
     - 会命中：idx_age（优先匹配等值查询列的索引）

9. 数据库执行计算不会命中索引
   > 计算逻辑应该尽量放到业务层处理，节省数据库的CPU的同时最大限度的命中索引。
   - `EXPLAIN SELECT * FROM org_user WHERE AGE > 18;`
   - `EXPLAIN SELECT * FROM org_user WHERE AGE+1 > 18;`

10. 利用覆盖索引进行查询，避免回表
    - ```EXPLAIN SELECT USERNAME, `NAME` FROM org_user WHERE USERNAME = 'wang';```
    - Extra 为 Using Index 代表从索引中查询。

11. 建立索引的列，不允许为 NULL
    - `IS NULL` 可以命中索引
    - `IS NOT NULL` 不能命中索引

