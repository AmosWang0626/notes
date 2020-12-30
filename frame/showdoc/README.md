---
title: Showdoc 结合 sqlite 重置密码
date: 2020-12-30
categories: 框架相关
tags:
- showdoc
---


# Showdoc 结合 sqlite 重置密码

> 官方命令执行报错 `docker exec showdoc php /var/www/html/index.php home/common/repasswd`，没辙，就通过下边方式重置吧

## 1. 主要思路

> showdoc 默认使用的 sqlite 数据库，重置密码，降维到修改数据库数据。

1. 创建一个新用户，拿到新用户加密后的密码

2. 修改管理员的密码

## 2. 如何使用 sqlite3

### 2.1 [Windows上安装Sqlite3](https://blog.csdn.net/ellen5203/article/details/90547657)

### 2.2 Sqlite 打开 showdoc.db 文件

> showdoc_data\html\Sqlite\showdoc.db.php

`sqlite3.exe showdoc.db.php`

### 2.3 获取新用户的密码

- 查看所有表 `.tables`

- 查看所有用户 `select * from user;`
  > `36|amoswang|2|||||a89da13684490eb9ec9e613f91d24d00||0|1609297947|1609298610`
  >
  > `a89da13684490eb9ec9e613f91d24d00` 也就是密码

### 2.4 设置管理员的密码

> 如果担心不保险，可以先更新下其他账号密码试下

`update user set password="a89da13684490eb9ec9e613f91d24d00" where username="amos.wang";`

`update user set password="a89da13684490eb9ec9e613f91d24d00" where username="showdoc";`

## 完