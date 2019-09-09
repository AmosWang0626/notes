# 数据库及表操作

## 目录
- [增](#insert)
- [改](#update)
- [查](#select)
- [删](#delete)
- [注意](#notice)


## 新增insert
- 新增字段 `ALTER TABLE wmmm_user.member ADD CHANNEL_ID bigint(20) DEFAULT NULL COMMENT '注册来源渠道号';`


## 修改update
- 修改字段 `ALTER TABLE wmmm_user.member CHANGE COLUMN CHANNEL_ID CHANNEL_NO varchar(32) DEFAULT NULL COMMENT '注册来源渠道号';`
- 修改数据库密码 `update user set password=password('root') where user='root' and host='%';`


## 查询select
- MySQL查看字符集 `SHOW VARIABLES LIKE 'character%';`
- 查询数据库用户 `select User, Host, authentication_string from user;`
- 查看自数据库启动以来查询效率 `SHOW GLOBAL STATUS LIKE 'Handler_read%';`
- 查看数据库查询效率 `SHOW STATUS LIKE 'Handler_read%'`;
- 显示正在运行的线程 `SHOW PROCESSLIST;`

- 日期相关
```mysql
-- 当日
SELECT DAY(NOW()) CURRENT_DAY;
-- 当月 2019-09-09
SELECT DATE(NOW()) CURRENT_MONTH;
-- 当月 201909
SELECT DATE_FORMAT(NOW(), '%Y%m') CURRENT_MONTH;
-- 上个月 201908
SELECT DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH),'%Y%m') LAST_MONTH;
```

## 删除delete
- 清空表 `truncate table message_issue;`

## 注意notice

- 表名、字段名称大小写
    ```text
    - Oracle 表名、字段名统一要大写；
    - MySQL 表名、字段名统一要小写；
    ```
- MySQL是表名默认是区分大小写的
