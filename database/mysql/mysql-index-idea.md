---
title: InnoDB 单列索引查主键会回表吗
date: 2021-06-26
categories: 数据库
tags:
- MySQL
---

# InnoDB 单列索引查主键会回表吗 ？

> 大家可能会想，会吧，本文结论是，会的。

## 步骤

- 建表、建索引
- explain（查看执行计划）

## 建表、建索引

```mysql
CREATE TABLE `hi_user` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `gender` tinyint DEFAULT NULL,
  `age` int DEFAULT NULL,
  `description` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
```

```mysql
insert into hi_user(name, gender, age, description) value('amos01', 1, 21, 'this is desc 1');
insert into hi_user(name, gender, age, description) value('amos02', 1, 22, 'this is desc 2');
insert into hi_user(name, gender, age, description) value('amos03', 1, 23, 'this is desc 3');
insert into hi_user(name, gender, age, description) value('amos04', 1, 24, 'this is desc 4');
insert into hi_user(name, gender, age, description) value('amos05', 1, 25, 'this is desc 5');
insert into hi_user(name, gender, age, description) value('amos06', 1, 26, 'this is desc 6');
insert into hi_user(name, gender, age, description) value('amos07', 1, 27, 'this is desc 7');
insert into hi_user(name, gender, age, description) value('amos08', 1, 28, 'this is desc 8');
insert into hi_user(name, gender, age, description) value('amos09', 1, 29, 'this is desc 9');
insert into hi_user(name, gender, age, description) value('amos10', 1, 20, 'this is desc 0');
```

## 查看执行计划

> 只要能看到 Using index，就能说明使用了覆盖索引，也即无需回表查询。

### 1. 精确查询

`EXPLAIN select id from hi_user where name = 'amos10';`

| id | select_type | table   | partitions | type | possible_keys | key      | key_len | ref   | rows | filtered | Extra       |
|----|-------------|---------|------------|------|---------------|----------|---------|-------|------|----------|-------------|
|  1 | SIMPLE      | hi_user | NULL       | ref  | idx_name      | idx_name | 258     | const |    1 |   100.00 | Using index |

**划重点：Extra 为 Using index**

`EXPLAIN select age from hi_user where name = 'amos10';`

| id | select_type | table   | partitions | type | possible_keys | key      | key_len | ref   | rows | filtered | Extra |
|----|-------------|---------|------------|------|---------------|----------|---------|-------|------|----------|-------|
|  1 | SIMPLE      | hi_user | NULL       | ref  | idx_name      | idx_name | 258     | const |    1 |   100.00 | NULL  |

**划重点：Extra 为 NULL**

### 2. Like查询

`EXPLAIN select id from hi_user where name like 'amos%';`

| id | select_type | table   | partitions | type  | possible_keys | key      | key_len | ref  | rows | filtered | Extra                    |
|----|-------------|---------|------------|-------|---------------|----------|---------|------|------|----------|--------------------------|
|  1 | SIMPLE      | hi_user | NULL       | index | idx_name      | idx_name | 258     | NULL |   10 |   100.00 | Using where; Using index |

**划重点：Extra 为 Using where; Using index**

`EXPLAIN select age from hi_user where name like 'amos%';`

| id | select_type | table   | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra       |
|----|-------------|---------|------------|------|---------------|------|---------|------|------|----------|-------------|
|  1 | SIMPLE      | hi_user | NULL       | ALL  | idx_name      | NULL | NULL    | NULL |   10 |   100.00 | Using where |

**划重点：Extra 为 Using where**

### 3. 加个真正的覆盖索引试试吧

`ALTER TABLE hi_user ADD INDEX idx_name_age (name, age);`

`EXPLAIN select age from hi_user where name like 'amos%';`

| id | select_type | table   | partitions | type  | possible_keys         | key          | key_len | ref  | rows | filtered | Extra                    |
|----|-------------|---------|------------|-------|-----------------------|--------------|---------|------|------|----------|--------------------------|
|  1 | SIMPLE      | hi_user | NULL       | index | idx_name,idx_name_age | idx_name_age | 263     | NULL |   10 |   100.00 | Using where; Using index |

**划重点：Extra 为 Using where; Using index**

## 好啦，验证完毕。

### 文末小彩蛋

- `docker run -d -p 3306:3306 --name mysql -e MYSQL_ALLOW_EMPTY_PASSWORD=yes mysql`
- `docker exec -it mysql mysql -uroot -p`

- 上边的表格咋搞的呢，手工画？不不不，从命令行执行结果里边复制的，把 `+` 统一替换成 `|`，然后删掉上下两行即可，真香。