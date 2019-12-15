---
title: DB 表结构操作
date: 2019-01-01
categories: 数据库
tags:
- 表操作
---


# DB 表相关操作

## 目录
- [新增](#新增insert)
- [修改](#修改update)
- [查询](#查询select)
- [删除](#删除delete)
- [注意](#注意notice)


## 新增insert
- 新增字段 `ALTER TABLE wmmm_user.member ADD CHANNEL_ID bigint(20) DEFAULT NULL COMMENT '注册来源渠道号';`
- 默认设置创建时间 `CREATE_TIME datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'`
- 默认设置修改时间 `UPDATE_TIME datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间'`
- 注: 数据库增加字段 `ADD COLUMN` 是错的，直接 `ADD` 即可

## 修改update
- 修改字段 `ALTER TABLE wmmm_user.member CHANGE COLUMN CHANNEL_ID CHANNEL_NO varchar(32) DEFAULT NULL COMMENT '注册来源渠道号';`
- 修改数据库密码 `update user set password=password('root') where user='root' and host='%';`


## 查询select
- MySQL查看字符集 `SHOW VARIABLES LIKE 'character%';`
- 查询数据库用户 `select User, Host, authentication_string from user;`
- 查看自数据库启动以来查询效率 `SHOW GLOBAL STATUS LIKE 'Handler_read%';`
- 查看数据库查询效率 `SHOW STATUS LIKE 'Handler_read%'`;
- 显示正在运行的线程 `SHOW PROCESSLIST;`

- 根据条件筛选表
```xml
<mysql>
	SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE UPPER(TABLE_NAME) LIKE UPPER('DEV_LOG_XXX_SEARCH_%')
	AND UPPER(TABLE_SCHEMA) = UPPER(DATABASE ()) ORDER BY TABLE_NAME DESC
</mysql>
<mssql>
	SELECT Name FROM SysObjects where Name LIKE 'DEV_LOG_XXX_SEARCH_%' ORDER BY Name DESC
</mssql>
<def>
	SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME LIKE 'DEV_LOG_XXX_SEARCH_%' ORDER BY TABLE_NAME DESC
</def>
```

## 删除delete
- 清空表 `truncate table message_issue;`
- 删除字段 `alter table message_issue DROP COLUMN "DOWNLOAD_FLAG";`

## 注意notice

- 表名、字段名称大小写
    ```text
    - Oracle 表名、字段名统一要大写；
    - MySQL 表名、字段名统一要小写；
    ```
- MySQL是表名默认是区分大小写的
