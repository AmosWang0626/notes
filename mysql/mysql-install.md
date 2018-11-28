# MySQL 安装相关
## 安装MySQL 8.0+，在默认情况下Navicat不能直接连上
 - 原因可能是加密方式不一样
 - Navicat 使用的是旧的加密方式

## 解决办法：
 - ALTER USER 'root'@'localhost' IDENTIFIED BY 'password' PASSWORD EXPIRE NEVER;
 - ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root';
 - flush privileges;

# Windows MySQL

## 服务相关
    启动mysql服务，用net start mysql
    关闭mysql服务，用net stop mysql

## 进入MySQL数据库：
    mysql -h127.0.0.1 -uroot -proot
    mysql -hlocalhost -uroot -proot
    mysql -u root -p
    mysql -uroot -proot
    mysql -u root -proot

## 命令行操作
    1.显示所有的数据库，注意是databases：
        show databases;
    2.退出该数据库：
        exit;
    3.进入某数据库通过：
        use amos;
        show tables;	//显示所有的表
    4.显示MySQL版本：
        select version();
    5.显示当前时间：
        select now();
    6.显示字符串：
        select "welecome to my blog!";
    7.删除数据库、表
        drop table hello_table;
        drop database amos;
    8.查看表的结构
        desc entity;

## 防止中文乱码

### 1.创建数据库时
    CREATE DATABASE message
    CHARACTER SET 'utf8' COLLATE 'utf8_general_ci';
    
### 2.创建表时
    CREATE TABLE student (
        id varchar(12) NOT NULL PRIMARY KEY,
        name varchar(6) NOT NULL,
        age int(11),
        memo varchar(255)
    )ENGINE=InnoDB DEFAULT CHARSET=utf8;
    
### 3.连接数据库时
    jdbc:mysql://localhost:3306/message?useUnicode=true&characterEncoding=UTF-8;

## 创建表实例：
    use school;
    CREATE TABLE student (
    id int auto_increment PRIMARY KEY,
    name varchar(12) NOT NULL,
    age int(4),
    gender varchar(255)
    )
    ENGINE=InnoDB DEFAULT CHARSET=utf8;
    
    use school;
    CREATE TABLE loginuser (
    id int auto_increment PRIMARY KEY,
    user_name varchar(12) NOT NULL,
    user_pwd varchar(12) NOT NULL
    )
    ENGINE=InnoDB DEFAULT CHARSET=utf8;

## 创建数据库，并且里边包含一个主键和两个外键

    CREATE TABLE note_manage (
    manage_id varchar(12) PRIMARY KEY,
    user_id varchar(12),
    note_id varchar(12),
    comments varchar(255),
    FOREIGN KEY(user_id) REFERENCES note_user(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(note_id) REFERENCES note(note_id) ON DELETE CASCADE ON UPDATE CASCADE
    )
    ENGINE=InnoDB DEFAULT CHARSET=utf8;

## 通过Navicat建立MySQL的连接，
    连接名：任意
    主机IP：112.74.57.49
    端口：3306
    用户名：amos	//也即上边几句话中设置的
    密码：root	//同上