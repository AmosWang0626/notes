---
title: Docker 安装 MySQL
date: 2019-01-01
categories: 数据库
tags:
- Docker
- MySQL安装
---


# MySQL 安装相关

1. pull image（默认 MySQL 8.0+）
    - `docker pull mysql`

2. run mysql
    - `docker run -d -p 3306:3306 --name mysql -e MYSQL_ROOT_PASSWORD=@Qwert123 mysql`

3. 查看 MySQL 启动日志
    - `docker logs -f mysql`

4. 查看 MySQL 版本
    - `docker exec -it mysql mysql --version`
    > mysql  Ver 8.0.20 for Linux on x86_64 (MySQL Community Server - GPL)

5. exec mysql
    - `docker exec -it mysql mysql -uroot -p`

6. 改变密码加密策略（方便 Navicat 连接）
    - `use mysql;`
    - `ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '@Qwert123';`
    - `flush privileges;`

7. Navicat connect
    ```yaml
    ip: localhost
    port: 3306
    username: root
    password: @Qwert123
    ```
