---
title: MySQL 用户管理
date: 2019-12-30
categories: 数据库
tags:
- MySQL
---


# MySQL 用户管理

## 1、授权

### 1.1 MySQL 8.0以下

- 基础授权 `GRANT 权限 ON 数据库对象 TO 用户 IDENTIFIED BY 密码;`

- `GRANT ALL PRIVILEGES ON *.* TO 'zzti'@'180.117.75.5' IDENTIFIED BY 'zutEdu2018';`

- 可为其他用户授权（基础授权 + `WITH GRANT OPTION;`）

- `GRANT ALL PRIVILEGES ON *.* TO 'zzti'@'180.117.75.5' IDENTIFIED BY 'zutEdu2018' WITH GRANT OPTION;`

### 1.2 MySQL 8.0+

- 创建用户设置密码 
- `CREATE USER 'zzti'@'%' IDENTIFIED BY 'zutEdu2018';`

- MySQL 8.0+ 使用旧有加密方式 `WITH mysql_native_password`
- `CREATE USER 'zzti'@'%' IDENTIFIED WITH mysql_native_password BY 'zutEdu2018';`

- 基础授权 `GRANT 权限 ON 数据库对象 TO 用户;`
- `GRANT ALL PRIVILEGES ON mall.* TO 'mall'@'%';`

- 可为其他用户授权（基础授权 + `WITH GRANT OPTION;`）
- `GRANT ALL PRIVILEGES ON mall.* TO 'mall'@'%' WITH GRANT OPTION;`

### 1.3 释义
- 全部权限：`ALL` 或者 `ALL PRIVILEGES`
- 详细权限：`select,insert,update,delete,create,drop,index,alter,grant,references,reload,shutdown,process,file`
- 指定IP：`'root'@'185.117.75.5'`；所有IP：`'root'@'%'`
- 数据库对象：所有数据库`.`；指定数据库：`db_name.*`；指定表：`db_name.table_name`
- 可授权其他用户：`WITH GRANT OPTION`
- MySQL 8.0之前加密方式：`WITH mysql_native_password`
- 刷新配置：`flush privileges;`


## 2、删除用户

- `drop user 'zzti';`

## 3、查看权限

- `SHOW GRANTS FOR 'zzti';`