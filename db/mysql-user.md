---
title: MySQL 创建用户
date: 2019-12-30
categories: 数据库
tags:
- MySQL
---


# MySQL 创建用户

## 1、授权（MySQL 8.0以下）

- `GRANT 权限 ON 数据库对象 TO 用户 IDENTIFIED BY 密码;`
- `GRANT ALL PRIVILEGES ON *.* TO 'root'@'180.117.75.5' IDENTIFIED BY 'zutEdu2018';`
- `GRANT ALL PRIVILEGES ON *.* TO 'root'@'180.117.75.5' IDENTIFIED BY 'zutEdu2018' WITH GRANT OPTION;`
  - 全部权限：`ALL` 或者 `ALL PRIVILEGES`
  - 详细权限：`select,insert,update,delete,create,drop,index,alter,grant,references,reload,shutdown,process,file`
  - 指定IP：`'root'@'185.117.75.5'`；所有IP：`'root'@'%'`
  - 可授权其他用户：`WITH GRANT OPTION`
  - 刷新配置：`flush privileges;`

## 2、授权（MySQL 8.0 +）

- 创建用户：`CREATE USER 'mall'@'%' IDENTIFIED BY 'zutEdu2018'`
- 授权：`GRANT ALL PRIVILEGES ON mall.* TO 'mall'@'%';`
- 可授权其他用户：`GRANT ALL PRIVILEGES ON mall.* TO 'mall'@'%' WITH GRANT OPTION;`
